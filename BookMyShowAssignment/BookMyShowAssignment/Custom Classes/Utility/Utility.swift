//
//  Utility.swift
//  BookMyShowAssignment
//
//  Created by Savleen on 13/04/21.
//

import UIKit
import MBProgressHUD
import SystemConfiguration

class Utility {

    static let sharedInstance = Utility()
    static private var activityIndicator: MBProgressHUD?
    private var toastLabel: UILabel?
    private init() {}
    
    // MARK: - Loader Methods
    static func showLoader() {
        DispatchQueue.main.async {
            if activityIndicator == nil {
                if let window = AppDelegate.shared?.window {
                    activityIndicator = MBProgressHUD.showAdded(to: window, animated: true)
                    activityIndicator?.label.text = "Loading..."
                }
            } else {
                hideLoader()
                showLoader()
            }
        }
    }
   
    static func hideLoader() {
        DispatchQueue.main.async {
            if let indicator = self.activityIndicator {
                indicator.hide(animated: true)
                activityIndicator = nil
            }
        }
    }

    // MARK: - Network Methods
    static func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    // MARK: - Set View CornerRadius,BorderWidth,Color
    class func setView(view : UIView, cornerRadius: CGFloat, borderWidth : CGFloat, color : UIColor)
        {
            view.layer.cornerRadius = cornerRadius
            view.layer.borderWidth = borderWidth
            view.layer.borderColor = color.cgColor
            view.layer.masksToBounds = true
        }
  
    
    
    // MARK: - Show Alert
    static func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            if let topController = UIApplication.topViewController() {
                if topController is UIAlertController {
                } else {
                    let alert = UIAlertController(title: title, message: message,
                                                  preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    topController.present(alert, animated: true, completion: nil)
                }
             }
        }
    }
    
}

