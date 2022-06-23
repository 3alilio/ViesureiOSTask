//
//  MockArticlesNetworkDataProvider.swift
//  ViesureTaskTests
//
//  Created by Mohamed El-Shawarby on 19.06.22.
//

import Foundation
@testable import ViesureiOSTask

class MockArticlesNetworkDataProvider: ArticlesDataProviderProtocol {

    var shouldMockError = false
    var error: Error = URLError.init(.notConnectedToInternet)
    var showMockEmptyList = false
    func getArticles(success: @escaping ([Article]) -> Void, failure: @escaping (Error) -> Void) {
        if shouldMockError {
            failure(error)
        } else {
            success(showMockEmptyList ? [] : ArticlesFactory().articles)
        }
    }
}
