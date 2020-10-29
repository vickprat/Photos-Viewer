//
//  PhotoDetailsModuleBuilder.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/29.
//

import Foundation

final class PhotoDetailsModuleBuilder {

    func build(with photo: Photo) -> PhotoDetailsViewController {
        let detailsViewController = PhotoDetailsViewController()
        let presenter = PhotoDetailsPresenter(with: photo)
        let router = PhotoDetailsRouter()

        presenter.view = detailsViewController
        presenter.router = router

        detailsViewController.presenter = presenter
        router.viewController = detailsViewController

        return detailsViewController
    }
}
