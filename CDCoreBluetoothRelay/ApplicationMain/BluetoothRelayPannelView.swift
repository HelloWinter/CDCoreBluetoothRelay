//
//  BluetoothRelayPannelView.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/18.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit

class BluetoothRelayPannelView: UIScrollView {

    private weak var bluetoothTool : CDCoreBluetoothTool?
    
    private lazy var mainPannel : MainPannelView = {
        let imageV = MainPannelView(frame: .zero)
        imageV.image = UIImage(named: "main_pannel_background")
        return imageV
    }()
    
    private lazy var configurePannel : ConfigurePannelView = {
        let imageV = ConfigurePannelView(frame: .zero)
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
        bluetoothTool = CDCoreBluetoothTool.shared
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
    
    //TEST
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        bluetoothTool!.writeData()
        let emailView = EmailRSSView(frame: .zero)
        emailView.show()
    }
}
