//
//  BaseModel.swift
//  NasiLive2th
//
//  Created by ken Z on 2023/5/8.
//

import UIKit
import ObjectMapper

enum ResponseDataStatus {
    case success
    case failure
}

class BaseModel: Mappable {
    
    var msg: String?
    var code: Int?
    var data: Any?
    
    required init?(map: Map) {
        msg <- map["msg"]
        code <- map["code"]
        data <- map["data"]
    }
    
    func mapping(map: Map) {
        msg <- map["msg"]
        code <- map["code"]
        data <- map["data"]
    }
    
    func checkResult() -> ResponseDataStatus {
        if code == 0 {
            return .success
        }else{
            return .failure
        }
        
    }
    
    func getDataModel<T:Mappable>() -> T?{
        if let data = self.data,
           let dict = data as? [String:Any]{
             let model = T.init(JSON: dict)
            return model!
        }
        return nil
    }
    
    func getDataModelList<T:Mappable>() -> [T]{
        if let data = self.data {
            let list: Array<T> = Mapper<T>().mapArray(JSONObject: data) ?? []
            return list
        }
        return []
    }
    
    func getDict() -> [String:Any]?{
        if let dictionary = self.data as? [String: Any] {
            return dictionary
        } else {
            return nil
        }
    }
    
}
