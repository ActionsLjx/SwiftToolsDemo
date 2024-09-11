//
//  JXButtonExtension.swift
//  Goallive
//
//  Created by ken Z on 2023/9/4.
//

import UIKit

/*
枚举 设置 图片的位置
*/
enum JXButtonImagePosition : Int  {
    case imageTop = 0
    case imageLeft
    case imageBottom
    case imageRight
}
extension UIButton {
    
    /**
    type ：image 的位置
    Space ：图片文字之间的间距
    */
func setImagePosition(type:JXButtonImagePosition,Space space:CGFloat)  {
       
        let imageWith :CGFloat = (imageView?.frame.size.width)!
        let imageHeight :CGFloat = (imageView?.frame.size.height)!
      
        var labelWidth :CGFloat = 0.0
        var labelHeight :CGFloat = 0.0

        labelWidth = CGFloat(titleLabel!.intrinsicContentSize.width)
        labelHeight = CGFloat(titleLabel!.intrinsicContentSize.height)

        var  imageEdgeInsets :UIEdgeInsets = UIEdgeInsets()
        var  labelEdgeInsets :UIEdgeInsets = UIEdgeInsets()
       
        switch type {
        case .imageTop:
            imageEdgeInsets = UIEdgeInsets.init(top: -labelHeight - space/2.0, left: 0, bottom: 0, right:  -labelWidth)
            labelEdgeInsets =  UIEdgeInsets.init(top:0, left: -imageWith, bottom: -imageHeight-space/2.0, right: 0)
            break;
        case .imageLeft:
            imageEdgeInsets = UIEdgeInsets.init(top:0, left:-space/2.0, bottom: 0, right:space/2.0)
            labelEdgeInsets =  UIEdgeInsets.init(top:0, left:space/2.0, bottom: 0, right: -space/2.0)
            break;
        case .imageBottom:
            imageEdgeInsets = UIEdgeInsets.init(top:0, left:0, bottom: -labelHeight-space/2.0, right: -labelWidth)
            labelEdgeInsets =  UIEdgeInsets.init(top:-imageHeight-space/2.0, left:-imageWith, bottom: 0, right: 0)
            break;
        case .imageRight:
            imageEdgeInsets = UIEdgeInsets.init(top:0, left:labelWidth+space/2.0, bottom: 0, right: -labelWidth-space/2.0)
            labelEdgeInsets =  UIEdgeInsets.init(top:0, left:-imageWith-space/2.0, bottom: 0, right:imageWith+space/2.0)
            break;
        }
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
  
}

