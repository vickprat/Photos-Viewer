//
//  PhotoSearchModuleProtocols.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import Foundation
import UIKit


protocol PhotoSearchInteractorInput: AnyObject {
    var presenter: PhotoSearchInteractorOutput? { get set }
    func fetchPhotos(for imageName: String, pageNum: Int)
}

protocol PhotoSearchInteractorOutput: AnyObject  {
    func photoSearchSuccess(_ photos: Photos)
    func photoSearchError(_ error: Error)
}

protocol PhotoSearchRouterInput: AnyObject {
    func showPhotoDetails(with imageUrl: URL)
}
