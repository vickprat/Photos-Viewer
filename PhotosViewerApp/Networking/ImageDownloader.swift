//
//  ImageDownloader.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import Foundation
import UIKit

typealias ImageDownloadCompletionHander = ((UIImage?, IndexPath?, URL, Error?) -> Void)

final class ImageDownloader {

    private let imageCache = NSCache<NSString, UIImage>()
    private let network: NetworkService = APIClient()

    lazy var downloadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "com.async.image.downloadQueue"
        queue.maxConcurrentOperationCount = 4
        queue.qualityOfService = .userInitiated
        return queue
    }()

    static let shared = ImageDownloader()

    private init() {}

    func downloadImage(withURL imageURL: URL, indexPath: IndexPath?, completion: @escaping ImageDownloadCompletionHander) {
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            completion(cachedImage, indexPath, imageURL, nil)
        } else if let existingImageOperations = downloadQueue.operations as? [ImageOperation],
            let imgOperation = existingImageOperations.first(where: {
                return ($0.imageURL == imageURL) && $0.isExecuting && !$0.isFinished
            }) {
            imgOperation.queuePriority = .high
        } else {
            let imageOperation = ImageOperation(with: imageURL, network: network)
            imageOperation.queuePriority = .veryHigh
            imageOperation.imageDownloadCompletionHandler = { [unowned self] result in
                switch result {
                case let .success(image):
                    self.imageCache.setObject(image, forKey: imageURL.absoluteString as NSString)
                    completion(image, indexPath, imageURL, nil)
                case let .failure(error):
                    completion(nil, indexPath, imageURL, error)
                }
            }
            downloadQueue.addOperation(imageOperation)
        }
    }

    func changeDownloadPriority(for imageURL: URL) {
        guard let ongoingImageOperations = downloadQueue.operations as? [ImageOperation] else {
            return
        }
        let imageOperations = ongoingImageOperations.filter {
            $0.imageURL.absoluteString == imageURL.absoluteString && $0.isFinished == false && $0.isExecuting == true
        }
        guard let operation = imageOperations.first else {
            return
        }
        operation.queuePriority = .low
    }

    func cancelAll() {
        downloadQueue.cancelAllOperations()
    }

    func cancelOperation(imageUrl: URL) {
        if let imageOperations = downloadQueue.operations as? [ImageOperation],
            let operation = imageOperations.first(where: { $0.imageURL == imageUrl }) {
            operation.cancel()
        }
    }
}
