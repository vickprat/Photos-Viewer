//
//  PhotoCell.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import UIKit

final class PhotoCell: UICollectionViewCell {

    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder:) not implemented")
    }

    private func setupViews() {
        addSubview(photoImageView)
        photoImageView.edges(to: self)
    }

    func configure(photoURL: URL?, indexPath: IndexPath) {
        photoImageView.image = UIImage(named: "placeholderImage")
        guard let photoURL = photoURL else { return }
        photoImageView.loadImage(with: photoURL, indexPath: indexPath)
    }
}

extension UIImageView {
    func loadImage(with photoURL: URL, indexPath: IndexPath?) {
        ImageDownloader.shared.downloadImage(
            withURL: photoURL,
            indexPath: indexPath,
            completion: { [weak self] (image: UIImage?, resultIndexPath: IndexPath?, url: URL, error: Error?) in
                if let self = self, let kIndexPath = resultIndexPath, indexPath == kIndexPath, photoURL.absoluteString == url.absoluteString {
                    DispatchQueue.main.async {
                        if let downloadedImage = image {
                            self.image = downloadedImage
                        }
                    }
                }
            })
    }
}
