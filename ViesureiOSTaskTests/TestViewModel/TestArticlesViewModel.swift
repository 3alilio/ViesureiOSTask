//
//  TestArticlesViewModel.swift
//  ViesureTaskTests
//
//  Created by Mohamed El-Shawarby on 21.06.22.
//

import XCTest
@testable import ViesureiOSTask

class TestArticlesViewModel: XCTestCase {

    var vm: ArticlesViewModel?
    let mockNetwork  = MockArticlesNetworkDataProvider()
    let mockCoreData = MockArticlesCoreDataProvider()
    let retrialConfig = RetrialConfig(maximumNumberOfRetriableCount: 1, durationOfWaitingInSecBeforeRetry: 1)
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vm = ArticlesViewModel(dataProvider: mockNetwork, coreDataProvider: mockCoreData, retrialConfig: retrialConfig)
    }

    override func tearDownWithError() throws {
        vm = nil
    }

    func testArticlesViewModelInitialState() throws {
        guard let vm = vm else {
            XCTFail("Articles View Model is nil")
            return
        }
        XCTAssertEqual(vm.title, "Articles")
        switch vm.viewState {
        case .loading:
            break
        case .articles, .emptyDataSet:
            XCTFail("Initial State should be Loading")
        }
    }

    func testArticlesViewModelEmptyList() throws {
        guard let vm = vm else {
            XCTFail("Articles View Model is nil")
            return
        }
        mockNetwork.showMockEmptyList = true
        vm.sendGetArticlesRequest()
            switch vm.viewState {
            case .emptyDataSet(let data):
                XCTAssertNil(data.buttonTitle)
                XCTAssertNil(data.tryAgainHandler)
                XCTAssertNil(data.title)
                XCTAssertEqual(data.descriptionText, "No Articles to show")
            case .articles, .loading:
                XCTFail("Initial State should be Empty Data Set")
            }
    }

    func testArticlesViewModelNetWorkErrorWithoutTrial() throws {
        guard let vm = vm else {
            XCTFail("Articles View Model is nil")
            return
        }
        mockNetwork.shouldMockError = true
        mockNetwork.error = URLError.init(.notConnectedToInternet)
        vm.sendGetArticlesRequest()
        let e = expectation(description: "Mock Success Network call")
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.25) {
            switch vm.viewState {
            case .loading:
                break
            case .articles, .emptyDataSet:
                XCTFail("State should be Loading Retry Error")
            }
            e.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testArticlesViewModelNetWorkErrorWithTrial() throws {
        guard let vm = vm else {
            XCTFail("Articles View Model is nil")
            return
        }
        mockNetwork.shouldMockError = true
        mockNetwork.error = URLError.init(.notConnectedToInternet)
        vm.sendGetArticlesRequest()
        let e = expectation(description: "Wait for Network Trial ")
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {
            switch vm.viewState {
            case .emptyDataSet(let data):
                XCTAssertEqual(data.buttonTitle, "Try Again")
                XCTAssertNotNil(data.tryAgainHandler)
                XCTAssertEqual(data.title, "Network Error")
                XCTAssertEqual(data.descriptionText, "No internet connection. Make sure your iPhone is connected to the internet to continue.")
            case .articles, .loading:
                XCTFail("State Should be Empty Data Set with Network Error ")
            }
            e.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    func testArticlesViewModelUnKnownError() throws {
        guard let vm = vm else {
            XCTFail("Articles View Model is nil")
            return
        }
        enum UnknownError: Error {
            case error
        }
        mockNetwork.shouldMockError = true
        mockNetwork.error = UnknownError.error
        vm.sendGetArticlesRequest()
            switch vm.viewState {
            case .emptyDataSet(let data):
                XCTAssertEqual(data.buttonTitle, "Try Again")
                XCTAssertNotNil(data.tryAgainHandler)
                XCTAssertEqual(data.title, "Unknown Error")
                XCTAssertEqual(data.descriptionText, "An unknown error occurred. Please try again later. If the problem persists, please contact our Article support.")
            case .articles, .loading:
                XCTFail("State should be Empty Data Set With Unknoen Error")
            }
    }

    func testArticlesNetworkFailureWithLocalData() throws {
        guard let vm = vm else {
            XCTFail("Articles View Model is nil")
            return
        }
        enum UnknownError: Error {
            case error
        }
        mockNetwork.shouldMockError = true
        mockNetwork.error = UnknownError.error
        mockCoreData.shouldMockData = true
        vm.sendGetArticlesRequest()
            switch vm.viewState {
            case .articles(let articles):
                XCTAssertEqual(articles.count, mockCoreData.articles.count)
            case .emptyDataSet, .loading:
                XCTFail("State should be showing articles")
            }
    }

    func testIsArticlesSorted() throws {
        guard let vm = vm else {
            XCTFail("Articles View Model is nil")
            return
        }
        vm.sendGetArticlesRequest()
            switch vm.viewState {
            case .articles(let articles):
                XCTAssertEqual(articles.first?.article.releaseDate?.veisureStringFormat, "Thu, Jan 23, '20")
                XCTAssertEqual(articles.last?.article.releaseDate?.veisureStringFormat, "Mon, Jan 1, '18")
            case .emptyDataSet, .loading:
                XCTFail("State should be showing articles Sorted")
            }
    }

}
