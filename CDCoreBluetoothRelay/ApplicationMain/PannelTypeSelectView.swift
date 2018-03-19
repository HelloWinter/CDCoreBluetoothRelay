//
//  PannelTypeSelectView.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/19.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit

class PannelTypeSelectView: UIView {
    
    var showOrHideViewClosure : ((Bool) -> Void)?

    private lazy var lbPannelType : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 120.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        label.textColor = UIColor.white
        label.text = "Customize it"
        return label
    }()
    
    private lazy var btnSelectPannelType : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 110.0/255.0, green: 110.0/255.0, blue: 110.0/255.0, alpha: 1.0)
        btn.setImage(UIImage(named: ""), for: .normal)
        btn.setImage(UIImage(named: ""), for: .selected)
        btn.addTarget(self, action: #selector(selectButtonClick(_:)), for: .touchUpInside)
        btn.setTitle("下拉", for: .normal)//TEST
        btn.setTitle("上拉", for: .selected)//TEST
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lbPannelType)
        addSubview(btnSelectPannelType)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let btnWidth : CGFloat = 45
        lbPannelType.frame = CGRect(x: 0, y: 0, width: self.frame.width - btnWidth, height: self.frame.height)
        btnSelectPannelType.frame = CGRect(x: lbPannelType.frame.maxX, y: 0, width: btnWidth, height: self.frame.height)
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
    
    @objc private func selectButtonClick(_ sender : UIButton){
        sender.isSelected = !sender.isSelected
        if let closure = self.showOrHideViewClosure {
            closure(sender.isSelected)
        }
    }
}
