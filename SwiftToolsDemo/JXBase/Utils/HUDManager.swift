//
//  HUDManager.swift
//  Goallive
//
//  Created by ken Z on 2023/9/5.
//
import UIKit
import Toast_Swift
import NVActivityIndicatorView


class HUDManager: NSObject {
    static let share = HUDManager()
    
    lazy private var activityIndicatorView:NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect.init(x: 10, y: 10, width: 80, height: 80),type: .circleStrokeSpin,color: kColor_mainGreenColor)
        return view
    }()
    
    lazy private var activityIndicatorBgView:UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        view.addSubview(self.activityIndicatorView)
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        return view
    }()
    
    func showHud(view:UIView?,msg:String,_ msgColor:UIColor = UIColor.white, _ duration:TimeInterval = 1, _ position:ToastPosition = .center,complete:@escaping ((Bool)->()) = { _ in}){
        guard let view = view else {return}
        self.hide(view: view)
        var style = ToastStyle()
        // this is just one of many style options
        style.messageColor = msgColor
        // present the toast with the new style
        view.makeToast(msg, duration: duration, position: position, style: style,completion: complete)
    }
    
    //正在加载toast
    func showActivityLoading(view:UIView?){
        guard let view = view else { return }
        self.hide(view: view)
        view.isUserInteractionEnabled = false
        self.activityIndicatorBgView.removeFromSuperview()
        self.activityIndicatorBgView.center = view.center
        view.addSubview(self.activityIndicatorBgView)
        self.activityIndicatorView.startAnimating()

    }
    
    func hide(view:UIView?){
        guard let view = view else { return }
        view.isUserInteractionEnabled = true
        view.hideToast()
        view.hideToastActivity()
        self.activityIndicatorBgView.removeFromSuperview()
        self.activityIndicatorView.stopAnimating()
    }
    

    
}
