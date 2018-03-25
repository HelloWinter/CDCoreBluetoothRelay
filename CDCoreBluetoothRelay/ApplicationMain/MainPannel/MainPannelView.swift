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
        imgV.image = UIImage(named: "main_pannel_up")
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
        addSubview(relayModelSelectView)
        addSubview(pannelTypeSelectView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let screen_Width = UIScreen.main.bounds.width
        let imgHeight = screen_Width * 140.0 / 718
        
        let pannelUpHeight = screen_Width * 300.0 / 553
        pannelUpView.frame = CGRect(x:0, y: 80, width: screen_Width, height: pannelUpHeight)
        
        let pannelDownWidth = screen_Width-20
        let pannelDownHeight = pannelDownWidth * 1360.0 / 1553
        pannelDownView.frame = CGRect(x: 10, y: UIScreen.main.bounds.height - pannelDownHeight, width: pannelDownWidth, height: pannelDownHeight)
        
        dragImageView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - imgHeight, width: screen_Width, height: imgHeight)
        
        let selectViewWidth : CGFloat = 145
        relayModelSelectView.frame = CGRect(x: 10, y: 20, width: selectViewWidth, height: 40)
        pannelTypeSelectView.frame = CGRect(x: screen_Width - 10 - selectViewWidth, y: 20, width: selectViewWidth, height: 40)
    }
    
    private func setupSelectView(selectViewType : SelectViewType,selectIndex : Int) {
        if selectViewType == .relayModel {
            relayModelSelectView.resetButtonState()
            relayModelSelectView.setupView(text: arrRelayModel[selectIndex], isResponseEvent: false)
            pannelTypeSelectView.isHidden = selectIndex == 0 ? true : false
        }
        if selectViewType == .pannelType {
            pannelTypeSelectView.resetButtonState()
            pannelTypeSelectView.setupView(text: arrPannelType[selectIndex], isResponseEvent: false)
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
