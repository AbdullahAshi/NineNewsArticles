import UIKit

class ArticleCollectionViewController: UICollectionViewController {
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.isHidden = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private let estimateCellWidth: CGFloat = 300.0
    private let cellSpacing: CGFloat = 16.0
    
    private var viewModel: ArticleViewModelDataSourceProtocol!
    
    init(viewModel: ArticleViewModelDataSourceProtocol!) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemGray5
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        if let viewModel = viewModel {
            setup(viewModel: viewModel)
        }
        collectionView.register(UINib(nibName: NNewsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: NNewsCollectionViewCell.identifier)
        viewModel.loadData()
    }
    
    func setup(viewModel: ArticleViewModelDataSourceProtocol) {
        self.viewModel = viewModel
        assert(self.viewModel != nil, "View Model is nil.")
        self.viewModel.callback = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .initial:
                break
            case .loading:
                Thread.executeOnMain {
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.isHidden = false
                }
            case .loaded:
                Thread.executeOnMain {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.setupLayout(with: self.view.bounds.size)
                    self.collectionView.reloadData()
                }
            case .loadedError(let error):
                Thread.executeOnMain {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.showFailedAlert(with: error)
                }
            case .loadedEmpty:
                Thread.executeOnMain {
                    self.showFailedAlert()
                }
            }
        }
    }
    
}

// MARK - transition layout

extension ArticleCollectionViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        Thread.executeOnMain {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func setupLayout(with containerSize: CGSize) {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.minimumInteritemSpacing = cellSpacing
        flowLayout.minimumLineSpacing = cellSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
        
        let numberOfCell = containerSize.width / estimateCellWidth
        if numberOfCell == 1 {
            flowLayout.itemSize = CGSize(width: containerSize.width, height: containerSize.width * 0.95)
        } else {
            let width = floor((numberOfCell / floor(numberOfCell)) * estimateCellWidth) - (cellSpacing * 2)
            flowLayout.itemSize = CGSize(width: width, height: width * 1.1)
        }
    }
}

// MARK - UICollectionViewDataSource

extension ArticleCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NNewsCollectionViewCell.identifier, for: indexPath) as! NNewsCollectionViewCell
        guard let cellViewModel = getCellViewModelForArticle(at: indexPath.item) else {
            assertionFailure("cellViewModel should not be nil")
            return UICollectionViewCell()
        }
        cell.viewModel = cellViewModel
        return cell
    }
}

// MARK - Alert View

extension ArticleCollectionViewController {
    private func showFailedAlert(with error: Error? = nil) {
        
        var title = NSLocalizedString("No Results", comment: "No Results Title")
        var message = NSLocalizedString("No results were found, please try again later! ", comment: "No Results message")
        
        if let error = error {
            title = NSLocalizedString("Failed", comment: "Failed Title")
            message = NSLocalizedString("Failed to fetch results, try again later!. \n check the error below: \n \(error.localizedDescription)", comment: "No Results message")
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { _ in
            self.viewModel.loadData()
        }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK - UICollectionViewDelegate

extension ArticleCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let webView = instantiateWebViewController(), navigationController != nil else {
            assertionFailure("could not instantiate ArticleWebViewController")
            return
        }
        let item = viewModel.getArticle(at: indexPath.item)
        webView.url = item?.url
        navigationController?.pushViewController(webView, animated: true)
    }
    
    private func instantiateWebViewController() -> ArticleWebViewController? {
        return UIStoryboard.init(name: "ArticleWebView", bundle: nil).instantiateViewController(withIdentifier: ArticleWebViewController.storyboardIdentifier)
                as? ArticleWebViewController
    }
}

private extension ArticleCollectionViewController {
    func getCellViewModelForArticle(at index: Int) -> NNewsCollectionViewCellViewModel? {
        guard let article = viewModel.getArticle(at: index) else {
            return nil
        }
        return NNewsCollectionViewCellViewModel(headLine: article.headline, abstract: article.theAbstract, signature: article.byLine , imageUrl: article.smallestImageURL)
    }
}
