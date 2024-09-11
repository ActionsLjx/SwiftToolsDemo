//
//  JXBaseTabbarVC.swift
//  NasiLive2th
//
//  Created by ken Z on 2023/5/8.
//

import UIKit


class JXBaseTabbarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configChildController()
        self.delegate = self
        
    }
    
    override func viewWillLayoutSubviews() {
        let frame = self.tabBar.frame
        let newFrame = CGRect.init(origin: frame.origin, size: CGSize.init(width: frame.size.width, height: 55))
        self.tabBar.frame = newFrame
    }
    
    private func configUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: UIView.init())
        navigationItem.backBarButtonItem = UIBarButtonItem.init(customView: UIView.init())
        self.hidesBottomBarWhenPushed = true
        self.selectedIndex = 0
        navigationItem.hidesBackButton = true
        self.tabBar.barTintColor = UIColor.clear
        self.tabBar.backgroundColor = UIColor.clear
        self.tabBar.shadowImage = UIImage()
        self.tabBar.barStyle = .black
        
    }
    
    private func configChildController() {
        let home = configTabBarController(HomeVC(), title: "首页", image: "tabbar_home_def", seleImage: "tabbar_home_sel", seleColor: kColor_textBlack)
        let order = configTabBarController(HomeVC(), title: "订单", image: "tabbar_order_def", seleImage: "tabbar_order_sel", seleColor: kColor_textBlack)
        let add = configCenterTabBarController(HomeVC(), image: "tabbar_add_def", seleImage: "tabbar_add_sel", seleColor: kColor_textBlack)
        let creycler = configTabBarController(HomeVC(), title: "回收员", image: "tabbar_woker_def", seleImage: "tabbar_woker_sel", seleColor: kColor_textBlack)
        let mine = configTabBarController(HomeVC() , title: "我的".localStr(), image: "tabbar_mine_def", seleImage: "tabbar_mine_sel", seleColor: kColor_textBlack)
        self.setViewControllers([home,order,add,creycler,mine], animated: false)
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.backgroundImage = UIImage()
        
    }
    
    private func configTabBarController(_ viewController:UIViewController, title:String, image:String, seleImage:String,seleColor:UIColor) -> UIViewController {
        viewController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        viewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        viewController.title = title
        viewController.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 10),.foregroundColor: kColor_textBlack], for: .normal)
        viewController.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 10),.foregroundColor: seleColor], for: .selected)
        viewController.tabBarItem.badgeColor = UIColor.clear
        viewController.tabBarItem.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.selectedImage = UIImage(named: seleImage)?.withRenderingMode(.alwaysOriginal)
        let rootvc = JXBaseNavigationVC.init(rootViewController: viewController)
        
      return rootvc
    }
    
    private func configCenterTabBarController(_ viewController:UIViewController, image:String, seleImage:String,seleColor:UIColor) -> UIViewController {
        viewController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 9, left: 0, bottom: -9, right: 0)
        viewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        viewController.title = nil
        viewController.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 10),.foregroundColor: kColor_textBlack], for: .normal)
        viewController.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 10),.foregroundColor: seleColor], for: .selected)
        viewController.tabBarItem.badgeColor = UIColor.clear
        viewController.tabBarItem.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.selectedImage = UIImage(named: seleImage)?.withRenderingMode(.alwaysOriginal)
        let rootvc = JXBaseNavigationVC.init(rootViewController: viewController)
      return rootvc
    }
}

extension JXBaseTabbarVC:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController) ?? 0
     
        return true
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // 获取当前选中的标签栏项的索引
//        let currentIndex = tabBarController.selectedIndex
        
        // 如果当前选中的是第二个标签栏项
      
    }
}

