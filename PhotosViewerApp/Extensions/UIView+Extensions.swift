//
//  UIView+Extensions.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import UIKit

extension UIView {

    func edgesToSuperView(constant: CGFloat = 0) {
        guard let superview = superview else {
            preconditionFailure("superview is missing for this view")
        }
        translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            safeAreaEdges(to: superview, constant: constant)
        } else {
            edges(to: superview, constant: constant)
        }
    }

    func safeAreaEdges(to superview: UIView, constant: CGFloat) {
        if #available(iOS 11, *) {
            let layoutGuide = superview.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: constant),
                bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: constant),
                leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: constant),
                trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: constant)
            ])
        }
    }

    func edges(to view: UIView, constant: CGFloat = 0) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func centerInSuperView() {
        guard let superview = superview else {
            fatalError("superview is missing for this view")
        }
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }

    func showSpinner() {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    func hideSpinner() {
        guard let spinner = self.subviews.last as? UIActivityIndicatorView else { return }
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
}
