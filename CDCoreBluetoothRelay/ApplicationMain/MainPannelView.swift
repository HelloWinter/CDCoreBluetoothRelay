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
    
    private let arrRelayModel = ["RP-5","RP-8"]
    
    private lazy var relayModelSelectView : PannelTypeSelectView = {
        let view = PannelTypeSelectView()
        view.setupView(text: arrRelayModel.last!, isResponseEvent: false)
        view.showOrHideViewClosure = {[weak self] (show : Bool) in
            if show {
                self?.relayModelSelectPopVew.show()
            }else{
                self?.relayModelSelectPopVew.hide()
            }
        }
        return view
    }()
    
    private lazy var relayModelSelectPopVew : PannelTypeSelectPopView = {
        let popView = PannelTypeSelectPopView()
        popView.arrCellData = arrRelayModel
        popView.selectViewType = SelectViewType.relayModel
        popView.selectCousure = {[weak self] (selectViewType : SelectViewType,selectIndex : Int) in
            self?.setupSelectView(selectViewType: selectViewType, selectIndex: selectIndex)
        }
        return popView
    }()
    
    private let arrPannelType = ["Gator Tail","Smoker Craft","Tracker","Xpress","Other"]
    
    private lazy var pannelTypeSelectView : PannelTypeSelectView = {
        let view = PannelTypeSelectView()
        view.setupView(text: "Customize", isResponseEvent: true)
        view.showOrHideViewClosure = {[weak self] (show : Bool) in
            if show {
                self?.pannelTypeSelectPopVew.show()
            }else{
                self?.pannelTypeSelectPopVew.hide()
            }
        }
        view.defaultClickClosure = {
            let emailView = EmailRSSView(viewType: .subscribeEmail)
            emailView.show()
        }
        return view
    }()
    
    private lazy var pannelTypeSelectPopVew : PannelTypeSelectPopView = {
        let popView = PannelTypeSelectPopView()
        popView.arrCellData = arrPannelType
        popView.selectViewType = SelectViewType.pannelType
        popView.selectCousure = {[weak self] (selectViewType : SelectViewType,selectIndex : Int) in
            self?.setupSelectView(selectViewType: selectViewType, selectIndex: selectIndex)
        }
        return popView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        addSubview(pannelUpView)
        addSubview(pannelDownView)
        addSubview(dragImageView)
        addSubview(relayModelSelectView)
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
        
        let selectViewWidth : CGFloat = 145
        pannelTypeSelectView.frame = CGRect(x: imgWidth - 10 - selectViewWidth, y: 20, width: selectViewWidth, height: 40)
    }
    
    private func setupSelectView(selectViewType : SelectViewType,selectIndex : Int) {
        if selectViewType == .relayModel {
            self.relayModelSelectView.setupView(text: arrRelayModel[selectIndex], isResponseEvent: false)
            if selectIndex == 0 {
                self.pannelTypeSelectView.isHidden = true
            }else{
                self.pannelTypeSelectView.isHidden = false
            }
            //////////这里popview也要移除
        }
        ////////////////////////////////////////////////////////
    }

}
