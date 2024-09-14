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
    
    //全局验证码倒计时模块
    var smsReSendSec:Int = 0 //当剩余时间0可发送 不为0不能发送
    var smsCanSend:Bool{
        get{
            return smsReSendSec <= 0
        }
    }
    private let smsDefSec:Int = 30
    private var smsTimer:Timer?
    //蒙版
    private var isTouchHide:Bool = true
    private var maskViewList:[UIView] = []
    private var overlayView:UIView = {
        let overlayView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 设置灰色遮罩的透明度
        return overlayView
    }()
}

// MARK: ========== JXAppManager初始化 ==========
//公共方法
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

// MARK: ========== App Login模块 ==========
//公共方法
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

// MARK: ====================

// MARK: ========== 验证码模块 ==========
extension JXAppManager{
    //返回是否倒计时成功
    func smsStartCountDown() -> Bool{
        if(smsReSendSec > 0){
            return false
        }
        smsReSendSec = smsDefSec
        self.smsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(smsTimeGoesOn), userInfo: nil, repeats: true)
        self.smsTimer?.fire()
        return true
    }
    
    //手动重置倒计时状态 不再发送通知
    func smsTimeRemuse(){
        self.smsTimer?.invalidate()
        self.smsTimer = nil
        self.smsReSendSec = 0
    }
    
    //添加验证码倒计时监听
    func smsAddObserver(observer:Any,selector:Selector){
        NotificationCenter.default.addObserver(observer, selector: selector, name: JXNotification.JXSmsCodeReloadSecChange.notificationName, object: nil)
    }
    
    //验证码倒计时调用
    @objc private func smsTimeGoesOn(){
        self.smsReSendSec = self.smsReSendSec - 1
        if(smsReSendSec <= 0){
            smsTimeRemuse()
        }
        NotificationCenter.post(customeNotificationType: .JXSmsCodeReloadSecChange)
    }
    
}

// MARK: ========== 蒙版模块 ==========
//公共方法
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
//私有方法
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

// MARK: ========== 蒙版UIGestureRecognizerDelegate
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




