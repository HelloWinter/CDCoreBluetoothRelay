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
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kReceivedRP8Value), object: nil)
    }
    
    private lazy var imgBrand : UIImageView = {
        let imgView = UIImageView()
        
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var btnSwitch : PannelButton = {
        let btn = PannelButton()
        btn.setupButton(normalImg: "up_pannel_switch_gray", selectedImg: "up_pannel_switch_white", disableImg: nil, type: .btn_switch,isEnable: true)
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        return btn
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
        btn.setupButton(normalImg: "up_pannel_NAV_red", selectedImg: "up_pannel_NAV_white", disableImg: "up_pannel_NAV_gray", type: .btn_NAV_control)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: "main_pannel_logo_gray")
        self.highlightedImage = UIImage(named: "main_pannel_logo_white")
        
        isUserInteractionEnabled = true
        addSubview(imgBrand)
        addSubview(btnSwitch)
        addSubview(btn1)
        addSubview(btn2)
        addSubview(btn3)
        addSubview(btnB)
        addSubview(btnM)
        addSubview(btnS)
        addSubview(btnNAV)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedData(noti:)), name: NSNotification.Name(rawValue: kReceivedRP8Value), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let rate = ScreenWidth / 320
        let btn_W_H : CGFloat = 35 * rate
        
        let switch_m_x = 82 * rate
        let nav_2_x = 202 * rate
        
        let switch_nav_Y = 47 * rate
        btnSwitch.frame = CGRect(x: switch_m_x, y: switch_nav_Y, width: btn_W_H, height: btn_W_H)
        btnNAV.frame = CGRect(x: nav_2_x, y: switch_nav_Y, width: btn_W_H, height: btn_W_H)
        
        let b_3_y = 75 * rate
        btnB.frame = CGRect(x: 49 * rate, y: b_3_y, width: btn_W_H, height: btn_W_H)
        btn3.frame = CGRect(x: 236 * rate, y: b_3_y, width: btn_W_H, height: btn_W_H)
        
        let m_2_y = 103 * rate
        btnM.frame = CGRect(x: switch_m_x, y: m_2_y, width: btn_W_H, height: btn_W_H)
        btn2.frame = CGRect(x: nav_2_x, y: m_2_y, width: btn_W_H, height: btn_W_H)
        
        let s_1_y = 110 * rate
        btnS.frame = CGRect(x: 123 * rate, y: s_1_y, width: btn_W_H, height: btn_W_H)
        btn1.frame = CGRect(x: 163 * rate, y: s_1_y, width: btn_W_H, height: btn_W_H)
        
        let imgBrandWidth = btnNAV.center.x - btnSwitch.center.x - btn_W_H
        let imgBrandHeight = btnM.center.y - btnSwitch.center.y - btn_W_H * 0.5
        imgBrand.bounds = CGRect(x: 0, y: 0, width: imgBrandWidth, height: imgBrandHeight)

        let imgBrandCenterX = (btnNAV.center.x - btnSwitch.center.x) * 0.5 + btnSwitch.center.x
        let imgBrandCenterY = btnSwitch.center.y - 10
        imgBrand.center = CGPoint(x:imgBrandCenterX, y:imgBrandCenterY)
//        imgBrand.layer.borderColor = UIColor.red.cgColor
//        imgBrand.layer.borderWidth = 0.5
    }
    
    @objc private func receivedData(noti : Notification){
        if let data = noti.object as? Data {
            print("主面板收到RP8外设数据")
            let arrData0 = extractButtonStatus(byte: data.last!)
            btnSwitch.isSelected = arrData0[7]
            self.isHighlighted = arrData0[7]
            
            btn1.isEnabled = arrData0[7]
            btnB.isEnabled = arrData0[7]
            btnM.isEnabled = arrData0[7]
            btnS.isEnabled = arrData0[7]
            btn2.isEnabled = arrData0[7]
            btn3.isEnabled = arrData0[7]
            btnNAV.isEnabled = arrData0[7]
            
            btn1.isSelected = arrData0[6]
            btnB.isSelected = arrData0[5]
            btnM.isSelected = arrData0[4]
            btnS.isSelected = arrData0[3]
            btn2.isSelected = arrData0[2]
            btn3.isSelected = arrData0[1]
            
            //            arrData0[0]//继电器nav
            //            arrData1[7]//anchor
            let arrData1 = extractButtonStatus(byte: data[data.count - 2])
            if arrData0[0] == false && arrData1[7] == false {
                btnNAV.isSelected = false
                btnNAV.setImage(UIImage(named: "up_pannel_NAV_green"), for: .normal)
            }
            if arrData0[0] == true && arrData1[7] == false {
                btnNAV.isSelected = false
                btnNAV.setImage(UIImage(named: "up_pannel_NAV_red"), for: .normal)
            }
            if arrData0[0] == true && arrData1[7] == true {
                btnNAV.isSelected = true
            }
        }
    }
    
    @objc private func sendData(sender : PannelButton){
//        let original = "55AA0313" + sender.getStatusCode()
        let original = "55AA03120011"
        let crc8 = calculateCRC8(data: dataFrom(hexString: original))
        let sendHexString = original + String(format: "%02X", crc8!)
        print("RP8点击了\(sender.btnType)，发送了数据：\(sendHexString)")
        CDCoreBluetoothTool.shared.sendToPeripheralWith(hexString: sendHexString)
    }
    
    func setupBrandImage(_ brandImage : String?) {
        if let imgStr = brandImage,let img = UIImage(named: "brand_\(imgStr)") {
            imgBrand.image = img
            setupBrandButton(isCustom: true)
        }else{
            imgBrand.image = nil
            setupBrandButton(isCustom: false)
        }
    }
    
    private func setupBrandButton(isCustom : Bool) -> Void {
        if isCustom {
            btn1.setupButton(normalImg: "up_pannel_ACC2_red", selectedImg: "up_pannel_ACC2_white", disableImg: "up_pannel_ACC2_gray", type: .btn_1)
            btn2.setupButton(normalImg: "up_pannel_EXT_red", selectedImg: "up_pannel_EXT_white", disableImg: "up_pannel_EXT_gray", type: .btn_2)
            btn3.setupButton(normalImg: "up_pannel_LIVE_red", selectedImg: "up_pannel_LIVE_white", disableImg: "up_pannel_LIVE_gray", type: .btn_3)
            btnB.setupButton(normalImg: "up_pannel_BLG_red", selectedImg: "up_pannel_BLG_white", disableImg: "up_pannel_BLG_gray", type: .btn_B)
            btnM.setupButton(normalImg: "up_pannel_INT_red", selectedImg: "up_pannel_INT_white", disableImg: "up_pannel_INT_gray", type: .btn_M)
            btnS.setupButton(normalImg: "up_pannel_ACC1_red", selectedImg: "up_pannel_ACC1_white", disableImg: "up_pannel_ACC1_gray", type: .btn_S)
            self.image = UIImage(named: "main_pannel_logo_gray")
            self.highlightedImage = UIImage(named: "main_pannel_logo_white")
        }else{
            
            btn1.setupButton(normalImg: "up_pannel_1_red", selectedImg: "up_pannel_1_white", disableImg: "up_pannel_1_gray", type: .btn_1)
            btn2.setupButton(normalImg: "up_pannel_2_red", selectedImg: "up_pannel_2_white", disableImg: "up_pannel_2_gray", type: .btn_2)
            btn3.setupButton(normalImg: "up_pannel_3_red", selectedImg: "up_pannel_3_white", disableImg: "up_pannel_3_gray", type: .btn_3)
            btnB.setupButton(normalImg: "up_pannel_B_red", selectedImg: "up_pannel_B_white", disableImg: "up_pannel_B_gray", type: .btn_B)
            btnM.setupButton(normalImg: "up_pannel_M_red", selectedImg: "up_pannel_M_white", disableImg: "up_pannel_M_gray", type: .btn_M)
            btnS.setupButton(normalImg: "up_pannel_S_red", selectedImg: "up_pannel_S_white", disableImg: "up_pannel_S_gray", type: .btn_S)
            
            self.image = UIImage(named: "main_pannel_gray")
            self.highlightedImage = UIImage(named: "main_pannel_white")
        }
    }

}
