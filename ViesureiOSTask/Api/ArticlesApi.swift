//
//  ArticlesApi.swift
//  
//
//  Created by Mohamed El-Shawarby on 24.05.22.
//

import Foundation

import Moya

enum ArticlesApi {
    case getArticles
}

extension ArticlesApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://run.mocky.io/v3")!
    }

    var headers: [String: String]? {
        return [:]
    }

    var validationType: ValidationType {
        return .successCodes
    }

    var path: String {
        switch self {
        case .getArticles:
            return "/de42e6d9-2d03-40e2-a426-8953c7c94fb8"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        switch self {
        case .getArticles:
            return StubbedResponseReader.getResponseData(fileName: "MockArticlesData")
        }
    }

    var task: Moya.Task {
        switch self {
        case .getArticles:
            return .requestPlain
        }
    }
}
