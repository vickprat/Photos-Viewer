//
//  ImageOperation.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import UIKit

final class ImageOperation: Operation {

    var imageDownloadCompletionHandler: ((Result<UIImage, Error>) -> Void)?

    public let imageURL: URL
    private let network: NetworkService
    private var downloadTask: URLSessionDownloadTask?

    init(with imageURL: URL, network: NetworkService) {
        self.imageURL = imageURL
        self.network = network
    }

    private enum OperationState: String, Equatable {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"
    }

    private var _state = OperationState.ready {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: _state.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: _state.rawValue)
        }
    }

    private var state: OperationState {
        get {
            return _state
        }
        set {
            _state = newValue
        }
    }

    override var isReady: Bool {
        return state == .ready && super.isReady
    }

    override var isExecuting: Bool {
        return state == .executing
    }

    override var isFinished: Bool {
        return state == .finished
    }

    override func start() {
        if isCancelled {
            finish()
            return
        }

        if !isExecuting {
            state = .executing
        }

        main()
    }

    func finish() {
        if isExecuting {
            state = .finished
        }
    }

    override func cancel() {
        downloadTask?.cancel()
        finish()
        super.cancel()
    }

    override func main() {
        downloadImage()
    }

    private func downloadImage() {
        downloadTask = network.downloadRequest(imageURL, completion: { [weak self] (result: Result<UIImage, Error>) in
            self?.imageDownloadCompletionHandler?(result)
            self?.finish()
        })
    }
}
