//
//  MainPannelUpView.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/24.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

/**
 *  代码待优化
 */


import UIKit



class MainPannelUpView: UIImageView {
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kReceivedValue), object: nil)
    }
    
    private lazy var btnSwitch : PannelButton = {
        let btn = PannelButton(normalImg: "up_pannel_switch_gray", selectedImg: "up_pannel_switch_white", disableImg: nil, type: ButtonType.btn_switch)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btn1 : PannelButton = {
        let btn = PannelButton(normalImg: "up_pannel_1_red", selectedImg: "up_pannel_1_white", disableImg: "up_pannel_1_gray", type: ButtonType.btn_1)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btn2 : PannelButton = {
        let btn = PannelButton(normalImg: "up_pannel_2_red", selectedImg: "up_pannel_2_white", disableImg: "up_pannel_2_gray", type: .btn_2)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btn3 : PannelButton = {
        let btn = PannelButton(normalImg: "up_pannel_3_red", selectedImg: "up_pannel_3_white", disableImg: "up_pannel_3_gray", type: .btn_3)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnB : PannelButton = {
        let btn = PannelButton(normalImg: "up_pannel_B_red", selectedImg: "up_pannel_B_white", disableImg: "up_pannel_B_gray", type: .btn_B)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnM : PannelButton = {
        let btn = PannelButton(normalImg: "up_pannel_M_red", selectedImg: "up_pannel_M_white", disableImg: "up_pannel_M_gray", type: .btn_M)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnS : PannelButton = {
        let btn = PannelButton(normalImg: "up_pannel_S_red", selectedImg: "up_pannel_S_white", disableImg: "up_pannel_S_gray", type: .btn_S)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnNAV : PannelButton = {
        let btn = PannelButton(normalImg: "up_pannel_NAV_red", selectedImg: "up_pannel_NAV_white", disableImg: "up_pannel_NAV_gray", type: .btn_NAV)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        addSubview(btnSwitch)
        addSubview(btn1)
        addSubview(btn2)
        addSubview(btn3)
        addSubview(btnB)
        addSubview(btnM)
        addSubview(btnS)
        addSubview(btnNAV)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedData(noti:)), name: NSNotification.Name(rawValue: kReceivedValue), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let btn_W_H = self.frame.width * 0.25
        for i in 0..<8 {
            let btn = self.subviews[i] as! UIButton
            btn.frame = CGRect(x: CGFloat(i % 4) * btn_W_H, y: btn_W_H * (CGFloat(i) * 0.25), width: btn_W_H, height: btn_W_H)
        }
//        btnSwitch.frame = CGRect(x: 10, y: 0, width: btn_W_H, height: btn_W_H)
//        btnSwitch.frame = CGRect(x: 0, y: 0, width: btn_W_H, height: btn_W_H)
//        btnSwitch.frame = CGRect(x: 0, y: 0, width: btn_W_H, height: btn_W_H)
//        btnSwitch.frame = CGRect(x: 0, y: 0, width: btn_W_H, height: btn_W_H)
    }
    
    @objc private func receivedData(noti : Notification){
        if let data = noti.object as? Data {
            print("主面板收到外设数据")
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
            
//            print(btn1.isEnabled)
        }
    }
    
    @objc private func sendData(sender : PannelButton){
        let original = "550102" + sender.getStatusCode() + (!sender.isSelected ? "01" : "00")
        let crc8 = calculateCRC8(data: dataFrom(hexString: original))
        let sendHexString = original + String(format: "%x", crc8!)
        CDCoreBluetoothTool.shared.sendToPeripheralWith(hexString: sendHexString)
    }

}
