//
//  PhotoSearchModuleProtocols.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import Foundation
import UIKit

protocol PhotoSearchViewInput: AnyObject {
    var presenter: PhotoSearchViewOutput! { get set }
    func changeViewState(_ state: ViewState)
    func displayPhotos(with viewModel: PhotoSearchViewModel)
    func insertPhotos(with viewModel: PhotoSearchViewModel, at indexPaths: [IndexPath])
    func resetViews()
}

protocol PhotoSearchViewOutput: AnyObject {
    func searchPhotos(with imageName: String)
    var isMoreDataAvailable: Bool { get }
    func clearData()
    func didSelectPhoto(at index: Int)
    func didEndDisplayingItem(at index: Int)
}

protocol PhotoSearchPresenterInput: AnyObject {
    var view: PhotoSearchViewInput? { get set }
    var interactor: PhotoSearchInteractorInput! { get set }
    var router: PhotoSearchRouterInput! { get set }
}

protocol PhotoSearchInteractorInput: AnyObject {
    var presenter: PhotoSearchInteractorOutput? { get set }
    func fetchPhotos(for imageName: String, pageNum: Int)
}

protocol PhotoSearchInteractorOutput: AnyObject  {
    func photoSearchSuccess(_ photos: Photos)
    func photoSearchError(_ error: Error)
}

protocol PhotoSearchRouterInput: AnyObject {
    func showPhotoDetails(with photo: Photo)
}
