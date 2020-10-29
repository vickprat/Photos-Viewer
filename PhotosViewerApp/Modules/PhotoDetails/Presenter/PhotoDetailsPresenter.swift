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
        let url = "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_z.jpg"
        guard let photoUrl = URL(string: url) else {
            view?.updateView(with: UIImage(named: "placeholderImage"))
            return
        }
        ImageDownloader.shared.downloadImage(withURL: photoUrl, indexPath: nil) { [weak self] (image, _, _, error) in
            if let photo = image {
                self?.view?.updateView(with: photo)
            }
        }
    }

    func didTapClose() {
        router.dismiss()
    }
}
