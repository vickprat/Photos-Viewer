//
//  APIClientTests.swift
//  PhotosViewerAppTests
//
//  Created by pratvick on 2020/10/30.
//

import XCTest
@testable import PhotosViewerApp

final class NetworkingTests: XCTestCase {

    var network: NetworkService!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        network = APIClientMock()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        network = nil
    }

    func testNetworkDataRequestSuccess() {
        _ = network.dataRequest(PhotoSearchAPI.search(query: "nature", page: 1), objectType: Photos.self, completion: { (result) in
            switch result {
            case let .success(photos):
                XCTAssertTrue(photos.photo.count == 2)
                XCTAssertFalse(photos.page == 0)
            case .failure:
                break
            }
        })
    }

    func testNetworkDataRequestInvalidStatusFailure() {
        _ = network.dataRequest(PhotoSearchAPI.search(query: "abc", page: -1), objectType: Photos.self, completion: { (result) in
            switch result {
            case .success:
                XCTFail("Should fail with error")
            case .failure(_):
                break
            }
        })
    }

    func testNetworkDataRequestEmptyDataFailure() {
        _ = network.dataRequest(PhotoSearchAPI.search(query: "dfdfdf", page: 1), objectType: Photos.self, completion: { (result) in
            switch result {
            case .success:
                XCTFail("Should fail with error")
            case .failure(_):
                break
            }
        })
    }

    func testImageDownloadSuccess() {
        let imageUrl = URL(string: "https://farm2.static.flickr.com/100/12345_/12345.jpg")!
        _ = network.downloadRequest(imageUrl, completion: { (result) in
            switch result {
            case let .success(image):
                XCTAssertTrue(image == UIImage(named: "placeholderImage")!)
            case .failure:
                XCTFail("Should go to success")
            }
        })
    }

    func testImageDownloadFailure() {
        let imageUrl = URL(string: "https://farm2.static.flickr.com/101/123_/123.jpg")!
        _ = network.downloadRequest(imageUrl, completion: { (result: Result<UIImage, Error>) in
            switch result {
            case .success:
                XCTFail("Should go to failure")
            case .failure(_):
                break
            }
        })
    }
}
