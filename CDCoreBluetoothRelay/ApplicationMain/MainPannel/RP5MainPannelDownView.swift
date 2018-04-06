//
//  RP5MainPannelDownView.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/4/2.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit

class RP5MainPannelDownView: UIImageView {

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kReceivedRP5Value), object: nil)
    }
    
    private lazy var btnSwitch : PannelButton = {
        let btn = PannelButton()
        btn.setupButton(normalImg: "rp5_btn_switch_gray", selectedImg: "rp5_btn_switch", disableImg: nil, type: .btn_switch,isEnable: true)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btn1 : PannelButton = {
        let btn = PannelButton()
        btn.setupButton(normalImg: "rp5_btn_1_red", selectedImg: "rp5_btn_1", disableImg: "rp5_btn_1_gray", type: .btn_1)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btn2 : PannelButton = {
        let btn = PannelButton()
        btn.setupButton(normalImg: "rp5_btn_2_red", selectedImg: "rp5_btn_2", disableImg: "rp5_btn_2_gray", type: .btn_2)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnB : PannelButton = {
        let btn = PannelButton()
        btn.setupButton(normalImg: "rp5_btn_b_red", selectedImg: "rp5_btn_b", disableImg: "rp5_btn_b_gray", type: .btn_B)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnM : PannelButton = {
        let btn = PannelButton()
        btn.setupButton(normalImg: "rp5_btn_m_red", selectedImg: "rp5_btn_m", disableImg: "rp5_btn_m_gray", type: .btn_M)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnS : PannelButton = {
        let btn = PannelButton()
        btn.setupButton(normalImg: "rp5_btn_s_red", selectedImg: "rp5_btn_s", disableImg: "rp5_btn_s_gray", type: .btn_S)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: "rp5_mainpannel_empty_only")
        isUserInteractionEnabled = true
        addSubview(btnSwitch)
        addSubview(btn1)
        addSubview(btn2)
        addSubview(btnB)
        addSubview(btnM)
        addSubview(btnS)
        NotificationCenter.default.addObserver(self, selector: #selector(receivedData(noti:)), name: NSNotification.Name(rawValue: kReceivedRP5Value), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let rate = ScreenWidth / 320
        let btn_W_H : CGFloat = 55 * rate
        let radius = 65 * rate
        let centerX = frame.width * 0.5
        let centerY = frame.height * 0.5
        
        btnSwitch.bounds = CGRect(x: 0, y: 0, width: btn_W_H, height: btn_W_H)
        btnB.bounds = CGRect(x: 0, y: 0, width: btn_W_H, height: btn_W_H)
        btnM.bounds = CGRect(x: 0, y: 0, width: btn_W_H, height: btn_W_H)
        btn2.bounds = CGRect(x: 0, y: 0, width: btn_W_H, height: btn_W_H)
        btnS.bounds = CGRect(x: 0, y: 0, width: btn_W_H, height: btn_W_H)
        btn1.bounds = CGRect(x: 0, y: 0, width: btn_W_H, height: btn_W_H)
        
        
        btnSwitch.center = CGPoint(x: centerX + sin(CGFloat.pi * 0) * radius, y: centerY - cos(CGFloat.pi * 0) * radius)
        btn2.center = CGPoint(x: centerX + sin(CGFloat.pi * 60 / 180) * radius, y: centerY - cos(CGFloat.pi * 60 / 180) * radius)
        btnS.center = CGPoint(x: centerX + sin(CGFloat.pi * 120 / 180) * radius, y: centerY - cos(CGFloat.pi * 120 / 180) * radius)
        btnM.center = CGPoint(x: centerX + sin(CGFloat.pi) * radius, y: centerY - cos(CGFloat.pi) * radius)
        btnB.center = CGPoint(x: centerX + sin(CGFloat.pi * 240 / 180) * radius, y: centerY - cos(CGFloat.pi * 240 / 180) * radius)
        btn1.center = CGPoint(x: centerX + sin(CGFloat.pi * 300 / 180) * radius, y: centerY - cos(CGFloat.pi * 300 / 180) * radius)
        
    }
    
    @objc private func receivedData(noti : Notification){
        if let data = noti.object as? Data {
            print("主面板收到RP5外设数据")
            let arr = extractButtonStatus(byte: data.last!)
            btnSwitch.isSelected = arr[7]
            
            btn1.isEnabled = arr[7]
            btnB.isEnabled = arr[7]
            btnM.isEnabled = arr[7]
            btnS.isEnabled = arr[7]
            btn2.isEnabled = arr[7]
            
            btn1.isSelected = arr[6]
            btnB.isSelected = arr[5]
            btnM.isSelected = arr[4]
            btnS.isSelected = arr[3]
            btn2.isSelected = arr[2]
        }
    }
    
    @objc private func sendData(sender : PannelButton){
        let original = "550102" + sender.getStatusCode() + (!sender.isSelected ? "01" : "00")
        let crc8 = calculateCRC8(data: dataFrom(hexString: original))
        let sendHexString = original + String(format: "%02X", crc8!)
        print("点击了\(sender.btnType)，发送了数据：\(sendHexString)")
        CDCoreBluetoothTool.shared.sendToPeripheralWith(hexString: sendHexString)
    }

}
