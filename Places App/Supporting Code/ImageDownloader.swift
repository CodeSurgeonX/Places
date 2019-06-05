//
//  ImageDownloader.swift
//  Places App
//
//  Created by Shashwat  on 05/06/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import Foundation
import UIKit


class ImageDownloader {
    var cache = NSCache<NSString,UIImage>()
    func downloadImageFromURL(urlString: String, imageView: UIImageView) {
        if let cImage = cache.object(forKey: urlString as NSString ){
            DispatchQueue.main.async {
                imageView.image = cImage
            }
        }else{
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error.debugDescription)
                    }
                    else {
                        if let data = data {
                            DispatchQueue.main.async { [weak self] in
                                if let image = UIImage(data: data) {
                                    imageView.image = image
                                    self?.cache.setObject(image, forKey: urlString as NSString)
                                }
                                
                            }
                        }
                    }
                    }.resume()
            }
        }
        
    }
}

