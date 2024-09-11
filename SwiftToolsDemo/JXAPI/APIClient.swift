//
//  NetworkManager.swift
//  Goallive
//
//  Created by ken Z on 2023/10/26.
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
    
    func showError(hudSuperView:UIView? = nil){
        switch self{
        case .mappingError:
            HUDManager.share.showHud(view: hudSuperView, msg: "neterror.dataerror".localStr())
            break
        case .unknowError:
            HUDManager.share.showHud(view: hudSuperView, msg: "neterror.unknown".localStr())
            break
        case .networkError(_,_):
            HUDManager.share.showHud(view: hudSuperView, msg:"neterror.neterror".localStr())
            break
        case .customError(_,let message):
            HUDManager.share.showHud(view: hudSuperView, msg:message)
            break
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
        guard let reaachability = notification.object as? Reachability else { return }
        NotificationCenter.post(customeNotificationType: .JXNetStateChange)
        
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
    func request(target: APIService,needReconnect:Bool = true,hudSuperView:UIView? = nil,completion: @escaping (Result<BaseModel, APIError>) -> Void) -> Cancellable{
        HUDManager.share.showActivityLoading(view: hudSuperView)
        return provider.request(target) { result in
            HUDManager.share.hide(view: hudSuperView)
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
                            self.APIErrorLogger(target: target, error: error,hudSuperView: hudSuperView)
                            completion(.failure(error))
                            break
                        }
                    } else {
                        self.APIErrorLogger(target: target, error: APIError.mappingError,hudSuperView: hudSuperView)
                        completion(.failure(APIError.mappingError))
                    }
                } catch let error as MoyaError{
                    let apiError = self.confiAPIError(moyaError: error)
                    self.APIErrorLogger(target: target, error: apiError,hudSuperView: hudSuperView)
                    switch apiError{
                    case .networkError(_,_):
                        completion(.failure(apiError))
                        break
                    default:
                        completion(.failure(apiError))
                        break
                    }
                } catch let error{
                    self.APIErrorLogger(target: target, error: APIError.mappingError,hudSuperView: hudSuperView)
                    completion(.failure(APIError.mappingError))
                }
                break
            case .failure(let error):
                
                let errormsg = error.localizedDescription
                let apierror = APIError.networkError(code: error.errorCode, message: errormsg)
                self.APIErrorLogger(target: target, error: apierror,hudSuperView: hudSuperView)
                completion(.failure(apierror))
                break
            }
        }
    }
    
    private func confiAPIError(moyaError:MoyaError) -> APIError{
        switch moyaError {
        case .imageMapping(let response):
            return APIError.mappingError
        case .jsonMapping(let response):
            return APIError.mappingError
        case .statusCode(let response):
            return APIError.networkError(code: response.statusCode, message: response.description)
        case .stringMapping(let response):
            return APIError.mappingError
        case .objectMapping(let error, let response):
            return APIError.mappingError
        case .encodableMapping(let error):
            return APIError.mappingError
        case .underlying(let nsError as NSError, let response):
            // now can access NSError error.code or whatever
            // e.g. NSURLErrorTimedOut or NSURLErrorNotConnectedToInternet
            return APIError.networkError(code: nsError.code, message: nsError.domain)
        case .underlying(let error, let response):
            return APIError.networkError(code: 404, message: "SS")
        case .requestMapping(let url):
            return APIError.mappingError
        case .parameterEncoding(let error):
            return APIError.mappingError
        }
    }
    
    ///hudSuperView:HUD展示的父view 存在就展示hud加载
    private func APIErrorLogger(target:APIService, error:APIError,hudSuperView:UIView? = nil){
        switch error{
        case .mappingError:
            print("----------NETWORKERROR----------\nAPI:\(target.path)\nParams:\(target.parameters ?? [:])\ntoken:\(kUserDefaultsValueForKey(key: kUserDefault_token) ?? "")\nMsg:mapping解析错误\n----------END-------------------")
            HUDManager.share.showHud(view: hudSuperView, msg: "neterror.dataerror".localStr())
            break
        case .networkError(let code,let message):
            print("----------NETWORKERROR----------\nAPI:\(target.path)\nParams:\(target.parameters ?? [:])\ntoken:\(kUserDefaultsValueForKey(key: kUserDefault_token) ?? "")\nMsg:\(message),code:\(code)\n----------END-------------------")
            HUDManager.share.showHud(view: hudSuperView, msg:"neterror.neterror".localStr())
            break
        case .customError(_,let message):
            print("----------NETWORKERROR----------\nAPI:\(target.path)\nParams:\(target.parameters ?? [:])\ntoken:\(kUserDefaultsValueForKey(key: kUserDefault_token) ?? "")\nMsg:\(message)\n----------END-------------------")
            HUDManager.share.showHud(view: hudSuperView, msg:message)
            break
        case .unknowError:
            print("----------NETWORKERROR----------\nAPI:\(target.path)\nParams:\(target.parameters ?? [:])\ntoken:\(kUserDefaultsValueForKey(key: kUserDefault_token) ?? "")\nMsg:\("未知错误")\n----------END-------------------")
            HUDManager.share.showHud(view: hudSuperView, msg:"neterror.unknown".localStr())
            break
        }
    }
    
}
