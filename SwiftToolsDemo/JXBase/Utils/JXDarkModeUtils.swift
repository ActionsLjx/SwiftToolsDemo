//
//  JXDarkUtils.swift
//  SwiftToolsDemo
//
//  Created by ken Z on 2024/9/13.
//

import UIKit

public class JXDarkModeUtils {
  
    /// 是否浅色模式的key
    private static let JXDarkModeKey = "kUserdefaults_JXDarkModeKey"
    
    /// 获取颜色模式
    public static var darkModel: UIUserInterfaceStyle {
        let vaule = kUserDefaultsValueIntegerForKey(key: JXDarkModeKey)
        let type = UIUserInterfaceStyle.init(rawValue: vaule) ?? .unspecified
        return type
    }

}
// MARK:- 方法的调用
public extension JXDarkModeUtils {
  
    static func config(){
        setDarkMode(type: darkModel)
    }
    
    static func setDarkMode(type:UIUserInterfaceStyle){
        let value = type.rawValue
        kUserDefaultsSetVauleForKey(value: type.rawValue, key: JXDarkModeKey)
        UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.overrideUserInterfaceStyle = type
    }
}
