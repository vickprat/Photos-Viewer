//
//  PhotoSearchRouter.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import UIKit

final class PhotoSearchRouter: PhotoSearchRouterInput {

    weak var viewController: UIViewController?

    func showPhotoDetails(with imageUrl: URL) {
        /*
        let detailVC = PhotoDetailScreenBuilder().build(with: imageUrl)
        viewController?.present(detailVC, animated: true)
         */
    }
}
