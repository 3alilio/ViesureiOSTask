//
//  TestArticleListViewModel.swift
//  ViesureTaskTests
//
//  Created by Mohamed El-Shawarby on 19.06.22.
//

import XCTest
@testable import ViesureiOSTask

class TestArticleListViewModel: XCTestCase {

    var vm: ArticleListItemViewModel?
    let article = ArticlesFactory().article
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.vm = ArticleListItemViewModel(article: article)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.vm = nil
    }

    func testArticleListItemViewModel() throws {
        XCTAssertEqual(vm?.title, article.title)
        XCTAssertEqual(vm?.description, article.description)
        XCTAssertEqual(vm?.identifier, article.id)
        XCTAssertEqual(vm?.imageUrl, article.imageUrl)
    }
}
