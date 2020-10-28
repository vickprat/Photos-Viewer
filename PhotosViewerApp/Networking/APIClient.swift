//
//  APIClient.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import Foundation
import UIKit

protocol NetworkService {

    @discardableResult
    func dataRequest<T: Decodable>(_ endPoint: APIEndPoint, objectType: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask

    @discardableResult
    func downloadRequest(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDownloadTask
}

final class APIClient: NetworkService {

    private let session: URLSession

    static var defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        return URLSession(configuration: configuration)
    }()

    init(session: URLSession = APIClient.defaultSession) {
        self.session = session
    }

    @discardableResult
    func dataRequest<T: Decodable>(_ endPoint: APIEndPoint, objectType: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        let request = endPoint.asURLRequest()
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(Result.failure(error))
            }
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let jsonObject = try JSONDecoder().decode(objectType, from: data)
                    completion(Result.success(jsonObject))
                } catch {
                    completion(Result.failure(error))
                }
            }
        }
        dataTask.resume()
        return dataTask
    }

    @discardableResult
    func downloadRequest(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDownloadTask {
        let downloadTask = self.session.downloadTask(with: url) { (location: URL?, response: URLResponse?, error: Error?) in
            if let error = error {
                completion(.failure(error))
            }
            if let location = location, let data = try? Data(contentsOf: location), let image = UIImage(data: data) {
                completion(.success(image))
            }
        }
        downloadTask.resume()
        return downloadTask
    }
}
