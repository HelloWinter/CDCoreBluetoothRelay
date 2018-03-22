//
//  ConfigurePannelView.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/18.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit

class ConfigurePannelView: UIImageView {

    private lazy var dragImageView : UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "connect_header")
        return imgV
    }()
    
    private lazy var pannelDownView : UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "main_pannel_down")
        return imgV
    }()
    
    private lazy var pannelPhoneView : UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "connect_phone_disconnected")
        imgV.highlightedImage = UIImage(named: "connect_phone_connected")
        return imgV
    }()
    
    private lazy var btnConnect : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named : "btn_disconnect"), for: .normal)
        button.setImage(UIImage(named : "btn_disconnect"), for: .selected)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        addSubview(dragImageView)
        addSubview(pannelDownView)
        addSubview(pannelPhoneView)
        addSubview(btnConnect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imgWidth = UIScreen.main.bounds.width
        let imgHeight = imgWidth * 190.0 / 717
        dragImageView.frame = CGRect(x: 0, y: 0, width: imgWidth, height: imgHeight)
        let pannelDownWidth = imgWidth-20
        let pannelDownHeight = pannelDownWidth * 1360.0 / 1553
        pannelDownView.frame = CGRect(x: 10, y: UIScreen.main.bounds.height - pannelDownHeight + 40, width: pannelDownWidth, height: pannelDownHeight)
        
        pannelPhoneView.bounds = CGRect(x: 0, y: 0, width: 80, height: 208 * 0.8)//100*208
        pannelPhoneView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5 - 100)
        
        btnConnect.frame = CGRect(x: pannelPhoneView.frame.maxX + 30, y: pannelPhoneView.frame.maxY, width: 48, height: 48)
    }

}
