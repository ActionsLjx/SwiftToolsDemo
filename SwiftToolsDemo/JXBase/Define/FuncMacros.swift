//
//  FuncMacros.swift
//  NasiLive2th
//
//  Created by ken Z on 2023/5/8.
//

import Foundation
import UIKit
import UserNotifications
import AdSupport
import AVFoundation
import Photos
import YYText

// MARK: -----------------设备信息
func kDeviceId() -> String {
//    return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    return UIDevice.current.identifierForVendor?.uuidString ?? ASIdentifierManager.shared().advertisingIdentifier.uuidString
}

func KAppVersion() -> String{
    return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
}

func kAppDisplayName() -> String{
    return Bundle.main.localizedInfoDictionary!["CFBundleDisplayName"] as! String
}

func kGetTabbarHeight() -> CGFloat {
    let tabbarVC = UITabBarController.init()
    return tabbarVC.tabBar.frame.size.height
}

func kGetSafeBottomHeight() -> CGFloat {
    return UIApplication.shared.currentWindow?.safeAreaInsets.bottom ?? 20
}

// MARK: -----------------UserDefaults

func kUserDefaultsSetVauleForKey(value: Any, key: String) {
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func kUserDefaultsValueForKey(key: String) -> Any? {
    return UserDefaults.standard.value(forKey: key)
}

func kUserDefaultsValueIntegerForKey(key:String) -> NSInteger {
    return UserDefaults.standard.integer(forKey: key)
}

func kUserDefaultsValueBoolForKey(key:String) -> Bool {
    return UserDefaults.standard.bool(forKey: key)
}

func kUserDefaultsRemoveForKey(key: String) {
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
}

// MARK: -----------------当前vc

func kGetCurrentController() -> (UIViewController?) {
   var window = UIApplication.shared.keyWindow
   if window?.windowLevel != UIWindow.Level.normal{
     let windows = UIApplication.shared.windows
     for  windowTemp in windows{
       if windowTemp.windowLevel == UIWindow.Level.normal{
          window = windowTemp
          break
        }
      }
    }
   let vc = window?.rootViewController
   return currentViewController(vc)
}


private func currentViewController(_ vc :UIViewController?) -> UIViewController? {
   if vc == nil {
      return nil
   }
   if let presentVC = vc?.presentedViewController {
      return currentViewController(presentVC)
   }
   else if let tabVC = vc as? UITabBarController {
      if let selectVC = tabVC.selectedViewController {
          return currentViewController(selectVC)
       }
       return nil
    }
    else if let naiVC = vc as? UINavigationController {
       return currentViewController(naiVC.visibleViewController)
    }
    else {
       return vc
    }
 }

// MARK: -----------------跳转外部
func kJumpToWeb(jumpUrl:String?){
    if let url = URL.init(string: jumpUrl ?? ""){
        UIApplication.shared.open(url)
    }
}

// MARK: -----------------字符串,分割的数组相互转换
func kGetArrToStr(arr:[String]) -> String {
    var arrStr = ""
    for str in arr.enumerated() {
        if(str.offset == 0){
            arrStr = str.element
        }else{
            arrStr = arrStr + ","+str.element
        }
    }
    return arrStr
}

func kGetStrToArr(str:String) -> [String]{
    if(str.count == 0){
        return []
    }
    return str.components(separatedBy: ",")
}

func kFormatNum(num:Double) -> String{
    if num > 10000.0{
        return String(format: "%0.2fw", num/10000.0)
    }
    if num > 1000.0{
        return String(format: "%0.2k", num/1000.0)
    }
    return String(format: "%d", Int(num))
}


// MARK: -----------------富文本
func kAtrAppend(attrList:[NSAttributedString]) -> NSAttributedString{
    let atr = NSMutableAttributedString()
    for str in attrList{
        atr.append(str)
    }
    return atr
}

func kGetAttrSize(attr:NSAttributedString,maxW:CGFloat,fixedLineHeight:CGFloat = 0) -> CGSize?{
    let modifier2 = YYTextLinePositionSimpleModifier.init()
    modifier2.fixedLineHeight = fixedLineHeight

    let container2 = YYTextContainer.init(size: CGSize.init(width: maxW, height: CGFloat.greatestFiniteMagnitude))
    if fixedLineHeight != 0 {
        container2.linePositionModifier = modifier2
    }
    let layout2 = YYTextLayout.init(container: container2, text: attr)
    let size2 = layout2?.textBoundingSize
    return size2
}

func kGetAttrSize(attr:NSAttributedString,maxH:CGFloat,fixedLineHeight:CGFloat = 0) -> CGSize?{
    let modifier2 = YYTextLinePositionSimpleModifier.init()
    modifier2.fixedLineHeight = fixedLineHeight

    let container2 = YYTextContainer.init(size: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: maxH))
    if(fixedLineHeight != 0){
        container2.linePositionModifier = modifier2
    }
    let layout2 = YYTextLayout.init(container: container2, text: attr)
    let size2 = layout2?.textBoundingSize
    return size2
}

func kGetConetntAtr(content:Any,font:UIFont,contentSize:CGSize) -> NSAttributedString {
    let imgAtr = NSAttributedString.yy_attachmentString(withContent: content, contentMode: .scaleAspectFit, attachmentSize: contentSize, alignTo: font, alignment: .center)
    imgAtr.addAttributes([.font:font], range: imgAtr.yy_rangeOfAll())
    return imgAtr
}

//PHAsset转换url
func kRequetPhAsset(phAsset: PHAsset, completed: ((_ url: URL?) -> Void)?) {
        PHCachingImageManager.default().requestAVAsset(forVideo: phAsset, options: nil, resultHandler: { (video, audioMix, info) in
            DispatchQueue.main.async {
                var url: URL?
                if let urlAsset = video as? AVURLAsset {
                    url = urlAsset.url
                }
                completed?(url)
            }
        })
}
