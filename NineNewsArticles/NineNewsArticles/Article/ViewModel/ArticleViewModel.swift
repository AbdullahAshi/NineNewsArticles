import Foundation
import UIKit

//TODO: remove occurances of Car

//TODO: add unit tests

protocol ArticleViewModelProtocol {
    var callback: ((ArticleViewModel.State) -> Void)? { set get }
    func loadData()
}

protocol ViewModelCollectionDataSourceProtocol {
    func numberOfItems(inSection section: Int) -> Int
    func getArticle(at index: Int) -> Article?
    func getCellViewModel(for car: Article) -> NNewsCollectionViewCellViewModel
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
    
    private let carService: ArticleServiceProtocol
    
    var callback: ((ArticleViewModel.State) -> Void)?
    private(set) var state: State {
        didSet {
            callback?(state)
        }
    }
    
    private(set) var cars: [Article]?
    
    init(carService: ArticleServiceProtocol = ArticleService()) {
        self.carService = carService
        state = .initial
    }
    
    func loadData() {
        state = .loading
        carService.getArticles(completion: { [weak self] (cars, error) in
            guard let strongSelf = self else { return }
            
            guard error == nil, let cars = cars else {
                strongSelf.state = .loadedError(error: error ?? NetworkError.unexpectedError)
                return
            }
            
            strongSelf.cars = cars
            strongSelf.state = (cars.count > 0) ? .loaded : .loadedEmpty
        })
    }
}

// MARK - DataSourceProtocol

extension ArticleViewModel: ViewModelCollectionDataSourceProtocol {
    func numberOfItems(inSection section: Int) -> Int {
        return cars?.count ?? 0
    }
    
    func getArticle(at index: Int) -> Article? {
        guard let cars = cars, index < cars.count else {
            return nil
        }
        return cars[index]
    }
    
    func getCellViewModel(for article: Article) -> NNewsCollectionViewCellViewModel {
        //TODO: pick the smallest image
        return NNewsCollectionViewCellViewModel(title: article.headline, price: article.theAbstract, signature: article.byLine , imageUrl: article.relatedImages.first?.url ?? "")
        
    }
}
