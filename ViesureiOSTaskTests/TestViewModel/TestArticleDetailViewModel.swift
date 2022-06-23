//
//  TestArticleDetailViewModel.swift
//  ViesureTaskTests
//
//  Created by Mohamed El-Shawarby on 19.06.22.
//

import XCTest
@testable import ViesureiOSTask

class TestArticleDetailViewModel: XCTestCase {

    var viewModel: ArticleDetailViewModel?
    let article: Article = ArticlesFactory().article

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testArticleDetailViewModel() throws {
        viewModel = ArticleDetailViewModel(article: article)

        XCTAssertEqual(viewModel?.detailModel.title, article.title)
        XCTAssertEqual(viewModel?.detailModel.author, article.author)
        XCTAssertEqual(viewModel?.detailModel.description, article.description)
        XCTAssertEqual(viewModel?.detailModel.image, article.imageUrl)
        XCTAssertEqual(viewModel?.detailModel.date, "Thu, Jan 25, \'18")
    }

}
