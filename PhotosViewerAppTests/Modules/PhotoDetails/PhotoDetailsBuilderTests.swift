//
//  PhotoDetailsBuilderTests.swift
//  PhotosViewerAppTests
//
//  Created by pratvick on 2020/10/30.
//

import XCTest
import UIKit
import Foundation
@testable import PhotosViewerApp

final class PhotoDetailsBuilderTests: XCTestCase {

    var viewController: PhotoDetailsViewController!
    var presenter: PhotoDetailsPresenter!
    var router: PhotoDetailsRouter!

    override func setUp() {
        super.setUp()
        let moduleBuilder = PhotoDetailsModuleBuilder()
        let photo = Photo(farm: 1, id: "1000", owner: "prateek", secret: "2000", server: "3000", title: "photo_1")
        viewController = moduleBuilder.build(with: photo)
        presenter = viewController.presenter as? PhotoDetailsPresenter
        router = presenter.router as? PhotoDetailsRouter
    }

    override func tearDown() {
        viewController = nil
        presenter = nil
        router = nil
    }

    func testPhotoSearchModuleBuilder() {
        XCTAssertTrue(viewController != nil)
        XCTAssertTrue(presenter != nil)
        XCTAssertTrue(router != nil)
    }

    func testPhotoSearchModuleViewController() {
        XCTAssertNotNil(viewController)
        XCTAssertNotNil(viewController.presenter)
        XCTAssertTrue(viewController.presenter is PhotoDetailsPresenter)
    }

    func testPhotoSearchModulePresenter() {
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(presenter.view)
        XCTAssertTrue(presenter.view is PhotoDetailsViewController)
        XCTAssertTrue(presenter.router is PhotoDetailsRouter)
    }
}
