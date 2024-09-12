//
//  JXNotificationExtension.swift
//  NasiLive2th
//
//  Created by ken Z on 2023/5/8.
//

import UIKit

enum JXNotification:String {
    case JXNetConnectStateChange
    
    var stringValue:String {
        return "JX" + rawValue
    }
    
    var notificationName: NSNotification.Name {
        return NSNotification.Name(stringValue)
    }

}


extension NotificationCenter{
    static func post(customeNotificationType nameType: JXNotification, object: Any? = nil){
            NotificationCenter.default.post(name: nameType.notificationName, object: object)
        }
    
    
}
