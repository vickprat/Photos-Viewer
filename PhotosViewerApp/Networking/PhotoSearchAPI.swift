//
//  PhotoSearchAPI.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import Foundation

enum PhotoSearchAPI: APIEndPoint, URLRequestConvertible {
    case search(query: String, page: Int)
}

extension PhotoSearchAPI {

    var baseURL: URL {
        return URL(string: APIConstants.flickrAPIBaseURL)!
    }

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/services/rest/"
    }

    var parameters: [String : Any] {
        switch self {
        case let .search(query, page):
            return [
                "method": "flickr.photos.search",
                "api_key": APIConstants.flickrAPIKey,
                "format": "json",
                "nojsoncallback": 1,
                "safe_search": 1,
                "text": query,
                "page": page,
                "per_page": Constants.defaultPageSize
            ]
        }
    }

}
