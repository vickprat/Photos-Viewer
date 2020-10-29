//
//  PhotoDetailsRouter.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/29.
//

import UIKit

final class PhotoDetailsRouter: PhotoDetailsRouterInput {

    weak var viewController: UIViewController?

    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
