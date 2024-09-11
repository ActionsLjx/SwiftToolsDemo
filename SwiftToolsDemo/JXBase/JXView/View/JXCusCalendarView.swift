//
//  JXCusCalendarView.swift
//  SwiftToolsDemo
//
//  Created by ken Z on 2024/9/4.
//

import UIKit
import JTAppleCalendar

extension JXCusCalendarView{
    static func show(currendDate:Date = Date(),selectDateHandler:@escaping ((Date)->())){
        let view = JXCusCalendarView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: JXCusCalendarView.height))
        view.calendarView.selectDates([currendDate])
        view.calendarView.scrollToDate(currendDate)
        view.selectDateHandler = selectDateHandler
        JXAppManager.share.showMask(subView: view, subSize: CGSize(width: kScreenWidth, height: JXCusCalendarView.height))
    }
}

// MARK: 日历配置
extension JXCusCalendarView{
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let month = Calendar.current.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        // 0 indexed array
        let year = Calendar.current.component(.year, from: startDate)
        monthTitleLab.text = monthName + " " + String(year)
    }
    
    func handleCellConfiguration(cell: JTACDayCell?, cellState: CellState) {
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
        prePostVisibility?(cellState, cell as? JXCalendarCell)
       
    }
    
    func handleCellTextColor(view: JTACDayCell?, cellState: CellState) {
        guard let myCustomCell = view as? JXCalendarCell  else {
            return
        }
        myCustomCell.dayLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        if cellState.dateBelongsTo == .thisMonth {
            myCustomCell.dayLabel.textColor = UIColor(hexString: "#040C20")!
        } else {
            myCustomCell.dayLabel.textColor = UIColor(hexString: "#9098AB")!
        }
        if cellState.isSelected {
            myCustomCell.dayLabel.textColor = .white
        }
        myCustomCell.isHidden = cellState.dateBelongsTo != .thisMonth
        
    }
    
    func handleCellSelection(view: JTACDayCell?, cellState: CellState) {
        guard let myCustomCell = view as? JXCalendarCell else {return }
        if cellState.isSelected {
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }
}

// MARK: 代理方法:JTACMonthViewDataSource,JTACMonthViewDelegate
extension JXCusCalendarView: JTACMonthViewDataSource, JTACMonthViewDelegate {
   
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        
        let startDate = formatter.date(from: "2000 01 01")!
        let endDate = formatter.date(from: "2099 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: testCalendar,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .sunday,
                                                 hasStrictBoundaries: true)

        return parameters
    }
    
    func configureVisibleCell(myCustomCell: JXCalendarCell, cellState: CellState, date: Date, indexPath: IndexPath) {
        myCustomCell.dayLabel.text = cellState.text
        handleCellConfiguration(cell: myCustomCell, cellState: cellState)
        myCustomCell.dayLabel.text = "\(cellState.text)"
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // This function should have the same code as the cellForItemAt function
        let myCustomCell = cell as! JXCalendarCell
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date, indexPath: indexPath)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "JXCalendarCell", for: indexPath) as! JXCalendarCell
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date, indexPath: indexPath)
        return myCustomCell
    }

    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleCellConfiguration(cell: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
//        print("After: \(calendar.contentOffset.y)")

    }
    
    func calendar(_ calendar: JTACMonthView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
}

class JXCusCalendarView: UIView {
    static let height:CGFloat = 405
    
    private var selectDateHandler:((Date)->())?
    private let formatter = DateFormatter()
    private var testCalendar = Calendar.current
    private var prePostVisibility: ((CellState, JXCalendarCell?)->())?
    private var calendarView: JTACMonthView!
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var monthTitleLab: UILabel!
    @IBOutlet private weak var stackDayNameStack: UIStackView!
    
    @IBOutlet weak var leftArrorBtn: UIButton!
    @IBOutlet weak var rightArrorBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialFromXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialFromXib()
    }
    
    private func initialFromXib() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle.main)
        contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        contentView.frame = bounds
        addSubview(contentView)
        
        self.calendarView = JTACMonthView.init(frame: CGRect.init(x: 0, y: 200, width: kScreenWidth, height: 290))
        self.calendarView.register(UINib(nibName: "JXCalendarCell", bundle: nil), forCellWithReuseIdentifier: "JXCalendarCell")
        self.calendarView.scrollDirection = .horizontal
//        self.calendarView.isPagingEnabled = true
        self.calendarView.scrollingMode = .stopAtEachCalendarFrame
        self.calendarView.showsHorizontalScrollIndicator = false
        self.calendarView.calendarDelegate = self
        self.calendarView.calendarDataSource = self
        self.calendarView.minimumLineSpacing = 0
        self.calendarView.minimumInteritemSpacing = 0
        self.calendarView.scrollToDate(Date())
        self.calendarView.selectDates([Date()])
        self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        self.addSubview(self.calendarView)
        self.calendarView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(14)
            make.right.equalTo(self).offset(-14)
            make.top.equalTo(self.stackDayNameStack.snp.bottom)
            make.bottom.equalTo(self.closeBtn.snp.top).offset(-10)
        }
        
        prePostVisibility = {state, cell in
            if state.dateBelongsTo == .thisMonth {
                cell?.isHidden = false
            } else {
                cell?.isHidden = false
            }
        }
        calendarView.reloadData()
        
        self.leftArrorBtn.addTarget(self, action: #selector(leftArrorClick), for: .touchUpInside)
        self.rightArrorBtn.addTarget(self, action: #selector(rightArrorClick), for: .touchUpInside)
        self.closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
    }
    
    @objc private func leftArrorClick(){
        self.calendarView.scrollToSegment(.previous)
    }

    @objc private func rightArrorClick(){
        self.calendarView.scrollToSegment(.next)
    }
    
    @objc private func closeBtnClick(){
        JXAppManager.share.hidMask(subView: self)
    }
}
