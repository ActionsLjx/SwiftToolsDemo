//
//  APIClient.swift
//  SwiftToolsDemo
//
//  Created by ken Z on 2024/9/12.
//

import UIKit
import Moya
import Result
import Alamofire
import CommonCrypto
import SwiftyJSON
import ObjectMapper
import Reachability

enum APIError:Error{
    case mappingError
    case unknowError
    case networkError(code: Int, message: String)
    case customError(code:Int, message: String)
    case phoneNetError
    
    func showError(){
        switch self{
        case .mappingError:
            HUDUtils.showHud(msg: "apierror.mappingError".localStr())
            break
        case .unknowError:
            HUDUtils.showHud(msg:  "apierror.unknownError".localStr())
            break
        case .networkError(_,_):
            HUDUtils.showHud(msg:  "apierror.netConnectError".localStr())
            break
        case .customError(_,let message):
            HUDUtils.showHud(msg:  message)
            break
        case .phoneNetError:
            HUDUtils.showHud(msg: "apierror.phoneNetError")
        }
    }
}

extension APIClient{
    
    var isReachable: Bool {
        return reachability.connection != .unavailable
    }
    
    //网络状态监听
    func startNetListen(){
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(notification:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }
    
    @objc private func reachabilityChanged(notification: Notification) {
        guard let _ = notification.object as? Reachability else { return }
        NotificationCenter.post(customeNotificationType: .JXNetConnectStateChange)
        
    }

}

// 创建一个通用的API客户端
class APIClient {
    
    //网络状态监听
    private let reachability = try! Reachability()
    // 存储挂起的请求
    
    var pendingRequests: [(target: APIService, completion: (Result<BaseModel, APIError>) -> Void)] = []

    static let shared = APIClient()
    private let provider = MoyaProvider<APIService>()
    ///hudSuperView:HUD展示的父view 存在就展示hud加载
    func request(target: APIService,completion: @escaping (Result<BaseModel, APIError>) -> Void) -> Cancellable?{
        if !self.isReachable{
            completion(.failure(APIError.phoneNetError))
            return nil
        }
        return provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let suResponse = try response.filterSuccessfulStatusCodes()
                    let json = try JSON(data: suResponse.data)
                    if let object = Mapper<BaseModel>().map(JSONObject: json.dictionaryObject) {
                        switch object.checkResult(){
                        case .success:
                            completion(.success(object))
                            break
                        case .failure:
                            let errormsg =  "\(object.msg ?? "请求失败")"
                            let error = APIError.customError(code:object.code ?? 0, message: errormsg)
                            completion(.failure(error))
                            break
                        }
                    } else {
                        completion(.failure(APIError.mappingError))
                    }
                } catch let error as MoyaError{
                    let apiError = self.confiAPIError(moyaError: error)
                    switch apiError{
                    case .networkError(_,_):
                        completion(.failure(apiError))
                        break
                    default:
                        completion(.failure(apiError))
                        break
                    }
                } catch _{
                    completion(.failure(APIError.mappingError))
                }
                break
            case .failure(let error):
                let errormsg = error.localizedDescription
                let apierror = APIError.networkError(code: error.errorCode, message: errormsg)
                completion(.failure(apierror))
                break
            }
        }
    }
    
    private func confiAPIError(moyaError:MoyaError) -> APIError{
        switch moyaError {
        case .imageMapping(_),
                .jsonMapping(_),
                .stringMapping(_),
                .objectMapping(_, _),
                .encodableMapping(_),
                .parameterEncoding(_),
                .requestMapping(_):
            return APIError.mappingError
        case .statusCode(let response):
            return APIError.networkError(code: response.statusCode, message: response.description)
        case .underlying(let nsError as NSError, _):
            return APIError.networkError(code: nsError.code, message: nsError.domain)
        }
    }
    
}
