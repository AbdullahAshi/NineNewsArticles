typealias NetworkCompletionHandler<Model: Codable> = (_ responseData: Model?, _ error: Error?) -> Void
typealias ArticleListCompletionHandler = ([Article]?, Error?) -> Void
