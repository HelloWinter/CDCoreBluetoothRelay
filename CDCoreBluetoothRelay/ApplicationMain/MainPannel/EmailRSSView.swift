//
//  EmailRSSView.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/21.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit

enum EmailRSSViewType {
    case subscribeEmail
    case customizeBoat
}

class EmailRSSView: UIView {
    
    private(set) var viewType : EmailRSSViewType = .subscribeEmail
    
    private lazy var backgroundMaskView : UIView = {
        let mask = UIView(frame: CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.bounds.width)!, height: (UIApplication.shared.keyWindow?.bounds.height)!))
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        mask.addGestureRecognizer(tap)
        return mask
    }()
    
    private lazy var lbContent : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.black
        
        if viewType == .customizeBoat {
            label.text = "Please tell us the brand of your boat so we can better improve our software feature and provide a more customized experience for you in the future!"
        }else{
            let title = "Enter Email"
            let content = "\(title)\n\nto enable the custom features"
            let mutableAttrStr = NSMutableAttributedString(string: content)
            mutableAttrStr.addAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 25)], range: (content as NSString).range(of: title))
            label.attributedText = mutableAttrStr
        }
        return label
    }()
    
    private lazy var textfield : UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        return tf
    }()
    
    private lazy var btnSend : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 235.0/255, green: 140.0/255, blue: 77.0/255, alpha: 1.0)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(btnSendClick), for: .touchUpInside)
        if viewType == .customizeBoat {
            btn.setTitle("OK", for: .normal)
        }else{
            btn.setTitle("Submit", for: .normal)
        }
        return btn
    }()
    
    private lazy var sendEmailMgr : CDSendEmailManager = {
        let mgr = CDSendEmailManager()
        return mgr
    }()
    
    init(viewType : EmailRSSViewType) {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 183))
        self.viewType = viewType
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 183))
        setupView()
    }
    
    private func setupView(){
        backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        addSubview(lbContent)
        addSubview(textfield)
        addSubview(btnSend)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lbContent.frame = CGRect(x: 10, y: 10, width: self.bounds.width-20, height: 110)
        
        let btnWidth : CGFloat = 80
        let margin : CGFloat = 10
        textfield.frame = CGRect(x: lbContent.frame.minX, y: lbContent.frame.maxY, width: lbContent.frame.width - btnWidth - margin, height: 40)
        btnSend.frame = CGRect(x: textfield.frame.maxX + margin, y: textfield.frame.minY, width: btnWidth, height: textfield.frame.height)
        
        textfield.layer.borderColor = UIColor.black.cgColor
        textfield.layer.borderWidth = 0.5
        textfield.layer.cornerRadius = 5
        textfield.layer.masksToBounds = true
        
        btnSend.layer.cornerRadius = 5
        btnSend.layer.masksToBounds = true
    }
    
    func show() -> Void {
        if let keyWindow = UIApplication.shared.keyWindow {
            if backgroundMaskView.superview == nil {
                keyWindow.addSubview(backgroundMaskView)
            }
            if self.superview == nil {
                keyWindow.addSubview(self)
            }
            self.center = CGPoint(x: keyWindow.bounds.width * 0.5, y: keyWindow.bounds.height * 0.5 - 40)
        }
    }
    
    @objc func hide() -> Void {
        if backgroundMaskView.superview != nil{
            backgroundMaskView.removeFromSuperview()
        }
        if self.superview != nil {
            self.removeFromSuperview()
        }
    }

    @objc private func btnSendClick(){
        if self.viewType == .customizeBoat {
            if let text = textfield.text{
                print("发送邮件 : \(text)")
                sendEmailMgr.sendEmail(recipients: ["info@bazooka.com"], subject: "Customize Boat", messageBody: text)
            }
        }
        if self.viewType == .subscribeEmail {
            if let text = textfield.text {
                if text.isEmail() {
                    print("发送邮件 : \(text)")
                    sendEmailMgr.sendEmail(recipients: ["info@bazooka.com"], subject: "Subscribe Email", messageBody: text)
                }else{
                    CDAutoHideMessageHUD.showMessage(NSLocalizedString("EmailFormatError", comment: ""))
                }
                
            }
        }
    }
    
    @objc private func hideKeyboard(){
        self.endEditing(true)
    }
}
