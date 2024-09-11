//
//  JXBasePhotoBrowserVC.swift
//  NasiLive2th
//
//  Created by ken Z on 2023/5/29.
//

import UIKit
import JXPhotoBrowser

class JXBasePhotoBrowserVC: JXPhotoBrowser {
    var urlList:[URL] = []
    
    var isLocal:Bool = false // 是否是本地资源  是则不显示更多按钮
    
    lazy private var backBtn:UIButton = {
        let view = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        view.addTarget(self, action: #selector(goBackAction), for: .touchUpInside)
        view.setImage(UIImage(named: "common_naviBack_withe"), for: .normal)
        return view
    }()
    
    lazy private var rightBtn:UIButton = {
        let view = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        view.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        view.setImage(UIImage(named: "common_more_h"), for: .normal)
        return view
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        configNaviBarTransparent(titleColor: UIColor.white)
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: self.backBtn)]
        self.navigationItem.rightBarButtonItems = isLocal ? [] : [UIBarButtonItem(customView: self.rightBtn)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
    }
    
    @objc private func goBackAction(){

        self.navigationController?.popViewController(animated: true);
    }
    
    @objc private func moreAction(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let ac1 = UIAlertAction(title: "保存到手机相册", style: .default) { _ in
            self.savePhoto()
        }
        let ac2 = UIAlertAction(title: "common.cancel".localStr(), style: .cancel)
        alert.addAction(ac1)
        alert.addAction(ac2)
        self.present(alert, animated: true)
    }
    
    private func savePhoto(){
        
        
    
    }
    
    private func configNaviBarTransparent(titleColor:UIColor?) {

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

}
