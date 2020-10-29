//
//  PhotoSearchPresenter.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import Foundation

final class PhotoSearchPresenter: PhotoSearchPresenterInput, PhotoSearchViewOutput, PhotoSearchInteractorOutput {

    weak var view: PhotoSearchViewInput?
    var interactor: PhotoSearchInteractorInput!
    var router: PhotoSearchRouterInput!

    var photoSearchViewModel: PhotoSearchViewModel!

    var pageNum = Constants.defaultPageNum
    var totalCount = Constants.defaultTotalCount
    var totalPages = Constants.defaultPageNum

    var isMoreDataAvailable: Bool {
        guard totalPages != 0 else { return true }
        return pageNum < totalPages
    }

    func searchPhotos(with imageName: String) {
        guard isMoreDataAvailable else { return }
        view?.changeViewState(.loading)
        pageNum += 1
        interactor.fetchPhotos(for: imageName, pageNum: pageNum)
    }

    func didSelectPhoto(at index: Int) {
        let photo = photoSearchViewModel.photos[index]
        router.showPhotoDetails(with: photo)
    }

    fileprivate func insertMorePhotos(with photos: [Photo]) {
        let previousCount = totalCount
        totalCount += photos.count
        photoSearchViewModel.addMorePhotos(photos)
        let indexPaths: [IndexPath] = (previousCount..<totalCount).map {
            return IndexPath(item: $0, section: 0)
        }
        DispatchQueue.main.async {
            self.view?.insertPhotos(with: self.photoSearchViewModel, at: indexPaths)
            self.view?.changeViewState(.content)
        }
    }

    func photoSearchSuccess(_ photos: Photos) {
        if totalCount == Constants.defaultTotalCount {
            photoSearchViewModel = PhotoSearchViewModel(with: photos.photo)
            totalCount = photos.photo.count
            totalPages = photos.pages
            DispatchQueue.main.async {
                self.view?.displayPhotos(with: self.photoSearchViewModel)
                self.view?.changeViewState(.content)
            }
        } else {
            insertMorePhotos(with: photos.photo)
        }
    }

    func photoSearchError(_ error: Error) {
        DispatchQueue.main.async {
            self.view?.changeViewState(.error(error.localizedDescription))
        }
    }

    func didEndDisplayingItem(at index: Int) {
        if let photoURL = photoSearchViewModel.photoUrlAt(index) {
            ImageDownloader.shared.changeDownloadPriority(for: photoURL)
        }
    }

    func clearData() {
        pageNum = Constants.defaultPageNum
        totalCount = Constants.defaultTotalCount
        totalPages = Constants.defaultTotalCount
        photoSearchViewModel = nil
        ImageDownloader.shared.cancelAll()
        view?.resetViews()
        view?.changeViewState(.none)
    }
}

struct PhotoSearchViewModel {

    var photos = [Photo]()

    init(with photos: [Photo]) {
        self.photos = photos
    }

    var isEmpty: Bool {
        return photos.isEmpty
    }

    var photoCount: Int {
        return photos.count
    }

    mutating func addMorePhotos(_ photos: [Photo]) {
        self.photos += photos
    }

    func photoUrlAt(_ index: Int) -> URL? {
        let photo = photos[index]
        let url = "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_z.jpg"
        guard let photoUrl = URL(string: url) else { return nil }
        return photoUrl
    }
}
