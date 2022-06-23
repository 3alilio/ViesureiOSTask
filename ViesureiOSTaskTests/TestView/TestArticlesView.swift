//
//  TestArticlesView.swift
//  ViesureiOSTaskTests
//
//  Created by Mohamed El-Shawarby on 24.06.22.
//

import XCTest
@testable import ViesureiOSTask
import ViewInspector

class TestArticlesView: XCTestCase {

    var view: ArticlesView<ArticlesViewModel>?
    var vm: ArticlesViewModel?
    let mockNetwork  = MockArticlesNetworkDataProvider()
    let mockCoreData = MockArticlesCoreDataProvider()
    let retrialConfig = RetrialConfig(maximumNumberOfRetriableCount: 0, durationOfWaitingInSecBeforeRetry: 0)
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vm = ArticlesViewModel.init(dataProvider: mockNetwork, coreDataProvider: mockCoreData, retrialConfig: retrialConfig)
    }

    override func tearDownWithError() throws {
        view = nil
        vm = nil
    }

    func testArticlesViewWithValueListState() throws {
        view = ArticlesView(viewModel: vm!)
        let actualview = try view?.inspect().find(ArticlesView<ArticlesViewModel>.self).actualView()
        XCTAssertNotNil(actualview)
        let list = try actualview?.inspect().navigationView().zStack(0).vStack(2).list(0)
        XCTAssertNotNil(list)
    }

    func testArticlesViewWithEmptyListState() throws {
        mockNetwork.showMockEmptyList = true
        view = ArticlesView(viewModel: vm!)
        let actualview = try view?.inspect().find(ArticlesView<ArticlesViewModel>.self).actualView()
        XCTAssertNotNil(actualview)
        let emptyDataSet = try actualview?.inspect().navigationView().zStack(0).vStack(2).find(EmptyDataSetView.self)
        XCTAssertNotNil(emptyDataSet)
    }

    func testArticlesViewWithErrorState() throws {
        mockNetwork.shouldMockError = true
        view = ArticlesView(viewModel: vm!)
        let actualview = try view?.inspect().find(ArticlesView<ArticlesViewModel>.self).actualView()
        XCTAssertNotNil(actualview)
        let emptyDataSet = try actualview?.inspect().navigationView().zStack(0).vStack(2).find(EmptyDataSetView.self)
        XCTAssertNotNil(emptyDataSet)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension ArticlesView: Inspectable { }
