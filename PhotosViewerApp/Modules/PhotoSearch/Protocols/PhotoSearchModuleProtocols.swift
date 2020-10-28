//
//  PhotoSearchModuleProtocols.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import Foundation
import UIKit

protocol PhotoSearchRouterInput: AnyObject {
    func showPhotoDetails(with imageUrl: URL)
}
