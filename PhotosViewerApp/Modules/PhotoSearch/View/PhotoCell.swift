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

    func configure(imageURL: URL, indexPath: IndexPath) {
        photoImageView.image = UIImage(named: "placeholderImage")
        photoImageView.loadImage(with: imageURL, indexPath: indexPath)
    }
}

extension UIImageView {
    func loadImage(with imageURL: URL, indexPath: IndexPath?) {
        ImageDownloader.shared.downloadImage(
            withURL: imageURL,
            indexPath: indexPath,
            completion: { [weak self] (image: UIImage?, resultIndexPath: IndexPath?, url: URL, error: Error?) in
                if let self = self, let kIndexPath = resultIndexPath, indexPath == kIndexPath, imageURL.absoluteString == url.absoluteString {
                    DispatchQueue.main.async {
                        if let downloadedImage = image {
                            self.image = downloadedImage
                        }
                    }
                }
            })
    }
}
