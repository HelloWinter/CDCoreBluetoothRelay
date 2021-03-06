//
//  CDUtilities.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/24.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit

/// 当前继电器类型
let arrRelayModel = ["RP-5","RP-8"]
private let kDefaultRelayModelKey = "kDefaultRelayModelKey"
func relayModel() -> String? {
    return UserDefaults.standard.object(forKey: kDefaultRelayModelKey) as? String
}
func saveRelayModel(_ model : String){
    UserDefaults.standard.set(model, forKey: kDefaultRelayModelKey)
    UserDefaults.standard.synchronize()
}

/// RP8继电器面板品牌
let arrPannelType = ["Gator Tail","Smoker Craft","Tracker","Xpress","Other"]
private let kDefaultPannelTypeKey = "kDefaultPannelTypeKey"
func rp8BrandType() -> String?{
    return UserDefaults.standard.object(forKey: kDefaultPannelTypeKey) as? String
}
func saveRP8BrandType(_ type : String) {
    UserDefaults.standard.set(type, forKey: kDefaultPannelTypeKey)
    UserDefaults.standard.synchronize()
}


enum ScreenType : Int {
    case Phone3_5
    case Phone4_0
    case Phone4_7
    case Phone5_5
    case Phone_X
    case Pad
    case Unspecified
}

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

private func findTopModelViewController(vc : UIViewController) -> UIViewController {
    var vc = vc
    while vc.presentedViewController != nil {
        vc = vc.presentedViewController!
    }
    if vc.isKind(of: UINavigationController.self) {
        vc = (vc as! UINavigationController).visibleViewController!
    }
    return vc
}

func visibleController() -> UIViewController? {
    if let window = UIApplication.shared.delegate?.window as? UIWindow,let appRootViewController = window.rootViewController  {
        if appRootViewController.isKind(of: UITabBarController.self) {
            let tabBarVC = appRootViewController as! UITabBarController
            return findTopModelViewController(vc: tabBarVC.selectedViewController!)
        }else{
            return findTopModelViewController(vc: appRootViewController)
        }
    }
    return nil
}

/// 当前屏幕类型
func currentScreenType() -> ScreenType {
    if (UI_USER_INTERFACE_IDIOM() == .phone) {
        let screenSize = UIScreen.main.bounds.size
        
        if screenSize.equalTo(CGSize(width: 320, height: 480)) || screenSize.equalTo(CGSize(width: 480, height: 320)) {
            return .Phone3_5
        }
        
        if screenSize.equalTo(CGSize(width: 320, height: 568)) || screenSize.equalTo(CGSize(width: 568, height: 320)) {
            return .Phone4_0
        }
        
        if screenSize.equalTo(CGSize(width: 375, height: 667)) || screenSize.equalTo(CGSize(width: 667, height: 375)) {
            return .Phone4_7
        }
        
        if screenSize.equalTo(CGSize(width: 414, height: 736)) || screenSize.equalTo(CGSize(width: 736, height: 414)) {
            return .Phone5_5
        }
        
        if screenSize.equalTo(CGSize(width: 375, height: 812)) || screenSize.equalTo(CGSize(width: 812, height: 375)) {
            return .Phone_X
        }
    }else if (UI_USER_INTERFACE_IDIOM() == .pad){
        return .Pad;
    }
    return .Unspecified
}

///16进制字符串转换成Data类型
func dataFrom(hexString : String) -> Data? {
    if hexString.count == 0 {
        return nil
    }
    var mutableData = Data.init(capacity: 8)
    var range : NSRange
    if hexString.count % 2 == 0 {
        range = NSRange(location: 0, length: 2)
    }else{
        range = NSRange(location: 0, length: 1)
    }
    for _ in (range.location..<hexString.count).filter({($0 - range.location) % 2 == 0}) {
        var anInt : UInt32 = 0
        let hexCharStr = (hexString as NSString).substring(with: range)
        let scanner = Scanner(string: hexCharStr)
        scanner.scanHexInt32(&anInt)
        mutableData.append(Data.init(bytes: &anInt, count: 1))
        range.location += range.length;
        range.length = 2;
    }
    return mutableData
}
///Data类型转换成16进制字符串
func hexStringFrom(data : Data) -> String? {
    if data.count == 0 {
        return nil
    }
    var mutableString = String()
    for value in data {
        let hexStr = String(format: "%02X", value & 0xff)
        mutableString.append(hexStr)
    }
    return mutableString
}
//计算CRC8校验码
func calculateCRC8(data : Data?) -> UInt8? {
    guard let data = data else {
        return nil
    }
    var CRC : UInt8 = 0
    let genPoly : UInt8 = 0x8C
    for value in data {
        CRC ^= value
        for _ in 0..<8 {
            if (CRC & 0x01) != 0 {
                CRC = (CRC >> 1) ^ genPoly
            } else {
                CRC >>= 1
            }
        }
    }
    CRC &= 0xFF;//保证CRC余码输出为1字节。
    return CRC
}
///提取按钮状态
func extractButtonStatus(byte : UInt8) -> [Bool] {
    let bit7 = ((byte >> 7) & 0x1 == 1)
    let bit6 = ((byte >> 6) & 0x1 == 1)
    let bit5 = ((byte >> 5) & 0x1 == 1)
    let bit4 = ((byte >> 4) & 0x1 == 1)
    let bit3 = ((byte >> 3) & 0x1 == 1)
    let bit2 = ((byte >> 2) & 0x1 == 1)
    let bit1 = ((byte >> 1) & 0x1 == 1)
    let bit0 = ((byte >> 0) & 0x1 == 1)
    return [bit7,bit6,bit5,bit4,bit3,bit2,bit1,bit0]
}
