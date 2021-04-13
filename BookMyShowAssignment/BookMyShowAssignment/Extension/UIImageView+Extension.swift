//
//  UIImageView+Extension.swift
//  BookMyShowAssignment
//
//  Created by Savleen on 13/04/21.
//

import Foundation
import UIKit
import SDWebImage


extension UIImageView {
    func setImageWith(urlString:String,placeholderImage:String = "") {
        if let url = URL.init(string: urlString ) {
            let ph = UIImage.init(named: placeholderImage)
            self.sd_setImage(with: url, placeholderImage: ph, options: .refreshCached) { (image, error, cache, url) in
                if let img = image {
                    self.image = img
                } else {
                    self.image = ph
                }
            }
        }
    }
    
}
