//
//  Utility.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 13/04/21.
//

import UIKit
import SystemConfiguration

class Utility {
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
    static func setView(view : UIView, cornerRadius: CGFloat, borderWidth : CGFloat, color : UIColor)
        {
            view.layer.cornerRadius = cornerRadius
            view.layer.borderWidth = borderWidth
            view.layer.borderColor = color.cgColor
            view.layer.masksToBounds = true
        }
   
}

