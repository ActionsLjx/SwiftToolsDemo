//
//  JXBaseNavigationVC.swift
//  NasiLive2th
//
//  Created by ken Z on 2023/5/8.
//

import UIKit

class JXBaseNavigationVC: UINavigationController,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
//
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .darkContent
    }
    
}
