//
//  PhotoDetailsModuleProtocol.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/29.
//

import UIKit

protocol PhotoDetailsViewInput: AnyObject {
    func updateView(with image: UIImage?)
}

protocol PhotoDetailsViewOutput: AnyObject {
   func didTapClose()
   func onViewDidLoad()
}

protocol PhotoDetailsPresenterInput: AnyObject {
    var view: PhotoDetailsViewInput? { get set }
    var router: PhotoDetailsRouterInput! { get set }
}

protocol PhotoDetailsRouterInput: AnyObject {
    func dismiss()
}
