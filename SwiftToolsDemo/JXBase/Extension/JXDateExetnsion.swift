//
//  JXDateExetnsion.swift
//  NasiLive2th
//
//  Created by ken Z on 2023/5/11.
//

import Foundation

extension Date {
    func isFutureDate() -> Bool {
        let nowDateInterval = Date().timeIntervalSince1970
        return self.timeIntervalSince1970 > nowDateInterval
    }
    
    func getDateToStr(formatterStr:String = "yyyy-MM-dd HH:mm:ss") -> String{
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = formatterStr
        return dateFormatter1.string(from: self)
    }
}
