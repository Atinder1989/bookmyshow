//
//  UIApplication+Extension.swift
//  BookMyShowAssignment
//
//  Created by Savleen on 13/04/21.
//

import Foundation
import UIKit

extension UIApplication {
    
    class func topViewController(controller: UIViewController? =
        UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            navigationController.visibleViewController?.navigationItem.backBarButtonItem =
                UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController.navigationBar.isTranslucent = false
            return topViewController(controller: navigationController.visibleViewController)
        }

        if let tabController = controller as? UITabBarController {
            if let selected = tabController.viewControllers?[tabController.selectedIndex] {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
}
