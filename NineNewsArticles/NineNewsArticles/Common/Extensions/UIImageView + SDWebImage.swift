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
