//
//  ArticlesFactory.swift
//  ViesureiOSTaskTests
//
//  Created by Mohamed El-Shawarby on 19.06.22.
//

import Foundation
@testable import ViesureiOSTask

class ArticlesFactory {

    lazy var articles: [Article] = {
        let list = try? JSONDecoder.appCustomJsonDecoder.decode([Article].self, from: StubbedResponseReader.getResponseData(fileName: "MockArticlesData"))
        return list ?? []
    }()

    lazy var article: Article = {
        return self.articles.first!
    }()
}
