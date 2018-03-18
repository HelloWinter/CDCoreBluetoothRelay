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

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        backgroundColor = UIColor(red: 187.0/255.0, green: 187.0/255.0, blue: 187.0/255.0, alpha: 1.0)
        addSubview(dragImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imgWidth = UIScreen.main.bounds.width
        let imgHeight = imgWidth * 140.0 / 718
        dragImageView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - imgHeight, width: imgWidth, height: imgHeight)
    }

}
