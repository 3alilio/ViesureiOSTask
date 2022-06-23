import XCTest
@testable import ViesureiOSTask

class TestArticlesCoreData: XCTestCase {

    var localDataProvider: ArticlesCoreDataProviderProtocol?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let container = CoreDataManager(inMemory: true).persistentContainer
        localDataProvider = ArticleCoreDataProvider(mainContext: container.viewContext, backgroundContext: container.viewContext)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        localDataProvider = nil
    }

    func testSaveArticles() throws {
        let articles = ArticlesFactory().articles
        let article1 = articles.first!
        let article2 = articles.last!
        let savedArticles = [article1, article2]
        let e = expectation(description: "wait background Thread to save and fetch ")
        try? localDataProvider?.saveArticles(articles: savedArticles)
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2, execute: {
            let fetchedArticles = try? self.localDataProvider?.fetchArticles().sorted(by: {
                $0.id ?? 0 < $1.id ?? 0
            })
            XCTAssertEqual(fetchedArticles?.count, 2)

            XCTAssertEqual(fetchedArticles?[0].id, article1.id)
            XCTAssertEqual(fetchedArticles?[0].releaseDate, article1.releaseDate)
            XCTAssertEqual(fetchedArticles?[0].title, article1.title)
            XCTAssertEqual(fetchedArticles?[0].description, article1.description)
            XCTAssertEqual(fetchedArticles?[0].author, article1.author)
            XCTAssertEqual(fetchedArticles?[0].image, article1.image)

            XCTAssertEqual(fetchedArticles?[1].id, article2.id)
            XCTAssertEqual(fetchedArticles?[1].releaseDate, article2.releaseDate)
            XCTAssertEqual(fetchedArticles?[1].title, article2.title)
            XCTAssertEqual(fetchedArticles?[1].description, article2.description)
            XCTAssertEqual(fetchedArticles?[1].author, article2.author)
            XCTAssertEqual(fetchedArticles?[1].image, article2.image)

            e.fulfill()
        })
        waitForExpectations(timeout: 3)
    }
}
