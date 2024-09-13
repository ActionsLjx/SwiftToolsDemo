 //
//  EnumMacros.swift
//  NasiLive2th
//
//  Created by ken Z on 2023/5/31.
//

import UIKit

//订单状态分类
enum OrderStateType:Int{
    case all           = 0      //全部
    case reserved      = 1      //已预约 待处理

    var titleStr:String{
        switch self{
        case .all:
            return "全部"
        case .reserved:
            return "已预约"
        }
    }
    
}

 extension JXAppManager{
    func test1(){}
    
    private func testApp(){
        
    }
}
