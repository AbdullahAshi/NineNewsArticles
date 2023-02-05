import Foundation
import UIKit

protocol ArticleViewModelProtocol {
    var callback: ((ArticleViewModel.State) -> Void)? { set get }
    func loadData()
    func smallestImageURL(article: Article) -> String?
}

protocol ViewModelCollectionDataSourceProtocol {
    func numberOfItems(inSection section: Int) -> Int
    func getArticle(at index: Int) -> Article?
}

class ArticleViewModel: ArticleViewModelProtocol{
    
    //TODO: remove state machine
    enum State {
        case initial
        case loading
        case loaded
        case loadedError(error: Error)
        case loadedEmpty
    }
    
    private let articleService: ArticleServiceProtocol
    
    var callback: ((ArticleViewModel.State) -> Void)?
    private(set) var state: State {
        didSet {
            callback?(state)
        }
    }
    
    private(set) var articles: [Article]?
    
    init(articleService: ArticleServiceProtocol = ArticleService()) {
        self.articleService = articleService
        state = .initial
    }
    
    func loadData() {
        state = .loading
        articleService.getArticles(completion: { [weak self] (articles, error) in
            guard let self = self else { return }
            
            guard error == nil, let articles = articles else {
                self.state = .loadedError(error: error ?? NetworkError.unexpectedError)
                return
            }
            
            self.articles = articles
            self.state = (articles.count > 0) ? .loaded : .loadedEmpty
        })
    }
}

// MARK - DataSourceProtocol

extension ArticleViewModel: ViewModelCollectionDataSourceProtocol {
    func numberOfItems(inSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func getArticle(at index: Int) -> Article? {
        guard let articles = articles, index < articles.count else {
            return nil
        }
        return articles[index]
    }
}

// MARK - Helpers

extension ArticleViewModel {
    func smallestImageURL(article: Article) -> String? {
        return article.relatedImages.filter({ $0.url != nil }).min{ $0.size < $1.size }?.url
    }
}
