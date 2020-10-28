//
//  PhotoSearchModuleBuilder.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import UIKit

final class PhotoSearchModuleBuilder {

    func build() -> PhotoSearchViewController {
        let photoSearchVC = PhotoSearchViewController()
        let presenter = PhotoSearchPresenter()
        let interactor = PhotoSearchInteractor(with: APIClient())
        let router = PhotoSearchRouter()

        presenter.view = photoSearchVC
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        photoSearchVC.presenter = presenter
        router.viewController = photoSearchVC

        return photoSearchVC
    }
}
