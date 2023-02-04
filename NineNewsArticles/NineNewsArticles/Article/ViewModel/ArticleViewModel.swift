import Foundation
import UIKit

//TODO: add unit tests

protocol ArticleViewModelProtocol {
    var callback: ((ArticleViewModel.State) -> Void)? { set get }
    func loadData()
}

protocol ViewModelCollectionDataSourceProtocol {
    func numberOfItems(inSection section: Int) -> Int
    func getArticle(at index: Int) -> Article?
    func getCellViewModel(for article: Article) -> NNewsCollectionViewCellViewModel
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
    
    func getCellViewModel(for article: Article) -> NNewsCollectionViewCellViewModel {
        //TODO: pick the smallest image
        return NNewsCollectionViewCellViewModel(title: article.headline, price: article.theAbstract, signature: article.byLine , imageUrl: article.relatedImages.first?.url ?? "")
        
    }
}
