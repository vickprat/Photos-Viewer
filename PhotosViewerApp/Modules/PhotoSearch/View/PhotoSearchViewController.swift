//
//  PhotoSearchViewController.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import UIKit

public enum ViewState: Equatable {
    case none
    case loading
    case error(String)
    case content
}

final class PhotoSearchViewController: UIViewController, PhotoSearchViewInput, SearchBarDelegate {

    var presenter: PhotoSearchViewOutput!
    var viewState: ViewState = .none
    var photoSearchViewModel: PhotoSearchViewModel?
    var searchText = ""

    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let spacing = Constants.defaultSpacing
        let itemSize = (UIScreen.main.bounds.width - ((Constants.numberOfColumns + 1) * spacing)) / Constants.numberOfColumns
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    lazy var searchController: UISearchController = {
        let searchVC = SearchViewController()
        searchVC.searchBarDelegate = self
        let controller = UISearchController(searchResultsController: searchVC)
        controller.searchResultsUpdater = nil
        controller.searchBar.placeholder = Strings.placeholder
        controller.searchBar.delegate = searchVC
        return controller
    }()

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        navigationItem.title = Strings.PhotoSearchTitle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        configureCollectionView()
        configureSearchController()
    }

    private func configureSearchController() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.edgesToSuperView()
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
    }

    func changeViewState(_ state: ViewState) {
        viewState = state
        switch state {
        case .loading:
            if photoSearchViewModel == nil {
                view.showSpinner()
            }
        case .content:
            view.hideSpinner()
        case .error(let message):
            view.hideSpinner()
            showAlert(title: Strings.error, message: message, retryAction: {
                self.presenter.searchPhotos(with: self.searchText)
            })
        default:
            break
        }
    }

    func displayPhotos(with viewModel: PhotoSearchViewModel) {
        photoSearchViewModel = viewModel
        collectionView.reloadData()
    }

    func insertPhotos(with viewModel: PhotoSearchViewModel, at indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates({
            self.photoSearchViewModel = viewModel
            self.collectionView.insertItems(at: indexPaths)
        })
    }

    func resetViews() {
        searchController.searchBar.text = nil
        photoSearchViewModel = nil
        collectionView.reloadData()
    }

    func didTap(with searchText: String) {
        searchController.isActive = false
        guard !searchText.isEmpty || searchText != self.searchText else { return }
        presenter.clearData()

        self.searchText = searchText
        searchController.searchBar.text = searchText
        presenter.searchPhotos(with: searchText)
    }
}

extension PhotoSearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.photoSearchViewModel, !viewModel.isEmpty else { return 0 }
        return viewModel.photoCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        guard let viewModel = photoSearchViewModel else { return cell }
        let photoURL = viewModel.photoUrlAt(indexPath.row)
        cell.configure(photoURL: photoURL, indexPath: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = photoSearchViewModel else { return }
        guard viewState != .loading, indexPath.row == (viewModel.photoCount - 1) else { return }
        presenter.searchPhotos(with: searchText)
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = photoSearchViewModel else { return }
        guard viewState != .loading, indexPath.row == (viewModel.photoCount - 1) else { return }
        presenter.didEndDisplayingItem(at: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectPhoto(at: indexPath.item)
    }
}


