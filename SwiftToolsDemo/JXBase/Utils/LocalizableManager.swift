//
//  LocalizableManager.swift
//  Goallive
//
//  Created by ken Z on 2023/9/5.
//


import UIKit

extension LocalizableManager{
    
    //初始化语言
    func configLanguage(){
        let type = LocalizableManager.getCurrnetLanguage()
        //返回项目中 .lproj 文件的路径
        switch type{
        case .english:
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            bundle = Bundle(path: path!)!
            break
        case .chinese:
            let path = Bundle.main.path(forResource: "zh-Hans", ofType: "lproj")
            bundle = Bundle(path: path!)!
            break
        case .auto:
            bundle = Bundle.main
            break
        }
    }
    
    
    //国际化字符串
    static func localValue(_ str:String) -> String {
        LocalizableManager.shared.localValue(str: str)
    }
    
    //修改语言
    static func setLanguage(_ type:LanguageType){
        if(getCurrnetLanguage() == type){
            return
        }
        LocalizableManager.shared.setLanguage(type)
    }
    
    static func getCurrnetLanguage() -> LanguageType {
        let defs = UserDefaults.standard
        if let preferredLanguage = defs.object(forKey: LocalizableManager.kUserdefaultCustomLanguageKey) as? String{
            switch preferredLanguage {
                case "en":
                    return .english//英文
                case "zh-Hans":
                    return .chinese//中文
                default:
                    return .auto
                }
        }
        //跟随系统
        let languages = defs.object(forKey: "AppleLanguages") as? [String] ?? ["zh-Hans"]//获取系统支持的所有语言集合
        let preferredLanguage = languages[0]//集合第一个元素为当前语言
        switch preferredLanguage {
            case "en-US", "en-CN":
                return .english//英文
            case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
                return .chinese//中文
            default:
                return .english
            }
    }
    
}


enum LanguageType {
    case chinese,
         english,
         auto
    
    var titleStr:String{
        get{
            switch self {
            case .auto:
                return "跟随".localStr()
            case .english:
                return "English"
            case .chinese:
                return "中文"
            }
        }
    }
}

class LocalizableManager: NSObject {
    
    //单例
    static let shared = LocalizableManager()
    static private let kUserdefaultCustomLanguageKey = "CustomLanguageKey"
     private override init() {
         super.init()
     }
    
    private var bundle:Bundle = Bundle.main
    
    private func localValue(str:String) -> String{
        //table参数值传nil也是可以的，传nil系统就会默认为Localizable
        return bundle.localizedString(forKey: str, value: nil, table: "Localizable")
    }
    
    //--------------修改语言
    private func setLanguage(_ type:LanguageType){
        switch type {
        case .chinese:
            UserDefaults.standard.setValue("zh-Hans", forKey: LocalizableManager.kUserdefaultCustomLanguageKey)
        case .english:
            UserDefaults.standard.setValue("en", forKey: LocalizableManager.kUserdefaultCustomLanguageKey)
        case .auto:
            //和系统语言一致
            UserDefaults.standard.removeObject(forKey: LocalizableManager.kUserdefaultCustomLanguageKey)
            break
        }
        self.setApplanguages(type: type)
        let list = [""]
        let _ = list[1] //退出app
        
    }

    
    //防止第三方语言包不更改 添加方法
    private func setApplanguages(type:LanguageType){
        if(type == .auto){ return }
        let languagevalue = type == .chinese ? "zh" : "en"
        let defs = UserDefaults.standard
        var languages = defs.object(forKey: "AppleLanguages") as? [String] ?? ["zh-Hans"]
        var frontIndex = 0
        for i in 0..<languages.count {
            if languages[i].hasPrefix(languagevalue) {
                languages.swapAt(i, frontIndex)
                frontIndex += 1
            }
        }
        defs.setValue(languages, forKey: "AppleLanguages")
    }
    //------------------end--------------
}
