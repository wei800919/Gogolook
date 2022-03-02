//
//  UIImageView+Ext.swift
//  CinnoxProject
//
//  Created by Xidi on 2022/1/28.
//

import Foundation
import UIKit

extension UIImageView {
    
    func downloaded(from url: URL, cache: NSCache<NSURL, UIImage>, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        if let image = cache.object(forKey: url as NSURL) {
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String?, cache: NSCache<NSURL, UIImage>, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let link = link, let url = URL(string: link) else { return }
        downloaded(from: url, cache: cache, contentMode: mode)
    }
}
