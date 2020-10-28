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
        guard totalPages != 0 else {
            return true
        }
        return pageNum < totalPages
    }

    func searchPhotos(with imageName: String) {
        guard isMoreDataAvailable else { return }
        view?.changeViewState(.loading)
        pageNum += 1
        interactor.fetchPhotos(for: imageName, pageNum: pageNum)
    }

    func didSelectPhoto(at index: Int) {
        let imageUrl = photoSearchViewModel.imageUrlAt(index)
        router.showPhotoDetails(with: imageUrl)
    }

    fileprivate func insertMorePhotos(with photoUrlList: [URL]) {
        let previousCount = totalCount
        totalCount += photoUrlList.count
        photoSearchViewModel.addMorePhotoUrls(photoUrlList)
        let indexPaths: [IndexPath] = (previousCount..<totalCount).map {
            return IndexPath(item: $0, section: 0)
        }
        DispatchQueue.main.async {
            self.view?.insertPhotos(with: self.photoSearchViewModel, at: indexPaths)
            self.view?.changeViewState(.content)
        }
    }

    func photoSearchSuccess(_ photos: Photos) {
        let photoUrlList = buildPhotoUrlList(from: photos.photo)
        guard !photoUrlList.isEmpty else { return }
        if totalCount == Constants.defaultTotalCount {
            photoSearchViewModel = PhotoSearchViewModel(photoUrlList: photoUrlList)
            totalCount = photos.photo.count
            totalPages = photos.pages
            DispatchQueue.main.async {
                self.view?.displayPhotos(with: self.photoSearchViewModel)
                self.view?.changeViewState(.content)
            }
        } else {
            insertMorePhotos(with: photoUrlList)
        }
    }

    func photoSearchError(_ error: Error) {
        DispatchQueue.main.async {
            self.view?.changeViewState(.error(error.localizedDescription))
        }
    }

    func buildPhotoUrlList(from photos: [Photo]) -> [URL] {
        let photoUrlList = photos.compactMap { (photo) -> URL? in
            let url = "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_z.jpg"
            guard let imageUrl = URL(string: url) else { return nil }
            return imageUrl
        }
        return photoUrlList
    }

    func clearData() {
        pageNum = Constants.defaultPageNum
        totalCount = Constants.defaultTotalCount
        totalPages = Constants.defaultTotalCount
        photoSearchViewModel = nil
        view?.resetViews()
        view?.changeViewState(.none)
    }
}

struct PhotoSearchViewModel {

    var photoUrlList = [URL]()

    init(photoUrlList: [URL]) {
        self.photoUrlList = photoUrlList
    }

    var isEmpty: Bool {
        return photoUrlList.isEmpty
    }

    var photoCount: Int {
        return photoUrlList.count
    }

    mutating func addMorePhotoUrls(_ photoUrls: [URL]) {
        photoUrlList += photoUrls
    }

    func imageUrlAt(_ index: Int) -> URL {
        guard !photoUrlList.isEmpty else {
            fatalError("No imageUrls available")
        }
        return photoUrlList[index]
    }
}
