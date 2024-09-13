//
//  AppDelegate.swift
//  SwiftToolsDemo
//
//  Created by ken Z on 2024/9/3.
//

import UIKit
import IQKeyboardManager
import YYText
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = HomeVC()
        window?.makeKeyAndVisible()
        JXAppManager.share.config()
        return true
        
    }
    
}


