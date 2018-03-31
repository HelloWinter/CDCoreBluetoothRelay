//
//  ViewController.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/17.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit

private let kDefaultRelayModelKey = "kDefaultRelayModelKey"
private let kDefaultPannelTypeKey = "kDefaultPannelTypeKey"

class ViewController: UIViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kPeripheralConnectStateChanged), object: nil)
    }
    
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.addSubview(mainPannel)
        scrollView.addSubview(configurePannel)
        scrollView.contentSize = CGSize(width: ScreenWidth, height: ScreenHeight * 2)
        return scrollView
    }()
    
    private let arrRelayModel = ["RP-5","RP-8"]
    
    private lazy var relayModelSelectView : PannelTypeSelectView = {
        let view = PannelTypeSelectView()
        view.setupView(text: arrRelayModel.last!, isResponseEvent: false)
        view.showOrHideViewClosure = {[weak self] (show : Bool) in
            self?.showRelayModelSelectPopVew(show)
        }
        view.isHidden = true//
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
        let type = UserDefaults.standard.object(forKey: kDefaultPannelTypeKey) as? String
        view.setupView(text: type ?? "Customize", isResponseEvent: type != nil ? false : true)
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
    
    private lazy var mainPannel : MainPannelView = {
        let imageV = MainPannelView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        if let type = UserDefaults.standard.object(forKey: kDefaultPannelTypeKey) as? String,arrPannelType.contains(type),type != arrPannelType.last {
            imageV.setupPannelType(type: type)
        }else{
            imageV.setupPannelType(type: nil)
        }
        return imageV
    }()
    
    private lazy var configurePannel : ConfigurePannelView = {
        let imageV = ConfigurePannelView(frame: CGRect(x: 0, y: mainPannel.frame.maxY, width: ScreenWidth, height: ScreenHeight))
        if let type = UserDefaults.standard.object(forKey: kDefaultPannelTypeKey) as? String,arrPannelType.contains(type),type != arrPannelType.last {
            imageV.setupBrandButton(isCustom: true)
        }else{
            imageV.setupBrandButton(isCustom: false)
        }
        return imageV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(relayModelSelectView)
        scrollView.addSubview(pannelTypeSelectView)
        
        let selectViewWidth : CGFloat = (ScreenWidth - 30) * 0.5
        let selectViewHeight : CGFloat = 35
        let selectViewY : CGFloat = currentScreenType() == .Phone_X ? 60 : 20
        relayModelSelectView.frame = CGRect(x: 10, y: selectViewY, width: selectViewWidth, height: selectViewHeight)
        pannelTypeSelectView.frame = CGRect(x: ScreenWidth - 10 - selectViewWidth, y: selectViewY, width: selectViewWidth, height: selectViewHeight)
        
        NotificationCenter.default.addObserver(self, selector: #selector(peripheralConnectStateChanged), name: NSNotification.Name(rawValue: kPeripheralConnectStateChanged), object: nil)
        
        CDCoreBluetoothTool.shared.discoverPeripheralUnconnectClosure = {[weak self] in
            self?.switchPannel(state: false)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        get{
            return true
        }
    }
    
    @objc private func peripheralConnectStateChanged(noti : Notification) {
        if let state = noti.object as? Bool {
            switchPannel(state: state)
        }
    }
    
    @objc private func switchPannel(state : Bool){
        if state {
            if scrollView.contentOffset.y != 0 {
                scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), animated: true)
            }
        }else{
            if scrollView.contentOffset.y == 0 {
                CDAutoHideMessageHUD.showMessage(NSLocalizedString("ConnectManually", comment: ""))
                scrollView.scrollRectToVisible(CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: ScreenHeight), animated: true)
            }
        }
    }
    
    private func setupSelectView(selectViewType : SelectViewType,selectIndex : Int) {
        if selectViewType == .relayModel {
            relayModelSelectView.resetButtonState()
            let relayModelText = arrRelayModel[selectIndex]
            relayModelSelectView.setupView(text: relayModelText, isResponseEvent: false)
            UserDefaults.standard.set(relayModelText, forKey: kDefaultRelayModelKey)
            UserDefaults.standard.synchronize()
            pannelTypeSelectView.isHidden = selectIndex == 0 ? true : false
        }
        
        if selectViewType == .pannelType  {
            pannelTypeSelectView.resetButtonState()
            let brandText = arrPannelType[selectIndex]
            pannelTypeSelectView.setupView(text: brandText, isResponseEvent: false)
            UserDefaults.standard.set(brandText, forKey: kDefaultPannelTypeKey)
            UserDefaults.standard.synchronize()
            if brandText != arrPannelType.last {
                mainPannel.setupPannelType(type: brandText)
                configurePannel.setupBrandButton(isCustom: true)
            }else{
                mainPannel.setupPannelType(type: nil)
                configurePannel.setupBrandButton(isCustom: false)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}



