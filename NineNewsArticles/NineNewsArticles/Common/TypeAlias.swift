typealias NetworkCompletionHandler<Model: Codable> = (Result<Model?,Error>) -> Void
typealias ArticleListCompletionHandler = ([Article]?, Error?) -> Void
typealias ArticleViewModelDataSourceProtocol = ArticleViewModelProtocol & ViewModelCollectionDataSourceProtocol
