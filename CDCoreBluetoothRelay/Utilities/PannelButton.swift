//
//  PannelButton.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/25.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit

enum ButtonType : Int{
    case btn_NAV = 0 //继电器按钮NAV
    case btn_anchor //继电器按钮anchor
    case btn_B   //继电器按钮B
    case btn_M   //继电器按钮M
    case btn_S   //继电器按钮S
    case btn_1   //继电器按钮1
    case btn_2   //继电器按钮2
    case btn_3   //继电器按钮3
    case btn_switch //继电器开关
    case btn_unknown //未知
}

class PannelButton: UIButton {
    
    private(set) var btnType : ButtonType = .btn_unknown
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// 设置按钮
    ///
    /// - Parameters:
    ///   - normalImg: 关闭状态图片
    ///   - selectedImg: 打开状态图片
    ///   - disableImg: 不可用状态图片
    ///   - type: 按钮功能类型
    func setupButton(normalImg : String,selectedImg : String,disableImg : String?,type : ButtonType) -> Void {
        setImage(UIImage(named:normalImg), for: .normal)
        setImage(UIImage(named:selectedImg), for: .selected)
        if let img = disableImg {
            setImage(UIImage(named:img), for: .disabled)
        }else{
            setImage(nil, for: .disabled)
        }
        btnType = type
        isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getStatusCode() -> String {
        var statusCode = ""
        switch btnType {
        case .btn_switch:
            statusCode.append("00")
        case .btn_1:
            statusCode.append("01")
        case .btn_B:
            statusCode.append("02")
        case .btn_M:
            statusCode.append("03")
        case .btn_S:
            statusCode.append("04")
        case .btn_2:
            statusCode.append("05")
        case .btn_3:
            statusCode.append("06")//预留
        case .btn_NAV:
            statusCode.append("07")//预留
        default:
            CDAutoHideMessageHUD.showMessage(NSLocalizedString("ButtonFunctionUnknown", comment: ""))
            break
        }
        return statusCode
    }
    
}
