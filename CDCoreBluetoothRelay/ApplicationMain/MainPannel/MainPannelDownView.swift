//
//  MainPannelDownView.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/25.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

/**
 *  代码待优化
 */

import UIKit


class MainPannelDownView: UIImageView {
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kReceivedValue), object: nil)
    }
    
    private lazy var imgBrand : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "yak_power_gray")
        imgView.highlightedImage = UIImage(named: "yak_power_white")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var btn1 : PannelButton = {
        let btn = PannelButton(normalImg: "down_pannel_1_red", selectedImg: "down_pannel_1_white", disableImg: "down_pannel_1_gray", type: .btn_1)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btn2 : PannelButton = {
        let btn = PannelButton(normalImg: "down_pannel_2_red", selectedImg: "down_pannel_2_white", disableImg: "down_pannel_2_gray", type: .btn_2)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btn3 : PannelButton = {
        let btn = PannelButton(normalImg: "down_pannel_3_red", selectedImg: "down_pannel_3_white", disableImg: "down_pannel_3_gray", type: .btn_3)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnB : PannelButton = {
        let btn = PannelButton(normalImg: "down_pannel_B_red", selectedImg: "down_pannel_B_white", disableImg: "down_pannel_B_gray", type: .btn_B)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnM : PannelButton = {
        let btn = PannelButton(normalImg: "down_pannel_M_red", selectedImg: "down_pannel_M_white", disableImg: "down_pannel_M_gray", type: .btn_M)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnS : PannelButton = {
        let btn = PannelButton(normalImg: "down_pannel_S_red", selectedImg: "down_pannel_S_white", disableImg: "down_pannel_S_gray", type: .btn_S)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnNAV : PannelButton = {
        let btn = PannelButton(normalImg: "down_pannel_NAV_red", selectedImg: "down_pannel_NAV_white", disableImg: "down_pannel_NAV_gray", type: .btn_NAV)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnAnchor : PannelButton = {
        let btn = PannelButton(normalImg: "down_pannel_anchor_red", selectedImg: "down_pannel_anchor_white", disableImg: "down_pannel_anchor_gray", type: .btn_switch)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        addSubview(btnNAV)
        addSubview(btnAnchor)
        addSubview(btnB)
        addSubview(btnM)
        addSubview(btnS)
        addSubview(btn1)
        addSubview(btn2)
        addSubview(btn3)
        addSubview(imgBrand)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedData(noti:)), name: NSNotification.Name(rawValue: kReceivedValue), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var h_margin : CGFloat = 5
        if currentScreenType() == .Phone3_5 || currentScreenType() == .Phone4_0 {
            h_margin = 0
        }
        let btn_W_H : CGFloat = (self.frame.width - 20.0 - (h_margin * 7)) * 0.125
        for i in 0..<8 {
            if let btn = self.subviews[i] as? UIButton {
                btn.frame = CGRect(x: 10 + CGFloat(i) * (btn_W_H + h_margin), y: 60, width: btn_W_H, height: btn_W_H)
            }
        }
        let imgBrandHeight = 35 * (ScreenWidth / 320)
        imgBrand.frame = CGRect(x: 10, y: 5, width: self.frame.width - 20.0, height: imgBrandHeight)
    }
    
    @objc private func receivedData(noti : Notification){
        if let data = noti.object as? Data {
            print("副面板收到外设数据")
            let arr = extractButtonStatus(byte: data.last!)
//            btnSwitch.isSelected = arr[7]
            imgBrand.isHighlighted = arr[7]
            btn1.isEnabled = arr[7]
            btnB.isEnabled = arr[7]
            btnM.isEnabled = arr[7]
            btnS.isEnabled = arr[7]
            btn2.isEnabled = arr[7]
            btnNAV.isEnabled = arr[7]
            
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
        let sendHexString = original + String(format: "%x", crc8!)
        CDCoreBluetoothTool.shared.sendToPeripheralWith(hexString: sendHexString)
    }

}
