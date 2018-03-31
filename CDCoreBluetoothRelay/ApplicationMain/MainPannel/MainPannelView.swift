//
//  MainPannelView.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/18.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit


class MainPannelView: UIImageView {
    
    private lazy var dragImageView : UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "menu_booter_new")
        return imgV
    }()
    
    private lazy var pannelUpView : MainPannelUpView = {
        let imgV = MainPannelUpView(frame: .zero)
        return imgV
    }()
    
    private lazy var pannelDownView : MainPannelDownView = {
        let imgV = MainPannelDownView(frame: .zero)
        imgV.image = UIImage(named: "main_pannel_down_blank")
        return imgV
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        image = UIImage(named: "main_pannel_background")
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
        let pannelUpHeight = ScreenWidth * 125.0 / 222
        pannelUpView.frame = CGRect(x:0, y: pannelUpViewY, width: ScreenWidth, height: pannelUpHeight)
        
        let pannelDownWidth = ScreenWidth-20
        let pannelDownHeight = pannelDownWidth * 1360.0 / 1553
        pannelDownView.frame = CGRect(x: 10, y: ScreenHeight - pannelDownHeight, width: pannelDownWidth, height: pannelDownHeight)
        let imgHeight = ScreenWidth * 140.0 / 718
        dragImageView.frame = CGRect(x: 0, y: ScreenHeight - imgHeight, width: ScreenWidth, height: imgHeight)
    }
    
    func setupPannelType(type : String?) -> Void {
        pannelUpView.setupBrandImage(type)
        pannelDownView.setupBrandButton(isCustom: type != nil ? true : false)
    }

}
