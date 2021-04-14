//
//  UIImageView+Extension.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 13/04/21.
//

import Foundation
import UIKit
import SDWebImage


extension UIImageView {
    func setImageWith(urlString:String,placeholderImage:String = "") {
        if let url = URL.init(string: urlString ) {
            let ph = UIImage.init(named: placeholderImage)
            self.sd_setImage(with: url, placeholderImage: ph, options: .refreshCached) { [weak self](image, error, cache, url) in
                if let this = self {
                if let img = image {
                    this.image = img
                } else {
                    this.image = ph
                }
                }
            }
        }
    }
    
}
