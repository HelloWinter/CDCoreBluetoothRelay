//
//  ViewController.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/17.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kPeripheralConnectStateChanged), object: nil)
    }
    
    /// 下拉选择控件宽度
    private let selectViewWidth : CGFloat = (ScreenWidth - 30) * 0.5
    /// 下拉选择控件高度
    private let selectViewHeight : CGFloat = 35
    /// 下拉选择控件Y坐标
    private let selectViewY : CGFloat = currentScreenType() == .Phone_X ? 60 : 20
    
    private var a : Int?
    
    
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: ScreenWidth, height: ScreenHeight * 2)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    private let pannelTypeCustomize = "Customize"
    private lazy var currentRelayModel : String = relayModel() ?? arrRelayModel.last!
    private lazy var currentPannelType : String = rp8BrandType() ?? pannelTypeCustomize
    
    private lazy var relayModelSelectView : PannelTypeSelectView = {
        let view = PannelTypeSelectView(frame: CGRect(x: 10, y: selectViewY, width: selectViewWidth, height: selectViewHeight))
        view.setupView(text: currentRelayModel , isResponseEvent: false)
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
    
    private lazy var pannelTypeSelectView : PannelTypeSelectView = {
        let view = PannelTypeSelectView(frame: CGRect(x: ScreenWidth - 10 - selectViewWidth, y: selectViewY, width: selectViewWidth, height: selectViewHeight))
        view.isHidden = (relayModel() != nil && relayModel()! == arrRelayModel.first!)
        view.setupView(text: currentPannelType , isResponseEvent: currentPannelType == pannelTypeCustomize)
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
        if let type = rp8BrandType(),arrPannelType.contains(type),type != arrPannelType.last {
            imageV.setupPannelType(type: type)
        }else{
            imageV.setupPannelType(type: nil)
        }
        return imageV
    }()
    
    private lazy var configurePannel : ConfigurePannelView = {
        let imageV = ConfigurePannelView(frame: CGRect(x: 0, y: mainPannel.frame.maxY, width: ScreenWidth, height: ScreenHeight))
        if let type = rp8BrandType(),arrPannelType.contains(type),type != arrPannelType.last {
            imageV.setupBrandButton(isCustom: true)
        }else{
            imageV.setupBrandButton(isCustom: false)
        }
        return imageV
    }()
    
    private lazy var rp5MainPannel : RP5MainPannelView = {
        let view = RP5MainPannelView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        return view
    }()
    
    private lazy var rp5ConfigurePannel : RP5ConfigurePannelView = {
        let imageV = RP5ConfigurePannelView(frame: CGRect(x: 0, y: rp5MainPannel.frame.maxY, width: ScreenWidth, height: ScreenHeight))
        return imageV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(scrollView)
        
        //设置初始面板
        if let relayModel = relayModel(), relayModel == arrRelayModel.first! {
            scrollView.addSubview(rp5MainPannel)
            scrollView.addSubview(rp5ConfigurePannel)
        }else{
            scrollView.addSubview(mainPannel)
            scrollView.addSubview(configurePannel)
        }
        //添加下拉选择控件
        scrollView.addSubview(relayModelSelectView)
        scrollView.addSubview(pannelTypeSelectView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(peripheralConnectStateChanged), name: NSNotification.Name(rawValue: kPeripheralConnectStateChanged), object: nil)
        
        CDCoreBluetoothTool.shared.discoverPeripheralUnconnectClosure = {[weak self] in
            self?.switchPannel(state: false)
        }
//        a=15
//        let b = a.g({ (x) -> String? in
//            return test(a: x)
//        })
//        print(b)
        
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
    
    /// 未连接外设状态跳转至手动连接界面
    ///
    /// - Parameter state: 是否已连接外设
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
    
    /// 下拉选择控件选择事件
    ///
    /// - Parameters:
    ///   - selectViewType: 下拉选择控件类型
    ///   - selectIndex: 选中的index
    private func setupSelectView(selectViewType : SelectViewType,selectIndex : Int) {
        if selectViewType == .relayModel {
            relayModelSelectView.resetButtonState()
            pannelTypeSelectView.isHidden = selectIndex == 0 ? true : false
            let relayModelText = arrRelayModel[selectIndex]
            if relayModelText != currentRelayModel {
                currentRelayModel = relayModelText
                relayModelSelectView.setupView(text: relayModelText, isResponseEvent: false)
                //存储当前继电器种类
                saveRelayModel(relayModelText)
                //断开之前外设连接，再扫描
                CDCoreBluetoothTool.shared.cancelConnection()
                CDCoreBluetoothTool.shared.scanPeripheral()
                //清理原来的面板
                for subView in scrollView.subviews {
                    if !subView.isKind(of: PannelTypeSelectView.self) {
                        subView.removeFromSuperview()
                    }
                }
                //切换面板
                if relayModelText == arrRelayModel.first! {
                    scrollView.insertSubview(rp5ConfigurePannel, at: 0)
                    scrollView.insertSubview(rp5MainPannel, at: 0)
                }else{
                    scrollView.insertSubview(configurePannel, at: 0)
                    scrollView.insertSubview(mainPannel, at: 0)
                }
            }
        }
        
        if selectViewType == .pannelType  {
            pannelTypeSelectView.resetButtonState()
            let brandText = arrPannelType[selectIndex]
            if brandText != currentPannelType {
                currentPannelType = brandText
                pannelTypeSelectView.setupView(text: brandText, isResponseEvent: false)
                saveRP8BrandType(brandText)
                if brandText != arrPannelType.last {
                    mainPannel.setupPannelType(type: brandText)
                    configurePannel.setupBrandButton(isCustom: true)
                }else{
                    mainPannel.setupPannelType(type: nil)
                    configurePannel.setupBrandButton(isCustom: false)
                }
            }
        }
    }
    private func test(a : Int) -> String{
        return "hello!->\(a)"
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



