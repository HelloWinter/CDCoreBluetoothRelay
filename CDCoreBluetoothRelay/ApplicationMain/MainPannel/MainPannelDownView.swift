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
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kReceivedRP8Value), object: nil)
    }
    
    private lazy var imgBrand : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "yak_power_gray")
        imgView.highlightedImage = UIImage(named: "yak_power_white")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var btn1 : PannelButton = {
        let btn = PannelButton()
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btn2 : PannelButton = {
        let btn = PannelButton()
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btn3 : PannelButton = {
        let btn = PannelButton()
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnB : PannelButton = {
        let btn = PannelButton()
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnM : PannelButton = {
        let btn = PannelButton()
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnS : PannelButton = {
        let btn = PannelButton()
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnNAV : PannelButton = {
        let btn = PannelButton()
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        btn.setupButton(normalImg: "down_pannel_NAV_red", selectedImg: "down_pannel_NAV_white", disableImg: "down_pannel_NAV_gray", type: .btn_NAV)
        return btn
    }()
    
    private lazy var btnAnchor : PannelButton = {
        let btn = PannelButton()
        btn.setupButton(normalImg: "down_pannel_anchor_red", selectedImg: "down_pannel_anchor_white", disableImg: "down_pannel_anchor_gray", type: .btn_anchor)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedData(noti:)), name: NSNotification.Name(rawValue: kReceivedRP8Value), object: nil)
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
        let imgBrandHeight = 30 * (ScreenWidth / 320)
        imgBrand.frame = CGRect(x: 10, y: 10, width: self.frame.width - 20.0, height: imgBrandHeight)
    }
    
    @objc private func receivedData(noti : Notification){
        if let data = noti.object as? Data {
            print("副面板收到RP8外设数据")
            let arrData0 = extractButtonStatus(byte: data.last!)

            imgBrand.isHighlighted = arrData0[7]
            btn1.isEnabled = arrData0[7]
            btnB.isEnabled = arrData0[7]
            btnM.isEnabled = arrData0[7]
            btnS.isEnabled = arrData0[7]
            btn2.isEnabled = arrData0[7]
            btn3.isEnabled = arrData0[7]
            btnNAV.isEnabled = arrData0[7]
            btnAnchor.isEnabled = arrData0[7]

            btn1.isSelected = arrData0[6]
            btnB.isSelected = arrData0[5]
            btnM.isSelected = arrData0[4]
            btnS.isSelected = arrData0[3]
            btn2.isSelected = arrData0[2]
            btn3.isSelected = arrData0[1]
            btnNAV.isSelected = arrData0[0]
            
            let arrData1 = extractButtonStatus(byte: data[data.count - 2])
            btnAnchor.isSelected = arrData1[7]
            //            arrData0[0]//继电器nav
            //            arrData1[7]//anchor
            
        }
    }
    
    @objc private func sendData(sender : PannelButton){
        let original = "55AA0313" + sender.getStatusCode()
        let crc8 = calculateCRC8(data: dataFrom(hexString: original))
        let sendHexString = original + String(format: "%02X", crc8!)
        print("RP8点击了\(sender.btnType)，发送了数据：\(sendHexString)")
        CDCoreBluetoothTool.shared.sendToPeripheralWith(hexString: sendHexString)
    }
    
    func setupBrandButton(isCustom : Bool) -> Void {
        if isCustom {
            btn1.setupButton(normalImg: "down_pannel_ACC2_red", selectedImg: "down_pannel_ACC2_white", disableImg: "down_pannel_ACC2_gray", type: .btn_1)
            btn2.setupButton(normalImg: "down_pannel_EXT_red", selectedImg: "down_pannel_EXT_white", disableImg: "down_pannel_EXT_gray", type: .btn_2)
            btn3.setupButton(normalImg: "down_pannel_LIVE_red", selectedImg: "down_pannel_LIVE_white", disableImg: "down_pannel_LIVE_gray", type: .btn_3)
            btnB.setupButton(normalImg: "down_pannel_BLG_red", selectedImg: "down_pannel_BLG_white", disableImg: "down_pannel_BLG_gray", type: .btn_B)
            btnM.setupButton(normalImg: "down_pannel_INT_red", selectedImg: "down_pannel_INT_white", disableImg: "down_pannel_INT_gray", type: .btn_M)
            btnS.setupButton(normalImg: "down_pannel_ACC1_red", selectedImg: "down_pannel_ACC1_white", disableImg: "down_pannel_ACC1_gray", type: .btn_S)
        }else{
            btn1.setupButton(normalImg: "down_pannel_1_red", selectedImg: "down_pannel_1_white", disableImg: "down_pannel_1_gray", type: .btn_1)
            btn2.setupButton(normalImg: "down_pannel_2_red", selectedImg: "down_pannel_2_white", disableImg: "down_pannel_2_gray", type: .btn_2)
            btn3.setupButton(normalImg: "down_pannel_3_red", selectedImg: "down_pannel_3_white", disableImg: "down_pannel_3_gray", type: .btn_3)
            btnB.setupButton(normalImg: "down_pannel_B_red", selectedImg: "down_pannel_B_white", disableImg: "down_pannel_B_gray", type: .btn_B)
            btnM.setupButton(normalImg: "down_pannel_M_red", selectedImg: "down_pannel_M_white", disableImg: "down_pannel_M_gray", type: .btn_M)
            btnS.setupButton(normalImg: "down_pannel_S_red", selectedImg: "down_pannel_S_white", disableImg: "down_pannel_S_gray", type: .btn_S)
        }
    }

}
