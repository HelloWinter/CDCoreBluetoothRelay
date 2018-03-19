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
    
    private lazy var pannelUpView : UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "main_pannel_up")
        return imgV
    }()
    
    private lazy var pannelDownView : UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "main_pannel_down")
        return imgV
    }()
    
    private lazy var pannelTypeSelectView : PannelTypeSelectView = {
        let view = PannelTypeSelectView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        backgroundColor = UIColor(red: 187.0/255.0, green: 187.0/255.0, blue: 187.0/255.0, alpha: 1.0)
        addSubview(pannelUpView)
        addSubview(pannelDownView)
        addSubview(dragImageView)
        addSubview(pannelTypeSelectView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imgWidth = UIScreen.main.bounds.width
        let imgHeight = imgWidth * 140.0 / 718
        
        let pannelUpWidth = imgWidth-20
        let pannelUpHeight = pannelUpWidth * 300.0 / 553
        pannelUpView.frame = CGRect(x: 10, y: 80, width: pannelUpWidth, height: pannelUpHeight)
        
        let pannelDownWidth = imgWidth-20
        let pannelDownHeight = pannelDownWidth * 1360.0 / 1553
        pannelDownView.frame = CGRect(x: 10, y: UIScreen.main.bounds.height - pannelDownHeight, width: pannelDownWidth, height: pannelDownHeight)
        
        dragImageView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - imgHeight, width: imgWidth, height: imgHeight)
        
        let selectViewWidth : CGFloat = 200
        pannelTypeSelectView.frame = CGRect(x: imgWidth - 20 - selectViewWidth, y: 30, width: selectViewWidth, height: 40)
    }

}
