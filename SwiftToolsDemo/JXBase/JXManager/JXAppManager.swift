//
//  JXAppManager.swift
//  SwiftToolsDemo
//
//  Created by ken Z on 2024/9/10.
//

import UIKit
import IQKeyboardManager
import YYText
class JXAppManager: NSObject {
    static let share = JXAppManager.init()

    //app登录状态
    var isAppLogin:Bool {
        get{
            return kUserDefaultsValueBoolForKey(key: kUserDefault_isAppLogin)
        }
    }
    
    //蒙版
    private var isTouchHide:Bool = true
    private var maskViewList:[UIView] = []
    private var overlayView:UIView = {
        let overlayView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 设置灰色遮罩的透明度
        return overlayView
    }()
}

// MARK: ========== App Login模块 ==========
// MARK: --------- 公开方法
extension JXAppManager{
    
    //更新信息
    func updateAppLoginRefresh(uid:Any?,token:String?,refreshToken:String?){
        if let uid = uid {
            kUserDefaultsSetVauleForKey(value: uid, key: kUserDefault_uid)
        }
        if let token = token {
            kUserDefaultsSetVauleForKey(value: token, key: kUserDefault_token)
        }
        if let refreshToken = refreshToken {
            kUserDefaultsSetVauleForKey(value: refreshToken, key: kUserDefault_refreshToken)
        }
    }
    
    //点击登录调用 方法会发送登录通知
    func loginAppState(){
        kUserDefaultsSetVauleForKey(value: true, key: kUserDefault_isAppLogin)
        NotificationCenter.post(customeNotificationType: .JXAppLoginStateChange)
    }
    
    //token失效或者登出调用 方法发送登出通知
    func logoutAppState(){
        if(!self.isAppLogin){ //防止重复通知
            return
        }
        kUserDefaultsSetVauleForKey(value: false, key: kUserDefault_isAppLogin)
        kUserDefaultsRemoveForKey(key: kUserDefault_uid)
        kUserDefaultsRemoveForKey(key: kUserDefault_token)
        kUserDefaultsRemoveForKey(key: kUserDefault_refreshToken)
        NotificationCenter.post(customeNotificationType: .JXAppLoginStateChange)
    }
}

extension JXAppManager{
    private func logoutApp(){
        
    }
}
// MARK: ========== App Login End ==========


extension JXAppManager{
    
    //因为有深色模式配置 必须在winds初始化之后调用
    func config(){
        APIClient.shared.startNetListen()
        configMaskView()
        configIQKeyboard()
//        JXDarkModeUtils.config()
    }
    
    private func configIQKeyboard(){
        let manager = IQKeyboardManager.shared()
        manager.isEnableAutoToolbar = false
        manager.isEnabled = true
        manager.shouldResignOnTouchOutside = true
        manager.toolbarDoneBarButtonItemText = "完成"
        manager.registerTextFieldViewClass(YYTextView.self, didBeginEditingNotificationName: NSNotification.Name.YYTextViewTextDidBeginEditing.rawValue, didEndEditingNotificationName: NSNotification.Name.YYTextViewTextDidEndEditing.rawValue)
    }
}

// MARK: ========== 蒙版模块 ==========
// MARK: --------- 公开方法
extension JXAppManager{
    func showMask(subView:UIView,subSize:CGSize,isTouchHide:Bool = true,maskBgColor:UIColor = UIColor.black.withAlphaComponent(0.5)){
        self.maskViewList.append(subView)
        self.overlayView.isHidden = false
        self.isTouchHide = isTouchHide
        subView.frame = CGRect.init(x: (kScreenWidth - subSize.width)/2, y: kScreenHeight + subSize.height, width: subSize.width, height: subSize.height)
        self.overlayView.addSubview(subView)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                subView.frame = CGRect.init(x: (kScreenWidth - subSize.width)/2, y: kScreenHeight - subSize.height, width: subSize.width, height: subSize.height)
            } completion: { isComplete in
                    
            }

        }
    }
    
    //按蒙版view删除 如果传空则全部直接删除无动画
    func hidMask(subView:UIView?){
        guard let subView = subView else {
            self.overlayView.isHidden = true
            self.overlayView.removeSubviews()
            return
        }
        let subSize:CGSize = subView.size
        UIView.animate(withDuration: 0.2) {
            subView.frame = CGRect.init(x: (kScreenWidth - subSize.width)/2, y: kScreenHeight, width: subSize.width, height: subSize.height)
        } completion: { isComplete in
            subView.removeFromSuperview()
            self.maskViewList.removeAll(where: {$0 == subView})
            if(self.maskViewList.count == 0){
                self.overlayView.isHidden = true
            }
        }
    }
}
// MARK: --------- 私有方法
extension JXAppManager{
    //privacy
    private func configMaskView(){
        kCurrentWindow?.addSubview(self.overlayView)
        kCurrentWindow?.insertSubview(self.overlayView, at: 1)
        self.overlayView.isHidden = true
        self.overlayView.isUserInteractionEnabled = true
        let gester = UITapGestureRecognizer(target: self, action: #selector(maskTouchHide))
        gester.delegate = self
        self.overlayView.addGestureRecognizer(gester)
    }
    
    //被动点击隐藏
    @objc private func maskTouchHide(gesture:UIGestureRecognizer){
        if(!isTouchHide){
            return
        }
        hidMask(subView: self.overlayView.subviews.last)
        
    }
}

// MARK: --------- 蒙版UIGestureRecognizerDelegate
extension JXAppManager:UIGestureRecognizerDelegate{
    // 手势识别器代理方法
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let lastView = self.maskViewList.last else {
            return true
        }
        // 检查触摸点是否在view2上
        let locationInView = touch.location(in: self.overlayView)
        
        if lastView.frame.contains(locationInView) {
            return false // 如果在view2上，不接收触摸
        }
        return true // 否则接收触摸
    }
}
// MARK: ========== 蒙版模块 End ==========



