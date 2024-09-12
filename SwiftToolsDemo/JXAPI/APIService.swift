//
//  NetworkAPI.swift
//  Goallive
//
//  Created by ken Z on 2023/10/26.
//

import Moya
import ObjectMapper
import Result
import SwiftyJSON


// 创建一个枚举来定义你的API端点
enum APIService {
    case test

}

extension APIService: TargetType {
    
    var path: String {
        switch self {
        case .test:
            return ""
        }
        return ""
    
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .post
        }
    }
    
    public var parameters:[String: Any]? {
        var params : [String:Any] = [:]
        params["platform"] = "1"
        params["pageSize"] = kPageSize
        switch self {
        default:
            return params
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            if(self.method == .post){
                return JSONEncoding.default
            }
            return URLEncoding.default
        }
    }
    
}

// MARK: 不常用参数
extension APIService{
    var baseURL: URL {
        switch self{
        default:
            return URL(string: "\(BASEURL)")!
        }
    }
    
    var headers: [String: String]? {
        switch self{
        default:
            if let token = kUserDefaultsValueForKey(key: kUserDefault_token) as? String{
                let relToken = "Bearer \(token)"
                return ["Authorization":relToken,
                        "Accept-Language":LocalizableManager.getCurrnetLanguage() == .chinese ? "zh_CN" : "en_US"
                ]
            }
            return ["Accept-Language":LocalizableManager.getCurrnetLanguage() == .chinese ? "zh_CN" : "en_US"
            ]
            
        }
    }
    
    var task: Task {
        switch self {
//        case .uploadImg(let url,let image):
//            if let url = url{
//                let fileName = "iOS\(kUserDefaultsValueForKey(key: kUserDefault_uid) ?? "guest")\(Date().timeIntervalSince1970.cleanZero).png"
//                let formData = MultipartFormData(provider:.file(url), name: "file", fileName: fileName, mimeType: "image/png")
//                return .uploadMultipart([formData])
//            }
//            if let image = image,
//               let imgdata = image.pngData(){
//                let fileName = "iOS\(kUserDefaultsValueForKey(key: kUserDefault_uid) ?? "guest")\(Date().timeIntervalSince1970).png"
//                let formData = MultipartFormData(provider:.data(imgdata), name: "file", fileName: fileName, mimeType: "image/png")
//                return .uploadMultipart([formData])
//            }
//            return .requestParameters(parameters:parameters ?? [:], encoding: parameterEncoding)
        default:
            return .requestParameters(parameters:parameters ?? [:], encoding: parameterEncoding)
        }
    }
    
    var sampleData: Data {
        return Data()
    }
}
