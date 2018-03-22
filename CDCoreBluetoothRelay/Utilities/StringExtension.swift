//
//  StringExtension.swift
//  ShangHaiProvidentFundSwift
//
//  Created by cd on 2017/9/13.
//  Copyright © 2017年 Cheng. All rights reserved.
//


import UIKit

extension String{
    
    ///String转Double?类型
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    ///检验是否是邮箱
    func isEmail() -> Bool {
        let emailRegex = "^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(.[a-zA-Z0-9_-]+)+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }
}


