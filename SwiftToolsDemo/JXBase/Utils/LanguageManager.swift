//
//  LocalizableManager.swift
//  Goallive
//
//  Created by ken Z on 2023/9/5.
//


import UIKit

extension LanguageManager{
    
    //初始化语言
    func configLanguage(){
        let type = LanguageManager.getCurrnetLanguage()
        //返回项目中 .lproj 文件的路径
        switch type{
        case .english:
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            bundle = Bundle(path: path!)!
            break
        case .chineseSimplified,
                .chineseTraditional:
            let path = Bundle.main.path(forResource: "zh-Hant", ofType: "lproj")
            bundle = Bundle(path: path!)!
            break
        case .auto:
            bundle = Bundle.main
            break
        }
    }
    
    //
    static func getLangId() -> Int{
        let defs = UserDefaults.standard
        var preferredLanguage:String?
        preferredLanguage = defs.object(forKey: LanguageManager.kUserdefaultCustomLanguageKey) as? String
        //跟随系统
        if(preferredLanguage == nil){
            let languages = defs.object(forKey: "AppleLanguages") as? [String] ?? ["en-US"]//获取系统支持的所有语言集合
            preferredLanguage = languages.first//集合第一个元素为当前语言
        }
        guard let preferredLanguage = preferredLanguage else {
            return 1 //英文
        }
        if(preferredLanguage.contains("Hans")){
            return 2 //简体中文
        }else if(preferredLanguage.contains("Hant")){
            return 3 //繁体中文
        }else{
            return 1 //英文
        }
    }
    
    
    //国际化字符串
    static func localValue(_ str:String) -> String {
        LanguageManager.shared.localValue(str: str)
    }
    
    //修改语言
    static func setLanguage(_ type:LanguageType){
        if(getCurrnetLanguage() == type){
            return
        }
        LanguageManager.shared.setLanguage(type)
    }
    
    static func getCurrnetLanguage() -> LanguageType {
        let defs = UserDefaults.standard
        var preferredLanguage:String?
        preferredLanguage = defs.object(forKey: LanguageManager.kUserdefaultCustomLanguageKey) as? String
        //跟随系统
        if(preferredLanguage == nil){
            let languages = defs.object(forKey: "AppleLanguages") as? [String] ?? ["en-US"]//获取系统支持的所有语言集合
            preferredLanguage = languages.first//集合第一个元素为当前语言
        }
        if let preferredLanguage = preferredLanguage {
            if(preferredLanguage.contains("Hans")){
                return .chineseSimplified
            }else if(preferredLanguage.contains("Hant")){
                return .chineseTraditional
            }else{
                return .english
            }
        }
        return .auto
    }
    
    static func getAppTargetLanguageStr() -> String{
        let defs = UserDefaults.standard
        let languages = defs.object(forKey: "AppleLanguages") as? [String] ?? ["zh-Hant"]//获取系统支持的所有语言集合
        let preferredLanguage = languages[0]//集合第一个元素为当前语言
        
        if let preferredLanguage = defs.object(forKey: LanguageManager.kUserdefaultCustomLanguageKey) as? String{
            if(preferredLanguage.contains("Hans")){
                return "zh"
            }else if(preferredLanguage.contains("Hant")){
                return "zh"
            }else{
                return "en"
            }
        }
        return "en"
    }
    
}


enum LanguageType {
    case chineseSimplified,
         chineseTraditional,
         english,
         auto
    
    var titleStr:String{
        get{
            switch self {
            case .auto:
                return "setting.sys.followsys".localStr()
            case .english:
                return "English"
            case .chineseSimplified:
                return "简体中文"
            case .chineseTraditional:
                return "繁体中文"
            }
        }
    }
}

class LanguageManager: NSObject {
    
    //单例
    static let shared = LanguageManager()
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
        case .chineseSimplified:
            UserDefaults.standard.setValue("zh-Hant", forKey: LanguageManager.kUserdefaultCustomLanguageKey)
            break
        case .chineseTraditional:
            UserDefaults.standard.setValue("zh-Hant", forKey: LanguageManager.kUserdefaultCustomLanguageKey)
            break
        case .english:
            UserDefaults.standard.setValue("en", forKey: LanguageManager.kUserdefaultCustomLanguageKey)
            break
        case .auto:
            //和系统语言一致
            UserDefaults.standard.removeObject(forKey: LanguageManager.kUserdefaultCustomLanguageKey)
            break
        }
        self.setApplanguages(type: type)
        let list = [""]
        let _ = list[1] //退出app
        
    }

    
    //防止第三方语言包不更改 添加方法
    private func setApplanguages(type:LanguageType){
        if(type == .auto){ return }
        let languagevalue = type == .chineseSimplified ? "zh" : "en"
        let defs = UserDefaults.standard
        var languages = defs.object(forKey: "AppleLanguages") as? [String] ?? ["zh-Hant"]
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
