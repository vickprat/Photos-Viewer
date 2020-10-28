//
//  PhotoSearchInteractor.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import Foundation

final class PhotoSearchInteractor: PhotoSearchInteractorInput {

    let service: NetworkService
    weak var presenter: PhotoSearchInteractorOutput?

    init(with service: NetworkService) {
        self.service = service
    }

    func fetchPhotos(for imageName: String, pageNum: Int) {
        let endPoint = PhotoSearchAPI.search(query: imageName, page: pageNum)
        service.dataRequest(endPoint, objectType: Photos.self) { [weak self] (result: Result<Photos, Error>) in
            guard let self = self else { return }
            switch result {
            case let .success(photos):
                self.presenter?.photoSearchSuccess(photos)
            case let .failure(error):
                self.presenter?.photoSearchError(error)
            }
        }
    }
}
