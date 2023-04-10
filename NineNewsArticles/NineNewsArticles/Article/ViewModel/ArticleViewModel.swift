import Foundation
import UIKit

protocol ArticleViewModelProtocol {
    var callback: ((ArticleViewModel.State) -> Void)? { set get }
    func loadData()
    func getArticle(at index: Int) -> Article?
}

protocol ViewModelCollectionDataSourceProtocol {
    func numberOfItems(inSection section: Int) -> Int
}

class ArticleViewModel: ArticleViewModelProtocol{
    
    enum State: Equatable {
        case initial
        case loading
        case loaded
        case loadedError(error: Error)
        case loadedEmpty
        
        static func == (lhs: ArticleViewModel.State, rhs: ArticleViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case (.initial, initial), (.loading, .loading), (.loaded, .loaded), (loadedError, loadedError), (loadedEmpty, loadedEmpty):
                return true
            default:
                return false
            }
        }
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
            
            self.articles = articles.sorted(by: { $0.timeStamp > $1.timeStamp })
            self.state = (articles.count > 0) ? .loaded : .loadedEmpty
        })
    }
}

// MARK - DataSourceProtocol

extension ArticleViewModel: ViewModelCollectionDataSourceProtocol {
    func numberOfItems(inSection section: Int) -> Int {
        return articles?.count ?? 0
    }
}

// MARK - Helpers

extension ArticleViewModel {    
    func getArticle(at index: Int) -> Article? {
        guard let articles = articles, index < articles.count else {
            return nil
        }
        return articles[index]
    }
}
