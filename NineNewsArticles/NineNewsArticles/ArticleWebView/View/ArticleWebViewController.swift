//
//  ArticleWebViewController.swift
//  NineNewsArticles
//
//  Created by Abdullah Al-Ashi on 5/2/2023.
//

import UIKit
import WebKit

class ArticleWebViewController: UIViewController, WKUIDelegate {
    
    static let storyboardIdentifier = "ArticleWebViewController"
    @IBOutlet private weak var webView: WKWebView!
    var url: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        
        if let urlString = url,
           let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}
