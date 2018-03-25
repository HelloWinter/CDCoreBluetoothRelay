//
//  BluetoothRelayPannelView.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/18.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit

class BluetoothRelayPannelView: UIScrollView {
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kPeripheralConnectStateChanged), object: nil)
    }

    private weak var bluetoothTool : CDCoreBluetoothTool?
    
    private lazy var mainPannel : MainPannelView = {
        let imageV = MainPannelView(frame: .zero)
        imageV.image = UIImage(named: "main_pannel_background")
        return imageV
    }()
    
    private lazy var configurePannel : ConfigurePannelView = {
        let imageV = ConfigurePannelView(frame: .zero)
        imageV.image = UIImage(named: "configure_pannel_background")
        return imageV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isPagingEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bounces = false
        addSubview(mainPannel)
        addSubview(configurePannel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(peripheralConnectStateChanged), name: NSNotification.Name(rawValue: kPeripheralConnectStateChanged), object: nil)
        
        bluetoothTool = CDCoreBluetoothTool.shared
        bluetoothTool!.discoverPeripheralUnconnectClosure = {[weak self] in
            self?.switchPannel(state: false)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let panelWidth = UIScreen.main.bounds.width
        let panelHeight = UIScreen.main.bounds.height
        mainPannel.frame = CGRect(x: 0, y: 0, width: panelWidth, height: panelHeight)
        configurePannel.frame = CGRect(x: 0, y: mainPannel.frame.maxY, width: panelWidth, height: panelHeight)
        self.contentSize = CGSize(width: panelWidth, height: panelHeight * 2)
    }
    
    @objc private func peripheralConnectStateChanged(noti : Notification) {
        if let state = noti.object as? Bool {
            switchPannel(state: state)
        }
    }
    
    @objc private func switchPannel(state : Bool){
        if state {
            if self.contentOffset.y != 0 {
                self.scrollRectToVisible(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), animated: true)
            }
        }else{
            if self.contentOffset.y == 0 {
                self.scrollRectToVisible(CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), animated: true)
            }
        }
    }
}
