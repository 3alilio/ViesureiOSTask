//
//  MockCoreDataProvider.swift
//  ViesureTaskTests
//
//  Created by Mohamed El-Shawarby on 21.06.22.
//

import Foundation
@testable import ViesureiOSTask

class MockArticlesCoreDataProvider: ArticlesCoreDataProviderProtocol {

    var shouldMockData = false
    let articles = ArticlesFactory().articles
    func fetchArticles() throws -> [Article] {
        return (shouldMockData ? articles : [])
    }

    func saveArticles(articles: [Article]) throws {
        // saved
    }
}
