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
        APIClient.shared.startNetListen()
        configIQKeyboard()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = HomeVC()
        window?.makeKeyAndVisible()
        return true
        
    }
    
}

//三方配置初始化
extension AppDelegate{
    private func configIQKeyboard(){
        let manager = IQKeyboardManager.shared()
        manager.isEnableAutoToolbar = false
        manager.isEnabled = true
        manager.shouldResignOnTouchOutside = true
        manager.toolbarDoneBarButtonItemText = "完成"
        manager.registerTextFieldViewClass(YYTextView.self, didBeginEditingNotificationName: NSNotification.Name.YYTextViewTextDidBeginEditing.rawValue, didEndEditingNotificationName: NSNotification.Name.YYTextViewTextDidEndEditing.rawValue)
    }
}
