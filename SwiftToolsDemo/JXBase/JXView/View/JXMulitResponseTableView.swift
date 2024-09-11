//
//  JX.swift
//  NasiLive2th
//
//  Created by ken Z on 2023/6/5.
//
/// 嵌套联动tableview


import UIKit

class JXMulitResponseTableView: UITableView, UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
