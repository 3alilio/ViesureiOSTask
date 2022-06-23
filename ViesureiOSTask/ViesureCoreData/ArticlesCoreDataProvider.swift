//
//  Model.swift
//  waterDrop
//
//  Created by Mohamed El-Shawarby on 24.05.22.
//

import Foundation
import UIKit
import CoreData

protocol ArticlesCoreDataProviderProtocol {
    func fetchArticles() throws -> [Article]
    func saveArticles(articles: [Article]) throws
}

enum ArticlesCoreDataError: Error {
    case saveError(error: Error)
    case fetchError(error: Error)
}

class ArticleCoreDataProvider: ArticlesCoreDataProviderProtocol {

    let context: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    init(mainContext: NSManagedObjectContext? = nil, backgroundContext: NSManagedObjectContext? = nil) {
        let coreDataManager = CoreDataManager(inMemory: false).persistentContainer
        self.context = mainContext ?? coreDataManager.viewContext
        self.backgroundContext = backgroundContext ?? coreDataManager.newBackgroundContext()

        let options: [AnyHashable: Any] = [
                NSPersistentStoreFileProtectionKey: FileProtectionType.complete
            ]
        let url = URL(fileURLWithPath: "database.sqlite")
        // Add Persistent Store
        do {
            try? self.context.persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: url,
                                                              options: options)

            try? self.backgroundContext.persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: url,
                                                              options: options)
        }
    }

    func fetchArticles() -> [Article] {
        let request = ArticleCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let result = try context.fetch(request)
            return result.map({ self.mapFromArticleCoreDataToArticle(articleCoreData: $0) })
        } catch {
            print("Fetching data Failed")
        }
        return []
    }

    func saveArticles(articles: [Article]) throws {
        for article in articles {
            updateSaveArticle(article: article)
        }
    }

    private func updateSaveArticle(article: Article) {
        guard let id = article.id else { return }
        let request = ArticleCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id = \(id)")
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            let results = try? self.backgroundContext.fetch(request)
            var articleCoreData: ArticleCoreData
            if let results = results, results.isEmpty {
                // swiftlint:disable force_cast
                articleCoreData = NSEntityDescription.insertNewObject(forEntityName: "ArticleCoreData", into: self.backgroundContext) as! ArticleCoreData
            } else {
                // swiftlint:disable force_cast
                articleCoreData = results?.first ?? NSEntityDescription.insertNewObject(forEntityName: "ArticleCoreData", into: self.backgroundContext) as! ArticleCoreData
            }

            articleCoreData.id = Int32(id)
            articleCoreData.articleDescription = article.description
            articleCoreData.title = article.title
            articleCoreData.releaseDate = article.releaseDate
            articleCoreData.author = article.author
            articleCoreData.image = article.image
            do {
                try self.backgroundContext.save()
            } catch {
                debugPrint("Failed to update save \(article) with error \(error)")
            }
        }
    }

    private func mapFromArticleCoreDataToArticle(articleCoreData: ArticleCoreData) -> Article {
        let a = Article(id: Int(articleCoreData.id), title: articleCoreData.title, description: articleCoreData.articleDescription,
            author: articleCoreData.author, releaseDate: articleCoreData.releaseDate, image: articleCoreData.image)
        return a
    }
}
