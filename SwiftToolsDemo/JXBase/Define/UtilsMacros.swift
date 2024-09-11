//
//  UtilsMacros.swift
//  NasiLive2th
//
//  Created by ken Z on 2023/5/8.
//

import Foundation
import UIKit

typealias kCompleteHandler = (()->())

// MARK: Path
let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

// MARK: Screen
let kScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let kScreenHeight: CGFloat = UIScreen.main.bounds.size.height
let kScreenSize: CGSize = UIScreen.main.bounds.size
let KStatusbarHeight = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.statusBarManager?.statusBarFrame.height ?? 20
let kSafeAreaBottomHeight = kGetSafeBottomHeight()
let kTabbarHieght = kGetTabbarHeight()
let kCurrentWindow = UIApplication.shared.currentWindow
let kNavigationBarheight:CGFloat = 44
let kTopViewSize:CGSize = CGSize.init(width: 306, height: 522)
let kCurrentSystemVersion: Double = NSString(string: UIDevice.current.systemVersion).doubleValue
let kSysName = UIDevice.current.systemVersion

let kPlaceholder = UIImage(named: "home_min_placeholder")!
let kAvatar = UIImage(named: "common_avatar_default")!

// MARK: VIEW_TAG
let kTag_NoDataView = 10001
let kTag_CenterSendView = 10002
let kTag_videoDefaultPlay = 10003


// MARK: 单张图片的几种大小 
let ImgCellSize_Square = CGSize(width: 193, height: 193)
let ImgCellSize_Vertical = CGSize(width: 117, height: 207)
let ImgCellSize_Horizontal = CGSize(width: kScreenWidth - 28, height: 170)
