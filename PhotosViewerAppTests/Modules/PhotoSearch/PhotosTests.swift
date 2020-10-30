//
//  PhotosTests.swift
//  PhotosViewerAppTests
//
//  Created by pratvick on 2020/10/30.
//

import XCTest
@testable import PhotosViewerApp

final class PhotosTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPhotoEntity() {
        let photos = getPhotos()
        XCTAssertNotNil(photos)
        XCTAssertFalse(photos.photo.isEmpty)

        let photo = photos.photo[0]
        XCTAssertTrue(photo.id == "12345")
        XCTAssertEqual(photo.title, "test image title")
        XCTAssertTrue(photo.farm == 2)
    }

    func getPhotos() -> Photos {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: "TestData", withExtension: "json")!
        let data = try! Data(contentsOf: fileUrl)
        let photos = try! JSONDecoder().decode(Photos.self, from: data)
        return photos
    }

    func testPhotosJSONDecoder() {
        let photos = getPhotos()
        XCTAssertFalse(photos.photo.isEmpty)
        XCTAssertTrue(photos.photo.count == 2)
        XCTAssertTrue(photos.page == 1)
        XCTAssertTrue(photos.total == "2")
        XCTAssertTrue(photos.perpage == 20)
    }
}
