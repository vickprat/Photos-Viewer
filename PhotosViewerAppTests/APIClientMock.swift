//
//  APIClientMock.swift
//  PhotosViewerAppTests
//
//  Created by pratvick on 2020/10/30.
//

import Foundation
import UIKit
@testable import PhotosViewerApp

final class APIClientMock: NetworkService {

    func dataRequest<T>(_ endPoint: APIEndPoint, objectType: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask where T : Decodable {
        if case PhotoSearchAPI.search(query: "nature", page: 1) = endPoint {
            let bundle = Bundle(for: type(of: self))
            let fileUrl = bundle.url(forResource: "TestData", withExtension: "json")!
            let data = try! Data(contentsOf: fileUrl)
            let json = try! JSONDecoder().decode(objectType, from: data)
            completion(Result.success(json))
        } else if case PhotoSearchAPI.search(query: "nature", page: -1) = endPoint {
            let error = NSError.init(domain: "Invalid status code", code: 401, userInfo: nil)
            completion(Result.failure(error))
        } else if case PhotoSearchAPI.search(query: "dfdfdf", page: 1) = endPoint {
            let error = NSError.init(domain: "Empty data", code: 0, userInfo: nil)
            completion(Result.failure(error))
        }
        return URLSessionDataTask()
    }

    func downloadRequest(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDownloadTask {
        if url.absoluteString == "https://farm2.static.flickr.com/100/12345_/12345.jpg" {
            let image = UIImage(named: "placeholderImage")!
            completion(Result.success(image))
        } else {
            let error = NSError.init(domain: "Something went wrong", code: 0, userInfo: nil)
            completion(Result.failure(error))
        }

        return URLSessionDownloadTask()
    }
}
