//
//  JXAlertaActionExtension.swift
//  NasiLive2th
//
//  Created by ken Z on 2023/5/15.
//

import Foundation
import UIKit

extension UIAlertAction {
    
    //设置标题颜色
    func setTitleColor(color:UIColor){
        self.setValue(color, forKey: "titleTextColor")
    }
}
