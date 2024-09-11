//
//  JXDoubleExtension.swift
//  Goallive
//
//  Created by ken Z on 2023/10/30.
//

import UIKit

extension Double {
    /// 小数点后如果只是0，显示整数，如果不是，显示原来的值
     
        var cleanZero : String {
     
            return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
     
        }
}
