//
//  JXColorExtension.swift
//  NasiLive2th
//
//  Created by ken Z on 2023/5/8.
//

import UIKit

extension UIColor {
    //可以直接传整数
    convenience init(r:Int,g:Int,b:Int,alpha:CGFloat) {
         self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: alpha)
    }
    
    func image(size:CGSize) -> UIImage?{
 
        // 创建一个矩形，作为图片的尺寸
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        // 开始绘制图形上下文
        UIGraphicsBeginImageContext(rect.size)

        // 获取当前的图形上下文
        let context = UIGraphicsGetCurrentContext()

        // 在图形上下文中填充颜色
        context?.setFillColor(self.cgColor)
        context?.fill(rect)

        // 从当前图形上下文中获取 UIImage
        let image = UIGraphicsGetImageFromCurrentImageContext()

        // 结束图形上下文
        UIGraphicsEndImageContext()
        return image
    }
}
