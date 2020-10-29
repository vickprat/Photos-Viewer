//
//  PhotoDetailsPresenter.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/29.
//

import UIKit

final class PhotoDetailsPresenter: PhotoDetailsPresenterInput, PhotoDetailsViewOutput {

    var view: PhotoDetailsViewInput?
    var router: PhotoDetailsRouterInput!

    var photo: Photo

    init(with photo: Photo) {
        self.photo = photo
    }

    func onViewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            guard let self = self else {
                return
            }
            self.view?.renderView(with: self.photo)
        }
    }

    func didTapClose() {
        router.dismiss()
    }
}
