//
//  ConfigurePannelView.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/18.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit
import CoreBluetooth

class ConfigurePannelView: UIImageView {
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kPeripheralConnectStateChanged), object: nil)
    }

    private lazy var dragImageView : UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "connect_header")
        return imgV
    }()
    
    private lazy var pannelDownView : MainPannelDownView = {
        let imgV = MainPannelDownView(frame: .zero)
        imgV.image = UIImage(named: "main_pannel_down_blank")
        return imgV
    }()
    
    private lazy var pannelPhoneView : UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "connect_phone_disconnected")
        imgV.highlightedImage = UIImage(named: "connect_phone_blue")
        return imgV
    }()
    
    private lazy var btnConnect : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named : "btn_disconnect"), for: .normal)
        button.setImage(UIImage(named : "btn_connect_blue"), for: .selected)
        button.addTarget(self, action: #selector(btnConnectClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var popView : BluetoothPeripheralPopTableView = {
        let popView = BluetoothPeripheralPopTableView(frame: .zero)
        popView.selectCousure = {[weak self] (peripheral : CBPeripheral) in
            CDCoreBluetoothTool.shared.connectTo(peripheral: peripheral)
        }
        return popView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        image = UIImage(named: "configure_pannel_background")
        addSubview(dragImageView)
        addSubview(pannelDownView)
        addSubview(pannelPhoneView)
        addSubview(btnConnect)
        NotificationCenter.default.addObserver(self, selector: #selector(peripheralConnectStateChanged), name: NSNotification.Name(rawValue: kPeripheralConnectStateChanged), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imgWidth = ScreenWidth
        let imgHeight = imgWidth * 190.0 / 717
        dragImageView.frame = CGRect(x: 0, y: 0, width: imgWidth, height: imgHeight)
        let pannelDownWidth = imgWidth-20
        let pannelDownHeight = pannelDownWidth * 1360.0 / 1553
        pannelDownView.frame = CGRect(x: 10, y: ScreenHeight - pannelDownHeight + 40, width: pannelDownWidth, height: pannelDownHeight)
        pannelPhoneView.bounds = CGRect(x: 0, y: 0, width: 80, height: 208 * 0.8)//100*208
        pannelPhoneView.center = CGPoint(x: ScreenWidth * 0.5, y: ScreenHeight * 0.5 - 100)
        btnConnect.frame = CGRect(x: pannelPhoneView.frame.maxX + 30, y: pannelPhoneView.frame.maxY, width: 48, height: 48)
    }
    
    @objc private func btnConnectClick() {
//        if CDCoreBluetoothTool.shared.peripheralConnectState {
//
//        }else{
            popView.arrCellData = CDCoreBluetoothTool.shared.arrPeri
            popView.show()
//        }
    }
    
    @objc private func peripheralConnectStateChanged(noti : Notification) {
        if let state = noti.object as? Bool {
            if state {
                pannelPhoneView.isHighlighted = true
                btnConnect.isSelected = true
            }else{
                pannelPhoneView.isHighlighted = false
                btnConnect.isSelected = false
            }
        }
    }
    
    func setupBrandButton(isCustom : Bool) -> Void {
        pannelDownView.setupBrandButton(isCustom: isCustom)
    }
}
