//
//  ArticleViewModel.swift
//  waterDrop
//
//  Created by Mohamed El-Shawarby on 29.05.22.
//

import Foundation
import Combine

protocol ArticleListItemViewModelProtocol: ObservableObject, Identifiable {
    var title: String? { get }
    var description: String? { get }
    var imageUrl: URL? { get }
}

class ArticleListItemViewModel: ArticleListItemViewModelProtocol, Identifiable, ObservableObject {

    let article: Article

    lazy var identifier: Int = {
        return article.id ?? 0
    }()

    lazy var title: String? = {
        return article.title
    }()

    lazy var description: String? = {
        return article.description
    }()

    lazy var imageUrl: URL? = {
        return self.article.imageUrl
    }()

    init(article: Article) {
        self.article = article
    }
}
