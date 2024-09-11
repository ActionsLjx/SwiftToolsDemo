//
//  HomeVC.swift
//  SwiftToolsDemo
//
//  Created by ken Z on 2024/9/4.
//

import UIKit
import JTAppleCalendar

class HomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let btn = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 30, height: 80))
        btn.backgroundColor = UIColor.red
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)

    }
    
    @objc private func click(){
        JXCusCalendarView.show(currendDate: Date()) { selectDate in
            
        }
        let testview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 300))
        testview.backgroundColor = UIColor.red
        JXAppManager.share.showMask(subView: testview, subSize: CGSize(width: kScreenWidth, height: 300))
    }
}
