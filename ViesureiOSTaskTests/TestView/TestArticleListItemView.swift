

import XCTest
import ViewInspector
@testable import ViesureiOSTask
import SwiftUI

class TestArticleListItemView: XCTestCase {

    var view: ArticleListItemView<ArticleListItemViewModel>?
    
    lazy var vm: ArticleListItemViewModel = {
        return ArticleListItemViewModel(article: self.article)
    }()
    
    let article = Article(id: 22, title: "Title", description: "Desc", author: nil, releaseDate: nil, image: nil)

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        view = nil
    }

    func testArticleListItemView() throws {
        view = ArticleListItemView(viewModel: vm)
        let actualview = try view.inspect().find(ArticleListItemView<ArticleListItemViewModel>.self).actualView()
        XCTAssertNotNil(actualview)

        let hstack = try actualview.inspect().hStack()
        XCTAssertNotNil(hstack)
        XCTAssertEqual(hstack.count, 2)

        let title = try hstack.vStack(1).text(0).string()
        let desc = try hstack.vStack(1).text(1).string()

        XCTAssertEqual(title, vm.title)
        XCTAssertEqual(desc, vm.description)
    }
}

extension ArticleListItemView: Inspectable { }
