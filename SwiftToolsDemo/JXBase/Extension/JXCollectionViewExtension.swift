//
//  JXCollectionViewExtension.swift
//  Goallive
//
//  Created by ken Z on 2023/11/1.
//

import Foundation
import UIKit

extension UICollectionView{
    func getNoDataView(imgName:String = "common_nodata",title:String = "暂无数据",height:CGFloat = 0, top:CGFloat = 100) -> UIView{
        let height = height > 200 ? height : self.frame.height
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height:height))
        let noImg = UIImageView.init(frame: CGRect.init(x: self.frame.width/2 - 75.5, y: top, width: 151, height: 151))
        noImg.image = UIImage(named: imgName)
        let lab = UILabel.init(frame: CGRect.init(x: 0, y: top + 151 + 10, width: self.frame.width, height: 20))
        lab.text = title
        lab.textAlignment = .center
        lab.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lab.textColor = kColor_textBlack
        view.addSubview(noImg)
        view.addSubview(lab)
        view.backgroundColor = UIColor.clear
        view.tag = kTag_NoDataView
        return view
    }
    
    func showNoMoreData(imgName:String = "common_nodata",title:String = "暂无数据",height:CGFloat = 0,top:CGFloat = 100){
        let view = getNoDataView(imgName: imgName,title: title,height: height,top: top)
        self.addSubview(view)
    }
    
    func hideNoData(){
        for view in self.subviews {
            if(view.tag == kTag_NoDataView ){
                view.removeFromSuperview()
            }
        }
    }
}
