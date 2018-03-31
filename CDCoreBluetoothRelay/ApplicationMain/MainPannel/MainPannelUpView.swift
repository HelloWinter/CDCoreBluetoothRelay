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
    
    private lazy var imgBrand : UIImageView = {
        let imgView = UIImageView()
        
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var btnSwitch : PannelButton = {
        let btn = PannelButton()
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(sendData(sender:)), for: .touchUpInside)
        btn.setupButton(normalImg: "up_pannel_switch_gray", selectedImg: "up_pannel_switch_white", disableImg: nil, type: .btn_switch)
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
        btn.setupButton(normalImg: "up_pannel_NAV_red", selectedImg: "up_pannel_NAV_white", disableImg: "up_pannel_NAV_gray", type: .btn_NAV)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedData(noti:)), name: NSNotification.Name(rawValue: kReceivedValue), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let rate = ScreenWidth / 320
        let btn_W_H : CGFloat = 35 * rate
        
        let switch_m_x = 78 * rate
        let nav_2_x = 198 * rate
        
        let switch_nav_Y = 52 * rate
        btnSwitch.frame = CGRect(x: switch_m_x, y: switch_nav_Y, width: btn_W_H, height: btn_W_H)
        btnNAV.frame = CGRect(x: nav_2_x, y: switch_nav_Y, width: btn_W_H, height: btn_W_H)
        
        let b_3_y = 80 * rate
        btnB.frame = CGRect(x: 45 * rate, y: b_3_y, width: btn_W_H, height: btn_W_H)
        btn3.frame = CGRect(x: 232 * rate, y: b_3_y, width: btn_W_H, height: btn_W_H)
        
        let m_2_y = 108 * rate
        btnM.frame = CGRect(x: switch_m_x, y: m_2_y, width: btn_W_H, height: btn_W_H)
        btn2.frame = CGRect(x: nav_2_x, y: m_2_y, width: btn_W_H, height: btn_W_H)
        
        let s_1_y = 115 * rate
        btnS.frame = CGRect(x: 119 * rate, y: s_1_y, width: btn_W_H, height: btn_W_H)
        btn1.frame = CGRect(x: 159 * rate, y: s_1_y, width: btn_W_H, height: btn_W_H)
        
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
            print("主面板收到外设数据")
            let arr = extractButtonStatus(byte: data.last!)
            btnSwitch.isSelected = arr[7]
            self.isHighlighted = arr[7]
            
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
        print("点击了\(sender.btnType)")
        let original = "550102" + sender.getStatusCode() + (!sender.isSelected ? "01" : "00")
        let crc8 = calculateCRC8(data: dataFrom(hexString: original))
        let sendHexString = original + String(format: "%x", crc8!)
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
            "这里要修改"
            self.image = UIImage(named: "main_pannel_logo_gray")
            self.highlightedImage = UIImage(named: "main_pannel_logo_white")
        }else{
            
            btn1.setupButton(normalImg: "up_pannel_1_red", selectedImg: "up_pannel_1_white", disableImg: "up_pannel_1_gray", type: .btn_1)
            btn2.setupButton(normalImg: "up_pannel_2_red", selectedImg: "up_pannel_2_white", disableImg: "up_pannel_2_gray", type: .btn_2)
            btn3.setupButton(normalImg: "up_pannel_3_red", selectedImg: "up_pannel_3_white", disableImg: "up_pannel_3_gray", type: .btn_3)
            btnB.setupButton(normalImg: "up_pannel_B_red", selectedImg: "up_pannel_B_white", disableImg: "up_pannel_B_gray", type: .btn_B)
            btnM.setupButton(normalImg: "up_pannel_M_red", selectedImg: "up_pannel_M_white", disableImg: "up_pannel_M_gray", type: .btn_M)
            btnS.setupButton(normalImg: "up_pannel_S_red", selectedImg: "up_pannel_S_white", disableImg: "up_pannel_S_gray", type: .btn_S)
            
            self.image = UIImage(named: "main_pannel_logo_gray")
            self.highlightedImage = UIImage(named: "main_pannel_logo_white")
        }
    }

}
