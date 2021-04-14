//
//  AppDelegate.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 13/04/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    public static let shared = UIApplication.shared.delegate as? AppDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

}

