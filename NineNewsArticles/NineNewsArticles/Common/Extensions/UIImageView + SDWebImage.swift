//
//  UIImageView + SDWebImage.swift
//  NineNewsArticles
//
//  Created by Abdullah Al-Ashi on 3/2/2023.
//

import UIKit
import SDWebImage

extension UIImageView{
    
    func image(for url: String) {
        DispatchQueue.global().async { [weak self] in
            if let cachedImage = SDImageCache.shared.imageFromCache(forKey: url) {
                Thread.executeOnMain {
                    self?.image = cachedImage
                }
                return
            }
            
            SDWebImageDownloader.shared.downloadImage(with: URL(string: url)!, options: [], progress: nil, completed: { [weak self] (image,_,_,_) in
                SDImageCache.shared.store(image, forKey: url, completion: nil)
                Thread.executeOnMain {
                    self?.image = image
                }
            })
        }
    }
    
}

extension UIImageView {
    func downloaded(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            Thread.executeOnMain { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url)
    }
}
