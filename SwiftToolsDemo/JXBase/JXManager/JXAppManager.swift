//
//  JXAppManager.swift
//  SwiftToolsDemo
//
//  Created by ken Z on 2024/9/10.
//

import UIKit

class JXAppManager: NSObject {
    static let share = JXAppManager.init()

    //用户登录状态
    var isUserLogin:Bool = false
    
    //深色模式
   
    
    //蒙版
    private var isTouchHide:Bool = true
    private var maskViewList:[UIView] = []
    private var overlayView:UIView = {
        let overlayView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 设置灰色遮罩的透明度
        return overlayView
    }()

    //JXAppManager初始配置
    override init() {
        super.init()
        configMaskView()
    }
    
}

// MARK: ========== 深色模式 ==========
// MARK: --------- 公开方法
extension JXAppManager{
   
     
}
// MARK: ========== 深色模式 End ==========

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



