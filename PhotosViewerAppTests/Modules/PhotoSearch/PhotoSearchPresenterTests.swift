//
//  PhotoSearchPresenterTests.swift
//  PhotosViewerAppTests
//
//  Created by pratvick on 2020/10/30.
//

import XCTest
@testable import PhotosViewerApp

final class PhotoSearchPresenterTests: XCTestCase {

    var interactor: PhotoSearchInteractorMock!
    var presenter: PhotoSearchPresenterMock!
    var view: PhotoSearchViewControllerMock!
    var router: PhotoSearchRouterInput!
    var network: NetworkService!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        presenter = PhotoSearchPresenterMock()
        network = APIClientMock()
        interactor = PhotoSearchInteractorMock(presenter: presenter, network: network)
        router = PhotoSearchRouterMock()
        view = PhotoSearchViewControllerMock(presenter: presenter)

        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        presenter = nil
        view = nil
        interactor = nil
        network = nil
    }

    func testSearchMethodCall() {
        presenter.searchPhotos(with: "nature")
        XCTAssertTrue(presenter.photoSearchSuccess)
        XCTAssertTrue(view.showPhotos)
        XCTAssertNotNil(presenter.photoSearchViewModel)
        XCTAssertTrue(presenter.photoSearchViewModel.photoCount == 2)
    }

    func testDidSelectPhotoCall() {
        presenter.didSelectPhoto(at: 0)
        XCTAssertTrue(presenter.selectedPhoto)
    }
}

final class PhotoSearchPresenterMock: PhotoSearchPresenterInput, PhotoSearchViewOutput, PhotoSearchInteractorOutput {

    weak var view: PhotoSearchViewInput?
    var interactor: PhotoSearchInteractorInput!
    var router: PhotoSearchRouterInput!
    var photoSearchViewModel: PhotoSearchViewModel!

    var isMoreDataAvailable: Bool { return true }
    var photoSearchSuccess = false
    var selectedPhoto = false

    func searchPhotos(with imageName: String) {
        interactor.fetchPhotos(for: imageName, pageNum: 1)
    }

    func photoSearchSuccess(_ photos: Photos) {
        photoSearchSuccess = true
        XCTAssertFalse(photos.photo.isEmpty)
        let viewModel = PhotoSearchViewModel(with: photos.photo)
        photoSearchViewModel = viewModel
        view?.displayPhotos(with: viewModel)
    }

    func photoSearchError(_ error: Error) {
        photoSearchSuccess = false
    }

    func clearData() {
        view?.resetViews()
    }

    func didSelectPhoto(at index: Int) {
        selectedPhoto = true
    }

    func didEndDisplayingItem(at index: Int) {
    }
}

final class PhotoSearchViewControllerMock: UIViewController, PhotoSearchViewInput {

    var presenter: PhotoSearchViewOutput!
    var showPhotos = false

    init(presenter: PhotoSearchViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeViewState(_ state: ViewState) {}

    func displayPhotos(with viewModel: PhotoSearchViewModel) {
        XCTAssertFalse(viewModel.isEmpty)
        XCTAssertTrue(viewModel.photos.count == 2)
        showPhotos = true
    }

    func insertPhotos(with viewModel: PhotoSearchViewModel, at indexPaths: [IndexPath]) {}

    func resetViews() {}
}

final class PhotoSearchRouterMock: PhotoSearchRouterInput {

    weak var viewController: UIViewController?
    var showPhotoDetailsCalled = false

    func showPhotoDetails(with photo: Photo) {
        showPhotoDetailsCalled = true
    }
}
