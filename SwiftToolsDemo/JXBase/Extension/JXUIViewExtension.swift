//
//  JXUIViewExtension.swift
//  Goallive
//
//  Created by ken Z on 2023/9/6.
//

import UIKit

extension UIView {
    
    //设置单独圆角 传数组 []
    func setCorner(size:CGFloat,roundingCorners:UIRectCorner,bounds:CGRect? = nil) {
        var newBounds = bounds ?? self.bounds
        let filePath : UIBezierPath = UIBezierPath.init(roundedRect: newBounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize.init(width: size, height: size))
        let fieldLayer : CAShapeLayer = CAShapeLayer.init()
        fieldLayer.frame = newBounds
        fieldLayer.path = filePath.cgPath
        self.layer.mask = fieldLayer
    }
    
    //设置渐变色
    func setGradientBackground(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint,cornerRadius:CGFloat) {
        if let existingGradientLayer = layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
                    existingGradientLayer.removeFromSuperlayer()
            }
        // 创建 CAGradientLayer 对象
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        // 设置渐变色的起始点和终点
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = [0,1]
        // 将颜色数组赋给渐变图层
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.cornerRadius = cornerRadius
        // 将渐变图层添加到视图的图层中
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    //单个圆角+渐变色
    func setGradientBackground(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint,cornerRadius:CGFloat,roundingCorners:UIRectCorner,bounds:CGRect? = nil) {
        var newBounds = bounds ?? self.bounds
        if let existingGradientLayer = layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
                    existingGradientLayer.removeFromSuperlayer()
            }
        // 创建 CAGradientLayer 对象
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = newBounds
        
        // 设置渐变色的起始点和终点
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        // 将颜色数组赋给渐变图层
        gradientLayer.colors = colors.map { $0.cgColor }
//        gradientLayer.cornerRadius = cornerRadius
        // 将渐变图层添加到视图的图层中
//        layer.insertSublayer(gradientLayer, at: 0)
        
        //------
        let filePath : UIBezierPath = UIBezierPath.init(roundedRect: newBounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize.init(width: cornerRadius, height: cornerRadius))
        let fieldLayer : CAShapeLayer = CAShapeLayer.init()
        fieldLayer.frame = newBounds
        fieldLayer.path = filePath.cgPath
        self.layer.mask = fieldLayer
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
