//
//  TestArticlesApi.swift
//
//  Created by Mohamed Elshawarby on 8/21/19.
//

import XCTest

import Moya
@testable import ViesureiOSTask

class TestArticlesDataProvider: XCTestCase {

    var provider: BaseProvider<ArticlesApi>!

    func customEndpointClosure(_ target: ArticlesApi) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }

    func customFailureEndpointClosure(_ target: ArticlesApi) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(500, Data())},
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }

    func testSuccessArticlesApiRequest() {
        provider = BaseProvider<ArticlesApi>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.delayedStub(0))
        let dataProvider = ArticlesNetworkDataProvider(tasksApi: provider)
        let e = expectation(description: "Mock Success Network call")

        let formatter = DateFormatter()
        formatter.dateFormat = "mm/dd/yyyy"
        let firstArticleDate = formatter.date(from: "6/25/2018")
        dataProvider.getArticles(success: { list in
            XCTAssertEqual(list.count, 60)
            XCTAssertEqual(list.first?.id, 1)
            XCTAssertEqual(list.first?.author, "sfolley0@nhs.uk")
            // swiftlint:disable line_length
            XCTAssertEqual(list.first?.description, "nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula")
            XCTAssertEqual(list.first?.title, "Realigned multimedia framework")
            XCTAssertEqual(list.first?.image, "http://dummyimage.com/366x582.png/5fa2dd/ffffff")
            XCTAssertEqual(list.first?.releaseDate, firstArticleDate)
            e.fulfill()
        }, failure: { _ in
            XCTFail("articles request failed")
            e.fulfill()
        })
        waitForExpectations(timeout: 15)
    }

    func testFailureMappingApiRequest() {
        provider = BaseProvider<ArticlesApi>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.delayedStub(0))
        let dataProvider = ArticlesNetworkDataProvider(tasksApi: provider, decoder: JSONDecoder.init())
        let e = expectation(description: "Mock Success Network call")
        dataProvider.getArticles(success: { _ in
            XCTFail("articles request failed")
            e.fulfill()
        }, failure: { error in
            let presentableError = PresentableErrorProvider(additional: [ServerError.self]).presentableError(for: error)
            XCTAssertFalse(presentableError.isRetriable)
            XCTAssertNotNil(error)
            e.fulfill()
        })
        waitForExpectations(timeout: 15)
    }

    func testServerFailureArticlesApiRequest() {

        provider = BaseProvider<ArticlesApi>(endpointClosure: customFailureEndpointClosure, stubClosure: MoyaProvider.delayedStub(0))
        let dataProvider = ArticlesNetworkDataProvider(tasksApi: provider)
        let e = expectation(description: "Mock Success Network call")
        dataProvider.getArticles(success: { _ in
            XCTFail("articles request failed")
            e.fulfill()
        }, failure: { error in
            let presentableError = PresentableErrorProvider(additional: [ServerError.self]).presentableError(for: error)
            XCTAssertTrue(presentableError.isRetriable)
            XCTAssertNotNil(error)
            e.fulfill()
        })
        waitForExpectations(timeout: 15)
    }
}
