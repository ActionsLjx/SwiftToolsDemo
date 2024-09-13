//
//  HomeVC.swift
//  SwiftToolsDemo
//
//  Created by ken Z on 2024/9/4.
//

import UIKit
import JXSegmentedView

class HomeVC: UIViewController,JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {

    lazy var sliderView: JXSegmentedIndicatorLineView = {
        let view = JXSegmentedIndicatorLineView()
        view.indicatorColor = UIColor.red
        view.indicatorWidth = 25 //横线宽度
        view.indicatorHeight = 3 //横线高度
        view.verticalOffset = 5 //垂直方向偏移
        return view
    }()

    lazy var dataSource: JXSegmentedNumberDataSource = {
        let ds = JXSegmentedNumberDataSource()
        ds.titles = ["全部","待付款","待发货","待收货","待评价"]
        ds.numbers = [1,0,0,0,0]//每个标题上的数字
        ds.titleNormalColor = UIColor.green
        ds.titleSelectedColor = UIColor.black//选中状态下的标题文字颜色
        return ds
    }()

    lazy var listContainerView: JXSegmentedListContainerView = {
          let lv = JXSegmentedListContainerView(dataSource: self)
          lv.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
          return lv
    }()

    lazy var segmentedView: JXSegmentedView = {
           let sv = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 50))
           sv.backgroundColor = UIColor.white //背景色
           sv.dataSource = dataSource //数据源
           sv.listContainer = listContainerView //视图容器
           sv.indicators = [sliderView] //标题下的横线
           sv.delegate = self //设置代理
           return sv
    }()

    ///全部
    lazy var allView: JXPageView = {
        let view = JXPageView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight ))
         return view
    }()
    ///待付款
    lazy var waitingPayView: JXPageView = {
        let view = JXPageView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight ))
      return view
    }()
    //待发货
    lazy var waitingDeliveryView: JXPageView = {
        let view = JXPageView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
       return view
    }()
    //待收货
    lazy var waitingTakeGoodsView: JXPageView = {
        let view = JXPageView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        return view
    }()
    //待评价
    lazy var waitingCommentView: JXPageView = {
        let view = JXPageView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
       return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.dynamicColor(light: .white, dark: .black)
        let btn1 = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 70, height: 30))
        btn1.backgroundColor = UIColor.dynamicColor(light: UIColor.red, dark: UIColor.yellow)
        btn1.setTitle("浅色", for: .normal)
        self.view.addSubview(btn1)
        btn1.addTarget(self, action: #selector(clickLight), for: .touchUpInside)
        
        let btn2 = UIButton.init(frame: CGRect.init(x: 100, y: 210, width: 70, height: 30))
        btn2.setTitle("深色", for: .normal)
        btn2.backgroundColor = UIColor.dynamicColor(light: UIColor.red, dark: UIColor.yellow)

        self.view.addSubview(btn2)
        btn2.addTarget(self, action: #selector(clickDark), for: .touchUpInside)
        
        let btn3 = UIButton.init(frame: CGRect.init(x: 100, y: 320, width: 70, height: 30))
        btn3.setTitle("自动", for: .normal)
        btn3.backgroundColor = UIColor.dynamicColor(light: UIColor.red, dark: UIColor.yellow)
        
        self.view.addSubview(btn3)
        btn3.addTarget(self, action: #selector(clickAuto), for: .touchUpInside)


    }
    
    @objc private func clickLight(){
    }

    @objc private func clickDark(){
        
    }
    
    @objc private func clickAuto(){
        
    }
    
    //MARK: JXSegmentedViewDelegate
       //点击标题 或者左右滑动都会走这个代理方法
       func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
           //这里处理左右滑动或者点击标题的事件
           
       }
       //MARK:JXSegmentedListContainerViewDataSource
       func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
           5 //跟标题数量一致
       }
       
       func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
           if index == 0 {
               return allView
           }
           else if index == 1 {
               return waitingPayView
           }
           else if index == 2 {
               return waitingDeliveryView
           }
           else if index == 3 {
               return waitingTakeGoodsView
           }
           else {
               return waitingCommentView
           }
       }

}
