//
//  Photos.swift
//  PhotosViewerApp
//
//  Created by pratvick on 2020/10/27.
//

import Foundation

struct Photo: Decodable {
    let farm: Int
    let id: String
    let owner: String
    let secret: String
    let server: String
    let title: String
}

struct Photos: Decodable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [Photo]

    enum CodingKeys: String, CodingKey {
        case photos
    }

    enum PhotosKeys: String, CodingKey {
        case page
        case pages
        case perpage
        case total
        case photo
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let photos = try values.nestedContainer(keyedBy: PhotosKeys.self, forKey: .photos)

        page = try photos.decode(Int.self, forKey: .page)
        pages = try photos.decode(Int.self, forKey: .pages)
        perpage = try photos.decode(Int.self, forKey: .perpage)
        total = try photos.decode(String.self, forKey: .total)
        photo = try photos.decode([Photo].self, forKey: .photo)
    }
}
