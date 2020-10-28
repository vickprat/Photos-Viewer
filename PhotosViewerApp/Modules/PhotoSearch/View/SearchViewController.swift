//
//  SearchViewController.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import UIKit

protocol SearchBarDelegate: AnyObject {
    func didTap(with searchText: String)
}

final class SearchViewController: UIViewController, UISearchBarDelegate {

    weak var searchBarDelegate: SearchBarDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        searchBar.text = text
        searchBar.resignFirstResponder()
        searchBarDelegate?.didTap(with: text)
    }
}
