//
//  ArticlesViewModel.swift
//  waterDrop
//
//  Created by Mohamed El-Shawarby on 24.05.22.
//

import Foundation
import Combine
import UIKit

enum ArticlesViewState {

    case loading
    case articles(articles: [ArticleListItemViewModel])
    case emptyDataSet(data: EmptyDataSetData)
}

protocol ArticlesViewModelProtocol: ObservableObject {

    var viewState: ArticlesViewState { get }
    var title: String { get }
    var selectedItem: ArticleDetailViewModel? { get }
    var showDetail: Bool { get set }
    func userSelectItem(item: ArticleListItemViewModel)
    func sendGetArticlesRequest()
}

struct RetrialConfig {
    let maximumNumberOfRetriableCount: Int
    let durationOfWaitingInSecBeforeRetry: TimeInterval
}

class ArticlesViewModel: ObservableObject, ArticlesViewModelProtocol {

    @Published private(set) var viewState: ArticlesViewState = .loading
    @Published var showDetail: Bool = false

    let title: String = "Articles"
    private(set) var selectedItem: ArticleDetailViewModel?

    private let retrialConfig: RetrialConfig
    private var retriableCount = 0

    private let dataProvider: ArticlesDataProviderProtocol
    private let coreDataProvider: ArticlesCoreDataProviderProtocol
    private var cancellable = Set<AnyCancellable>()

    private var articlesListVM: [ArticleListItemViewModel] = []

    init(dataProvider: ArticlesDataProviderProtocol = ArticlesNetworkDataProvider(),
         coreDataProvider: ArticlesCoreDataProviderProtocol = ArticleCoreDataProvider(),
         retrialConfig: RetrialConfig = RetrialConfig(maximumNumberOfRetriableCount: 3, durationOfWaitingInSecBeforeRetry: 2)) {
        self.dataProvider = dataProvider
        self.coreDataProvider = coreDataProvider
        self.retrialConfig =  retrialConfig
    }

    func sendGetArticlesRequest() {

        dataProvider.getArticles(success: { [weak self] result in
                self?.handleSucessfulResponse(articles: result)
        }, failure: { [weak self] error in
                self?.handleError(error: error)
        })
    }

    func userSelectItem(item: ArticleListItemViewModel) {
        selectedItem = ArticleDetailViewModel(article: item.article)
        showDetail = true
    }

    private func handleSucessfulResponse(articles: [Article], shouldSaveArticles: Bool = true) {
        if  !articles.isEmpty {
            self.articlesListVM = articles.sorted(by: { $0.releaseDate ?? Date() > $1.releaseDate ?? Date() }).map({ ArticleListItemViewModel(article: $0)})
            self.viewState = .articles(articles: articlesListVM)
            if shouldSaveArticles {
                DispatchQueue.global(qos: .background).async { [weak self]  in
                    guard let self = self else { return }
                    try? self.coreDataProvider.saveArticles(articles: articles)
                }
            }
        } else {
                self.viewState = .emptyDataSet(data: EmptyDataSetData(descriptionText: "No Articles to show"))
        }
    }

    private func handleError(error: Error) {

        let presentableError = PresentableErrorProvider(additional: [ServerError.self]).presentableError(for: error)

        guard shouldShowError(error: presentableError) else {
            DispatchQueue.main.asyncAfter(deadline: .now() + retrialConfig.durationOfWaitingInSecBeforeRetry, execute: { [weak self] in
                self?.sendGetArticlesRequest()
            })
            return
        }

        guard !canShowLocalData() else {
            return
        }

        let emptyDataSetData = EmptyDataSetData(tryAgainHandler: { [weak self] in
            guard let self = self else { return }
            self.viewState = .loading
            self.sendGetArticlesRequest()
        }, title: presentableError.title, descriptionText: presentableError.description, buttonTitle: "Try Again")

        self.viewState = .emptyDataSet(data: emptyDataSetData)
    }

    private func canShowLocalData() -> Bool {
        guard let localData = try? coreDataProvider.fetchArticles(), !localData.isEmpty else {
            return false
        }
        self.handleSucessfulResponse(articles: localData, shouldSaveArticles: false)
        return true
    }

    private func shouldShowError(error: PresentableError) -> Bool {
        guard error.isRetriable else { return true }
        if retriableCount == retrialConfig.maximumNumberOfRetriableCount {
            retriableCount = 0
            return true
        } else {
            retriableCount += 1
            return false
        }
    }
}
