//
//  TestArticleDetailView.swift
//  ViesureTaskTests
//
//  Created by Mohamed El-Shawarby on 19.06.22.
//

import XCTest
import ViewInspector

@testable import ViesureiOSTask

class TestArticleDetailView: XCTestCase {

    var view: ArticleDetailView<ArticleDetailViewModel>?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testArticleDetailView() throws {

        let article = ArticlesFactory().article
        let vm = ArticleDetailViewModel(article: article)
        let view = ArticleDetailView(viewModel: vm)

        let scrollView = try view.inspect().zStack().scrollView(1)
        let titleViewText = try scrollView.vStack().vStack(1).text(0).string()
        let dateViewText = try scrollView.vStack().vStack(1).text(1).string()
        let descriptionViewText = try scrollView.vStack().vStack(1).text(2).string()
        let authorViewText = try scrollView.vStack().vStack(1).group(3).text(0).string()
        XCTAssertEqual(titleViewText, vm.detailModel.title)
        XCTAssertEqual(dateViewText, vm.detailModel.date)
        XCTAssertEqual(descriptionViewText, vm.detailModel.description)
        XCTAssertEqual(authorViewText, "Author: \(vm.detailModel.author ?? "")")
    }

}

extension ArticleDetailView: Inspectable { }
