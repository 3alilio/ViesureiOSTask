//
//  ArticlesNetworkDataProvider.swift
//  
//
//  Created by Mohamed El-Shawarby on 24.05.22.
//

import Foundation
import Moya
import Alamofire

 protocol ArticlesDataProviderProtocol {
     func getArticles(success: @escaping ([Article]) -> Void, failure: @escaping (Error) -> Void)
 }

class ArticlesNetworkDataProvider: ArticlesDataProviderProtocol {

    private let tasksApiProvider: BaseProvider<ArticlesApi>
    private let decoder: JSONDecoder
    private var request: Cancellable?

    init(tasksApi: BaseProvider<ArticlesApi> = BaseProvider<ArticlesApi>(), decoder: JSONDecoder = JSONDecoder.appCustomJsonDecoder) {
        self.tasksApiProvider = tasksApi
        self.decoder = decoder
    }

    func getArticles(success: @escaping ([Article]) -> Void, failure: @escaping (Error) -> Void) {
        request = tasksApiProvider.request(.getArticles, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                do {
                    let tasksResponse = try self.decoder.decode([Article].self, from: response.data)
                    success(tasksResponse)
                } catch let err {
                    failure(err)
                }
            case let .failure(error):
                failure(error)
            }
        })
    }
 }
