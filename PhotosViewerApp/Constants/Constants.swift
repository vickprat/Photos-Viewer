//
//  Constants.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import Foundation
import UIKit

//MARK: String Constants
enum Strings {
    static let PhotoSearchTitle = "Photo Search"
    static let placeholder = "Search photos..."
    static let cancel = "Cancel"
    static let ok = "Ok"
    static let retry = "Retry"
    static let error = "Error"
    static let close = "close"
}

//MARK: Numeric Constants
enum Constants {
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    static let defaultSpacing: CGFloat = 1
    static let numberOfColumns: CGFloat = 3
    static let defaultPageNum: Int = 0
    static let defaultTotalCount: Int = 0
    static let defaultPageSize: Int = 20
}

//MARK: NetworkAPI Constants
enum APIConstants {
    static let flickrAPIBaseURL = "https://api.flickr.com"
    static let flickrAPIKey = "8ccbe2b3188bff9cc1a71c79feb648cc"
}
