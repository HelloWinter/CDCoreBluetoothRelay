//
//  RP5MainPannelView.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/4/2.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit

class RP5MainPannelView: UIImageView {

    private lazy var dragImageView : UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "rp5_mainpannel_footer")
        return imgV
    }()
    
    private lazy var pannelUpView : UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "rp5_mainpannel_logo")
        return imgV
    }()
    
    private lazy var pannelDownView : RP5MainPannelDownView = {
        let imgV = RP5MainPannelDownView(frame: .zero)
        
        return imgV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        image = UIImage(named: "rp5_mainpannel_background")
        addSubview(pannelUpView)
        addSubview(pannelDownView)
        addSubview(dragImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let pannelUpViewY : CGFloat = currentScreenType() == .Phone_X ? 160 : 80
        let pannelUpHeight = ScreenWidth * 10.0 / 27
        pannelUpView.frame = CGRect(x:0, y: pannelUpViewY, width: ScreenWidth, height: pannelUpHeight)
        
        let dragImgHeight = ScreenWidth * 70.0 / 359
        let pannelDownW_H  = ScreenWidth - 20
        
        pannelDownView.frame = CGRect(x: 10, y: ScreenHeight - pannelDownW_H - dragImgHeight, width: pannelDownW_H, height: pannelDownW_H)
        
        dragImageView.frame = CGRect(x: 0, y: ScreenHeight - dragImgHeight, width: ScreenWidth, height: dragImgHeight)
    }

}
