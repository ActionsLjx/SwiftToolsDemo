//
//  JXCalendarCell.swift
//  SwiftToolsDemo
//
//  Created by ken Z on 2024/9/10.
//

import UIKit
import JTAppleCalendar
class JXCalendarCell: JTACDayCell {

    @IBOutlet weak var selectedView: UIView!

    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
