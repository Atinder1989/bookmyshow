//
//  UIView+Extension.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 13/04/21.
//

import Foundation
import UIKit

extension UIView {
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }
}
