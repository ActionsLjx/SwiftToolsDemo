//
//  JXUITabBar+Extenstion.swift
//  Goallive
//
//  Created by ken Z on 2023/12/29.
//
import Foundation
import UIKit
extension UITabBar {

    func showBadge(at index: Int, count: Int? = nil) {
        removeBadge(at: index)
        if(count == 0){
            removeBadge(at: index)
            return
        }
        let badgeView = createBadgeView(count: count)
        badgeView.tag = 100 + index
        positionBadge(badgeView, at: index)
        addSubview(badgeView)
    }

    func removeBadge(at index: Int) {
        subviews.forEach {
            if $0.tag == 100 + index {
                $0.removeFromSuperview()
            }
        }
    }

    private func createBadgeView(count: Int?) -> UIView {
        let badgeView = UIView()
        badgeView.tag = 100 + (subviews.count - 1)
        badgeView.layer.cornerRadius = 9
        badgeView.backgroundColor = SFColor(hexString: "EF4444")
        badgeView.clipsToBounds = true
        let label = UILabel()
        label.tag = 101 + (subviews.count - 1)
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        label.textAlignment = .center
        label.text = count?.description ?? ""
        label.sizeToFit()
        badgeView.frame = CGRect(x: 0, y: 0, width: 17, height: 17)
        label.center = badgeView.center
        badgeView.addSubview(label)
        return badgeView
    }

    private func positionBadge(_ badgeView: UIView, at index: Int) {
        guard let tabBarItemCount = items?.count else { return }
        let itemWidth = self.frame.width / CGFloat(tabBarItemCount)
        let x = itemWidth * CGFloat(index + 1) - (itemWidth / 2) + 10.0
        let y = 2.0
        badgeView.frame.origin = CGPoint(x: x - 5.0, y: y)
    }
    
}
