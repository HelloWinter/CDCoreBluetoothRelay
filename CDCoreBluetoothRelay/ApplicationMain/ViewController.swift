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
    
    private lazy var mainPannel : MainPannelView = {
        let imageV = MainPannelView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        imageV.image = UIImage(named: "main_pannel_background")
        return imageV
    }()
    
    private lazy var configurePannel : ConfigurePannelView = {
        let imageV = ConfigurePannelView(frame: CGRect(x: 0, y: mainPannel.frame.maxY, width: ScreenWidth, height: ScreenHeight))
        imageV.image = UIImage(named: "configure_pannel_background")
        return imageV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        
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
                CDAutoHideMessageHUD.showMessage("Please connect the bluetooth peripheral manually.")
                scrollView.scrollRectToVisible(CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: ScreenHeight), animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}



