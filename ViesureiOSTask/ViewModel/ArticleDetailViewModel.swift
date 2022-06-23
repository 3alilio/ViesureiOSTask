//
//  ArticleDetailViewModel.swift
//  waterDrop
//
//  Created by Mohamed El-Shawarby on 28.05.22.
//

import Foundation
import Combine
import SwiftUI

struct ArticleDetailModel {
    let date: String?
    let title: String?
    let author: String?
    let description: String?
    let image: URL?
}

protocol ArticleDetailViewModelProtocol: ObservableObject {
    var detailModel: ArticleDetailModel { get }
}

class ArticleDetailViewModel: ArticleDetailViewModelProtocol, ObservableObject {

    let article: Article
    @Published private(set) var detailModel: ArticleDetailModel

    init(article: Article) {
        self.article = article
        self.detailModel = ArticleDetailModel(date: article.releaseDate?.veisureStringFormat, title: article.title, author: article.author, description: article.description, image: article.imageUrl)
    }
}
