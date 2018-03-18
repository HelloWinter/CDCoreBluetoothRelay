//
//  ConfigurePannelView.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/18.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit

class ConfigurePannelView: UIImageView {

    private lazy var dragImageView : UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "connect_header")
        return imgV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = UIColor(red: 107.0/255.0, green: 107.0/255.0, blue: 107.0/255.0, alpha: 1.0)
        addSubview(dragImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imgWidth = UIScreen.main.bounds.width
        let imgHeight = imgWidth * 190.0 / 717
        dragImageView.frame = CGRect(x: 0, y: 0, width: imgWidth, height: imgHeight)
    }

}
