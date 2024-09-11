//
//  JXBaseVC.swift
//  NasiLive2th
//
//  Created by ken Z on 2023/5/8.
//

import UIKit
import WebKit
import JXPhotoBrowser
import Kingfisher

class JXBaseVC: UIViewController {
    
    
    //嵌套scrollview滑动方法 使用属性
    /// 父view
    var currentVC:JXBaseVC?
    var maxOffset:CGFloat = 100
    var superCanScroll = true
    /// 子view
    var childCanScroll = false
    var superCanScrollBlock: ((Bool) -> Void)?
    //end
    
    lazy var backBtn:UIButton = {
        let view = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        view.addTarget(self, action: #selector(goBackAction), for: .touchUpInside)
        view.setImage(UIImage(named: "common_naviBack"), for: .normal)
        view.setImage(UIImage(named: "common_naviBack_withe"), for: .selected)
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kColor_bgGaryColor
        // Do any additional setup after loading the view.
    }
}

// MARK: 嵌套scrollview滑动方法
extension JXBaseVC {
    //父view 使用
    func linkSuperScrollViewDidScroll(_ scrollView: UIScrollView) {
        if !superCanScroll {
            scrollView.contentOffset.y = maxOffset
            currentVC?.childCanScroll = true
        } else {
            if scrollView.contentOffset.y >= maxOffset {
                scrollView.contentOffset.y = maxOffset
                superCanScroll = false
                currentVC?.childCanScroll = true
            }
        }
    }
    // 子view 使用
    //在scrollViewDidScroll方法内部调用
    func linkSubViewDidScroll(_ scrollView:UIScrollView) {
        if(superCanScrollBlock == nil){
            return
        }
        if !childCanScroll {
            scrollView.contentOffset.y = 0
        } else {
            if scrollView.contentOffset.y <= 0 {
                childCanScroll = false
                superCanScrollBlock?(true)
            }
        }
    }
}


// MARK: 点击大图播放视频/显示图片
extension JXBaseVC {
    //展示大图列表
    func showPhotoBrowser(urlList:[URL],currentIndex:Int,isLocal:Bool){
        let browser = JXBasePhotoBrowserVC()
        browser.isLocal = isLocal
        browser.urlList = urlList
        browser.numberOfItems = {
            urlList.count
        }
        browser.reloadCellAtIndex = { context in
            let browserCell = context.cell as? JXPhotoBrowserImageCell
            
            browserCell?.imageView.kf.setImage(with: urlList[context.index],placeholder: kPlaceholder)
        }
        browser.pageIndex = currentIndex
        browser.show(method: .push(inNC: self.navigationController))
        browser.title = "\(currentIndex + 1)/\(urlList.count)"
        browser.didChangedPageIndex = {page in
            browser.title = "\(page + 1)/\(urlList.count)"
        }
    }
    
    static func showPhotoBrowser(urlList:[URL],currentIndex:Int,isLocal:Bool){
        let browser = JXBasePhotoBrowserVC()
        browser.isLocal = isLocal
        browser.urlList = urlList
        browser.numberOfItems = {
            urlList.count
        }
        browser.reloadCellAtIndex = { context in
            let browserCell = context.cell as? JXPhotoBrowserImageCell
            
            browserCell?.imageView.kf.setImage(with: urlList[context.index],placeholder: kPlaceholder)
        }
        browser.pageIndex = currentIndex
        browser.show(method: .push(inNC: kGetCurrentController()?.navigationController))
        browser.title = "\(currentIndex + 1)/\(urlList.count)"
        browser.didChangedPageIndex = {page in
            browser.title = "\(page + 1)/\(urlList.count)"
        }
    }
}

// MARK:  navigation config方法
extension JXBaseVC {
    @objc func goBackAction(){
        for view in self.view.subviews{
            if view is WKWebView{
                let webView = view as! WKWebView
                if webView.canGoBack{
                    webView.goBack()
                    return
                }
            }
        }
        if((self.navigationController?.viewControllers.count ?? 0) <= 1){
            self.dismiss(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true);
        }
    }
    
    func showGobackBtn(isWithe:Bool = false) {
        let back = UIBarButtonItem.init(customView:backBtn)
        backBtn.isSelected = isWithe
        self.navigationItem.leftBarButtonItems = [back]
    }
    
    func hideBackBtn() {
        let back = UIBarButtonItem.init(customView:UIView())
        self.navigationItem.leftBarButtonItems = [back]
    }
    
    func configNaviBarTransparent(titleColor:UIColor?) {

        if #available(iOS 15.0, *){
            let appbar = UINavigationBarAppearance()
            appbar.backgroundColor = UIColor.clear
            appbar.backgroundEffect = nil
            appbar.shadowColor = nil
            appbar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: titleColor ?? UIColor.white]
            self.navigationController?.navigationBar.scrollEdgeAppearance = appbar
            self.navigationController?.navigationBar.standardAppearance = appbar
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        }else{
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .top, barMetrics: .default)
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        }
    }
    
    func configNaviBarDefault() {
        if #available(iOS 15.0, *){
            let appbar = UINavigationBarAppearance()
            appbar.backgroundColor = UIColor.white
            appbar.backgroundEffect = nil
            appbar.shadowColor = nil
            appbar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black]
            self.navigationController?.navigationBar.scrollEdgeAppearance = appbar
            self.navigationController?.navigationBar.standardAppearance = appbar
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        }else{
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .top, barMetrics: .default)
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        }
    }
    
    func configNaviBar(backgroundColor:UIColor,barTintColor:UIColor = UIColor.black){
        if #available(iOS 15.0, *){
            let appbar = UINavigationBarAppearance()
            appbar.backgroundColor = backgroundColor
            appbar.backgroundEffect = nil
            appbar.shadowColor = nil
            appbar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black]
            self.navigationController?.navigationBar.scrollEdgeAppearance = appbar
            self.navigationController?.navigationBar.standardAppearance = appbar
            self.navigationController?.navigationBar.barTintColor = UIColor.red
            var attrs = self.navigationController?.navigationBar.titleTextAttributes
                        if attrs == nil {
                            attrs = [:]
                        }
            attrs?[NSAttributedString.Key.foregroundColor] = barTintColor
            self.navigationController?.navigationBar.titleTextAttributes = attrs
        }else{
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .top, barMetrics: .default)
            self.navigationController?.navigationBar.backgroundColor = backgroundColor
            self.navigationController?.navigationBar.barTintColor = barTintColor
        }
    }
}
