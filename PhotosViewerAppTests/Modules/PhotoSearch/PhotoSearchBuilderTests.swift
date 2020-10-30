//
//  PhotoSearchBuilderTests.swift
//  PhotosViewerAppTests
//
//  Created by pratvick on 2020/10/30.
//

import XCTest
import UIKit
import Foundation
@testable import PhotosViewerApp

final class PhotoSearchBuilderTests: XCTestCase {

    var viewController: PhotoSearchViewController!
    var presenter: PhotoSearchPresenter!
    var interactor: PhotoSearchInteractor!
    var router: PhotoSearchRouter!

    override func setUp() {
        super.setUp()
        let moduleBuilder = PhotoSearchModuleBuilder()
        viewController = moduleBuilder.build()
        presenter = viewController.presenter as? PhotoSearchPresenter
        interactor = presenter.interactor as? PhotoSearchInteractor
        router = presenter.router as? PhotoSearchRouter
    }

    override func tearDown() {
        viewController = nil
        presenter = nil
        interactor = nil
        router = nil
    }

    func testPhotoSearchModuleBuilder() {
        XCTAssertTrue(viewController != nil)
        XCTAssertTrue(presenter != nil)
        XCTAssertTrue(interactor != nil)
        XCTAssertTrue(router != nil)
    }

    func testPhotoSearchModuleViewController() {
        XCTAssertNotNil(viewController)
        XCTAssertNotNil(viewController.presenter)
        XCTAssertTrue(viewController.presenter is PhotoSearchPresenter)
    }

    func testPhotoSearchModulePresenter() {
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(presenter.view)
        XCTAssertNotNil(presenter.interactor)
        XCTAssertTrue(presenter.view is PhotoSearchViewController)
        XCTAssertTrue(presenter.interactor is PhotoSearchInteractor)
        XCTAssertTrue(presenter.router is PhotoSearchRouter)
    }

    func testPhotoSearchModuleInteractor() {
        XCTAssertNotNil(interactor)
        XCTAssertNotNil(interactor.presenter)
        XCTAssertTrue(interactor.presenter is PhotoSearchPresenter)
    }
}
