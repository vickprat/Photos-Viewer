//
//  PhotoSearchInteractorTests.swift
//  PhotosViewerAppTests
//
//  Created by pratvick on 2020/10/30.
//

import XCTest
@testable import PhotosViewerApp

final class PhotoSearchInteractorTests: XCTestCase {

    var interactor: PhotoSearchInteractorMock!
    var presenter: PhotoSearchPresenterInputMock!

    override func setUp() {
        presenter = PhotoSearchPresenterInputMock()
        let network = APIClientMock()
        interactor = PhotoSearchInteractorMock(presenter: presenter, network: network)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        interactor = nil
        presenter = nil
    }

    func testLoadFlickrPhotos() {
        interactor.fetchPhotos(for: "nature", pageNum: 1)
        XCTAssertTrue(presenter.photoSuccessCalled)
        XCTAssertTrue(interactor.loadPhotosCalled)
    }

    func testLoadFlickrPhotosErrorResponse() {
        interactor.fetchPhotos(for: "nature", pageNum: -1)
        XCTAssertFalse(presenter.photoSuccessCalled)
        XCTAssertTrue(interactor.loadPhotosCalled)
    }
}


final class PhotoSearchInteractorMock: PhotoSearchInteractorInput {

    weak var presenter: PhotoSearchInteractorOutput?
    var loadPhotosCalled: Bool = false
    var network: NetworkService?

    init(presenter: PhotoSearchInteractorOutput, network: NetworkService) {
        self.presenter = presenter
        self.network = network
    }

    func fetchPhotos(for imageName: String, pageNum: Int) {
        network?.dataRequest(PhotoSearchAPI.search(query: imageName, page: pageNum), objectType: Photos.self) { (result) in
            switch result {
            case let .success(photos):
                self.loadPhotosCalled = true
                self.presenter?.photoSearchSuccess(photos)
            case let .failure(error):
                self.presenter?.photoSearchError(error)
                self.loadPhotosCalled = true
            }
        }
    }
}

final class PhotoSearchPresenterInputMock: PhotoSearchInteractorOutput {

    var photoSuccessCalled = false

    func photoSearchSuccess(_ photos: Photos) {
        photoSuccessCalled = true
        XCTAssertFalse(photos.photo.isEmpty)
    }

    func photoSearchError(_ error: Error) {
        photoSuccessCalled = false
    }
}
