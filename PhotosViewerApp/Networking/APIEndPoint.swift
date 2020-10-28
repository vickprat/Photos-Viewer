//
//  APIEndPoint.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol APIEndPoint: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var headers: [String: String]? { get }
}

extension APIEndPoint {
    var headers: [String: String]? {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
}

protocol URLRequestConvertible {
    func asURLRequest() -> URLRequest
}

extension URLRequestConvertible where Self: APIEndPoint {

    func asURLRequest() -> URLRequest {
        var components = URLComponents(string: baseURL.absoluteString)
        components?.path = path
        components?.queryItems = queryItems(from: parameters)

        if let url = components?.url {
            var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
            request.httpMethod = method.rawValue
            request.setHeaders(headers)
            return request
        } else {
            // It could be done in a better way.
            let url = URL(fileURLWithPath: "unknownn")
            return URLRequest.init(url: url)
        }
    }

    func queryItems(from params: [String: Any]) -> [URLQueryItem] {
        let queryItems: [URLQueryItem] = params.compactMap { parameter -> URLQueryItem? in
            var result: URLQueryItem?
            if let intValue = parameter.value as? Int {
                result = URLQueryItem(name: parameter.key, value: String(intValue))
            } else if let stringValue = parameter.value as? String {
                result = URLQueryItem(name: parameter.key, value: stringValue)
            } else if let boolValue = parameter.value as? Bool {
                let value = boolValue ? "1" : "0"
                result = URLQueryItem(name: parameter.key, value: value)
            } else {
                return nil
            }
            return result
        }
        return queryItems
    }
}

extension URLRequest {
    mutating func setHeaders(_ headers: [String: String]? = nil) {
        guard let headers = headers else {
            return
        }
        headers.forEach {
            setValue($0.key, forHTTPHeaderField: $0.value)
        }
    }
}
