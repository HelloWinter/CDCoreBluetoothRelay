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
        imgV.image = UIImage(named: "main_pannel")
        return imgV
    }()
    
    private lazy var pannelDownView : MainPannelDownView = {
        let imgV = MainPannelDownView(frame: .zero)
        imgV.image = UIImage(named: "main_pannel_down_blank")
        return imgV
    }()
    
    private let arrRelayModel = ["RP-5","RP-8"]
    
    private lazy var relayModelSelectView : PannelTypeSelectView = {
        let view = PannelTypeSelectView()
        view.setupView(text: arrRelayModel.last!, isResponseEvent: false)
        view.showOrHideViewClosure = {[weak self] (show : Bool) in
            self?.showRelayModelSelectPopVew(show)
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
            self?.showPannelTypeSelectPopVew(show)
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
//        addSubview(relayModelSelectView)
        addSubview(pannelTypeSelectView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let selectViewWidth : CGFloat = (ScreenWidth - 30) * 0.5
        let selectViewHeight : CGFloat = 35
        let selectViewY : CGFloat = currentScreenType() == .Phone_X ? 60 : 20
        relayModelSelectView.frame = CGRect(x: 10, y: selectViewY, width: selectViewWidth, height: selectViewHeight)
        pannelTypeSelectView.frame = CGRect(x: ScreenWidth - 10 - selectViewWidth, y: selectViewY, width: selectViewWidth, height: selectViewHeight)
        
        let pannelUpViewY : CGFloat = currentScreenType() == .Phone_X ? 160 : 80
        let pannelUpHeight = ScreenWidth * 125.0 / 222
        pannelUpView.frame = CGRect(x:0, y: pannelUpViewY, width: ScreenWidth, height: pannelUpHeight)
        
        let pannelDownWidth = ScreenWidth-20
        let pannelDownHeight = pannelDownWidth * 1360.0 / 1553
        pannelDownView.frame = CGRect(x: 10, y: ScreenHeight - pannelDownHeight, width: pannelDownWidth, height: pannelDownHeight)
        let imgHeight = ScreenWidth * 140.0 / 718
        dragImageView.frame = CGRect(x: 0, y: ScreenHeight - imgHeight, width: ScreenWidth, height: imgHeight)
    }
    
    private func setupSelectView(selectViewType : SelectViewType,selectIndex : Int) {
        if selectViewType == .relayModel {
            relayModelSelectView.resetButtonState()
            relayModelSelectView.setupView(text: arrRelayModel[selectIndex], isResponseEvent: false)
            pannelTypeSelectView.isHidden = selectIndex == 0 ? true : false
        }
        if selectViewType == .pannelType  {
            pannelTypeSelectView.resetButtonState()
            let brandText = arrPannelType[selectIndex]
            pannelTypeSelectView.setupView(text: brandText, isResponseEvent: false)
            if selectIndex == arrPannelType.count - 1 {
                pannelUpView.setupBrandImage("yak_power_gray", "yak_power_white")
            }else{
                let imgName = "brand_\(brandText)"
                pannelUpView.setupBrandImage(imgName)
            }
        }
    }
    
    private func showRelayModelSelectPopVew(_ show : Bool){
        pannelTypeSelectPopVew.hide()
        pannelTypeSelectView.resetButtonState()
        if show {
            relayModelSelectPopVew.show(at: CGPoint(x: relayModelSelectView.frame.maxX, y: relayModelSelectView.frame.maxY))
        }else{
            relayModelSelectPopVew.hide()
        }
    }
    
    private func showPannelTypeSelectPopVew(_ show : Bool){
        relayModelSelectView.resetButtonState()
        relayModelSelectPopVew.hide()
        if show {
            pannelTypeSelectPopVew.show(at: CGPoint(x: pannelTypeSelectView.frame.maxX, y: pannelTypeSelectView.frame.maxY))
        }else{
            pannelTypeSelectPopVew.hide()
        }
    }

}
