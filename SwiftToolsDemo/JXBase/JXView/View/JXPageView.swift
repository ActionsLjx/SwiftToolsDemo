//
//  JXPageView.swift
//  SwiftToolsDemo
//
//  Created by ken Z on 2024/9/11.
//
import UIKit
import JXSegmentedView
class JXPageView: UIView,JXSegmentedListContainerViewListDelegate {
    // MARK: 公共参数
    //嵌套scrollview滑动方法 使用属性
    /// 子view
    var childCanScroll = false
    var superCanScrollBlock: ((Bool) -> Void)?
    
    // MARK: 外部公共方法
    func tapToReload(){}
    
    // MARK: 代理方法 JXSegmentedListContainerViewListDelegate
    func listView() -> UIView {
        return self
    }

}
