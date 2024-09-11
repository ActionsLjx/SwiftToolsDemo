//
//  JXStringExtension.swift
//  NasiLive2th
//
//  Created by ken Z on 2023/5/8.
//

import UIKit
import CommonCrypto
import YYText

// MARK: -----------------项目特殊方法
extension String{
    func fullUrlStr()->String{
//        if(self.hasPrefix("http")){
//            return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
//        }else{
//            let urlStr = "\(AppManager.share.configModel?.filesCdnDomain ?? "")\(self)"
//            return urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlStr
//        }
        return self
    }

}

// MARK: -----------------字符串判断
extension String{
    //判断是否为字母
    func isEnChar()->Bool{

        let letterRegex:NSPredicate=NSPredicate(format:"SELF MATCHES %@","^.*[A-Za-z]+.*$")

        if letterRegex.evaluate(with: self) {
            return true
        }
        return false

    }
    
    //判断是否为数字
    func isNumber()->Bool{
        let numberRegex:NSPredicate=NSPredicate(format:"SELF MATCHES %@","^.*[0-9]+.*$")
        if numberRegex.evaluate(with: self) {
            return true
        }
        return false
    }
    
    // 通过高阶函数allSatisfy，判断字符串是否为空串
    var isBlank:Bool{
        /// 字符串中的所有字符都符合block中的条件，则返回true
        let _blank = self.allSatisfy{
            let _blank = $0.isWhitespace
            print("isBlank字符：\($0) \(_blank)")
            return _blank
        }
        return _blank
    }
    ///通过裁剪字符串中的空格和换行符，将得到的结过进行isEmpty
    var isReBlank:Bool{
        let str = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return str.isEmpty
    }
    
}

// MARK: -----------------字符串转换
extension String {
    
    //国际化
    func localStr() -> String{
        return LocalizableManager.localValue(self)
    }
    
    //富文本
    func setJXAttribute(color:UIColor,font:UIFont) -> NSAttributedString{
        let attr: [NSAttributedString.Key : Any] = [.font: font,.foregroundColor: color]
        let attrStr = NSMutableAttributedString.init(string: self, attributes: attr)
        return attrStr
    }
    
    func getHeight(width:CGFloat,font:UIFont)->CGFloat {
        let size = CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        return rect.height
    }
    
    func getWidth(height:CGFloat,font:UIFont) -> CGFloat {
        let size = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: height)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        return rect.width
    }
    
    //加密
    public var jxMD5: String {
           guard let data = data(using: .utf8) else {
               return self
           }
           var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))

           #if swift(>=5.0)

           _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
               return CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
           }

           #else

           _ = data.withUnsafeBytes { bytes in
               return CC_MD5(bytes, CC_LONG(data.count), &digest)
           }

           #endif

           return digest.map { String(format: "%02x", $0) }.joined()

       }
    
    //获取首字母  如果为空返回#
    func getFirstEnChar() -> String{
        if(self.count == 0){
            return "#"
        }
        let str = NSMutableString(string: self) as CFMutableString
        CFStringTransform(str, nil, kCFStringTransformToLatin, false)
        
        // 拼音去掉拼音的音标
        CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false)
        
        // 大写字母
        var s: String = String(str)
        s = s.capitalized // 大写首字母
        let result = s[s.startIndex]
        if(String(result).isEnChar()){
            return  String(result)
        }
        return "#"
        
    }
    
    //字符串转日期
    func toDate(formatterStr:String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = formatterStr
        if let resDate = dateFormatter1.date(from: self){
            return resDate
        }
        let dateFormatter2 = ISO8601DateFormatter()
        if let resDate = dateFormatter2.date(from: self) {
            return resDate
        }
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
//        dateFormatter3.locale = Locale(identifier: "en_US_POSIX")
        if let resDate = dateFormatter3.date(from: self){
            return resDate
        }
        return nil
    }
    
    //获取文件后缀名 后缀不带点 返回例:MP3,png
    var pathExtension: String {
            guard let url = URL(string: self) else { return "" }
            return url.pathExtension.isEmpty ? "" : "\(url.pathExtension)"
    }
    
    //[]分割区分emoji
    //字符串根据[]分割 区分表情包
    func splitaEmojiStringWithRegex() -> [String] {
        var result: [String] = []
        let pattern = "\\[[^\\[\\]]*\\]|[^\\[\\]]+"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            
            var previousIndex = self.startIndex
            
            for match in matches {
                let matchRange = Range(match.range, in: self)!
                let substringRange = previousIndex..<matchRange.lowerBound
                
                if substringRange.lowerBound < substringRange.upperBound {
                    let substring = String(self[substringRange])
                    result.append(substring)
                }
                
                let matchString = String(self[matchRange])
                result.append(matchString)
                
                previousIndex = matchRange.upperBound
            }
            
            if previousIndex < self.endIndex {
                let remainingSubstring = String(self[previousIndex...])
                result.append(remainingSubstring)
            }
            
            return result
        } catch {
            print("创建正则表达式时出错: \(error)")
            return []
        }
    }
}
