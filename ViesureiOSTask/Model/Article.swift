//
//  Article.swift
//  ViesureiOSTask
//
//  Created by Mohamed El-Shawarby on 23.06.22.
//

import Foundation

struct Article: Codable {

    let id: Int?
    let title: String?
    let description: String?
    let author: String?
    let releaseDate: Date?
    let image: String?

    var imageUrl: URL? {
        URL(string: self.image ?? "")
    }

    enum CodingKeys: String, CodingKey {
        case id, title, description, author, image
        case releaseDate = "release_date"
    }    
}
