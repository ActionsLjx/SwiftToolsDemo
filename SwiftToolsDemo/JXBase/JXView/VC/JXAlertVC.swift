//
//  JXAlertVC.swift
//  fpb-worker
//
//  Created by ken Z on 2024/3/25.
//

import UIKit

class JXAlertVC: UIViewController {

    var confirmBlock:(()->())?
    var cancelBlock:(()->())?
    
    private var alerTitle:NSAttributedString = "提醒".setJXAttribute(color: UIColor.black, font: UIFont.systemFont(ofSize: 16,weight: .medium))
    private var des:NSAttributedString?
    private var confirmTitle:String = "确定"
    private var cancelTitle:String = "取消"
    
    @IBOutlet private weak var titleLab: UILabel!
    
    @IBOutlet private weak var desLab: UILabel!
    
    @IBOutlet private weak var cancelBtn: UIButton!
    
    @IBOutlet private weak var confirmBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLab.attributedText = alerTitle
        self.desLab.attributedText = des
        self.cancelBtn.setTitle(cancelTitle, for: .normal)
        self.confirmBtn.setTitle(confirmTitle, for: .normal)
        self.desLab.isEnabled = des == nil
        // Do any additional setup after loading the view.
    }

    @IBAction func confirmBtnClick(_ sender: Any) {
        self.confirmBlock?()
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelBtnClick(_ sender: Any) {
        self.cancelBlock?()
        self.dismiss(animated: true)
    }
    
    init(title: String,des:String? = nil,confirmTitle:String = "确定",cancelTitle:String = "取消") {
        self.alerTitle = title.setJXAttribute(color: UIColor.black, font: UIFont.systemFont(ofSize: 16,weight: .medium))
        self.des = des?.setJXAttribute(color: UIColor.black, font: UIFont.systemFont(ofSize: 14,weight: .regular))
        self.confirmTitle = confirmTitle
        self.cancelTitle = cancelTitle
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
       
    
    init(title: NSAttributedString,des:NSAttributedString? = nil,confirmTitle:String = "确定",cancelTitle:String = "取消") {
        self.alerTitle = title
        self.des = des
        self.confirmTitle = confirmTitle
        self.cancelTitle = cancelTitle
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
