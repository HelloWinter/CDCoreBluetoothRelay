//
//  PannelButton.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/25.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit

enum ButtonType : Int{
    case btn_NAV = 0 //继电器NAV按钮
    case btn_anchor //继电器按钮anchor
    case btn_B   //按钮B
    case btn_M   //按钮M
    case btn_S   //按钮S
    case btn_1   //按钮1
    case btn_2   //按钮2
    case btn_3   //按钮3
    case btn_switch //遥控器开关按钮
    case btn_NAV_control //遥控器板NAV按钮
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
    func setupButton(normalImg : String,selectedImg : String,disableImg : String?,type : ButtonType,isEnable : Bool = false) -> Void {
        setImage(UIImage(named:normalImg), for: .normal)
        setImage(UIImage(named:selectedImg), for: .selected)
        if let img = disableImg {
            setImage(UIImage(named:img), for: .disabled)
        }else{
            setImage(nil, for: .disabled)
        }
        btnType = type
        isEnabled = isEnable
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
            statusCode.append("06")
        case .btn_NAV:
            statusCode.append("07")
        case .btn_anchor:
            statusCode.append("08")
        case .btn_NAV_control:
            statusCode.append("09")
        default:
            CDAutoHideMessageHUD.showMessage(NSLocalizedString("ButtonFunctionUnknown", comment: ""))
            break
        }
        return statusCode
    }
    
}
