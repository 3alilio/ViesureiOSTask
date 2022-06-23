//
//  TestErrorProvider.swift
//  ViesureTaskTests
//
//  Created by Mohamed El-Shawarby on 19.06.22.
//

import XCTest
import Moya
@testable import ViesureiOSTask

class TestErrorProvider: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNetworkError() throws {
        let error = URLError.init(.notConnectedToInternet)
        let resolvedError = PresentableErrorProvider(additional: [ServerError.self]).presentableError(for: error)
        XCTAssertTrue(resolvedError is NetworkError)
        XCTAssertTrue(resolvedError.isRetriable)
        let string = String(format: NSLocalizedString("No internet connection. Make sure your %@ is connected to the internet to continue.", comment: ""), UIDevice.current.localizedModel)
        XCTAssertEqual(resolvedError.description, string)
    }

    func customFailureEndpointClosure(_ target: ArticlesApi) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(500, Data())},
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }

    func testServerError() throws {
        let error = MoyaError.statusCode(Response(statusCode: 500, data: Data(), request: nil, response: nil))
        let resolvedError = PresentableErrorProvider(additional: [ServerError.self]).presentableError(for: error)
        XCTAssertTrue(resolvedError is ServerError)
        XCTAssertTrue(resolvedError.isRetriable)
        XCTAssertEqual(resolvedError.description, "An unknown error occurred. Please try again later. If the problem persists, please contact our Article support.")
    }

    func testUnknownError() throws {
        struct NewError: Error {}
        let resolvedError = PresentableErrorProvider(additional: [ServerError.self]).presentableError(for: NewError())
        XCTAssertTrue(resolvedError is UnknownError)
        XCTAssertFalse(resolvedError.isRetriable)
        XCTAssertEqual(resolvedError.description, "An unknown error occurred. Please try again later. If the problem persists, please contact our Article support.")
    }
}
