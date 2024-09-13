//
//  HUDManager.swift
//  Goallive
//
//  Created by ken Z on 2023/9/5.
//
import UIKit
import Toast_Swift
import MKProgress


class HUDUtils: NSObject {    
    //点击是否隐藏
    static var isTapToDismissEnabled:Bool = true {
        didSet{
            ToastManager.shared.isTapToDismissEnabled = isTapToDismissEnabled
        }
    }
    
    static func showHud(msg:String,_ view:UIView? = kCurrentWindow,msgColor:UIColor? = nil,backgroundColor:UIColor? = nil,duration:TimeInterval = 1,position:ToastPosition = .center,complete:@escaping ((Bool)->()) = { _ in}){
        HUDUtils.hide(view: view)
        guard let view = view else {return}
        var style = ToastStyle()
        if let msgColor = msgColor{
            style.messageColor = msgColor
        }
        if let backgroundColor = backgroundColor{
            style.backgroundColor = backgroundColor        }
        view.makeToast(msg, duration: duration, position: position, style: style,completion: complete)
    }
    
    //正在加载toast
    //activityIndicator 菊花
    //radial 旋转
    static func showActivityLoading(view:UIView? = kCurrentWindow,hudType:HudType = .radial,logoImage:UIImage? = nil,tinkColor:UIColor = .darkGray,hudBgColor:UIColor = .white, maskBgColor:UIColor = UIColor(white: 0, alpha: 0.55)){
        HUDUtils.hide(view: view)
        guard let view = view else { return }
        MKProgress.config.hudType = .activityIndicator
        MKProgress.config.width = 110
        MKProgress.config.height = 110
        MKProgress.config.hudColor = hudBgColor  //hud背景色
        MKProgress.config.backgroundColor = maskBgColor  //hud 屏幕蒙版背景色
        MKProgress.config.cornerRadius = 16.0
        MKProgress.config.fadeInAnimationDuration = 0.2
        MKProgress.config.fadeOutAnimationDuration = 0.25
        MKProgress.config.hudYOffset = 15

        MKProgress.config.circleRadius = 40.0
        MKProgress.config.circleBorderWidth = 2.0
        MKProgress.config.circleBorderColor = tinkColor
        MKProgress.config.circleAnimationDuration = 0.9
        MKProgress.config.circleArcPercentage = 0.85
        MKProgress.config.logoImage = logoImage
        MKProgress.config.logoImageSize = CGSize(width: 40, height: 40)

        MKProgress.config.activityIndicatorStyle = .medium
        MKProgress.config.activityIndicatorColor = tinkColor
        MKProgress.config.preferredStatusBarStyle = .lightContent
        MKProgress.config.prefersStatusBarHidden = false
        MKProgress.show()

    }
    
    static func hide(view:UIView? = kCurrentWindow){
        view?.hideToast()
        view?.hideToastActivity()
        MKProgress.hide()
    }
    

    
}
