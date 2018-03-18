//
//  ViewController.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/17.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var scrollView : BluetoothRelayPannelView = {
        let scrollView = BluetoothRelayPannelView()
        
//        scrollView.delegate = self
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}



