//
//  OptionalExtension.swift
//  CDCoreBluetoothRelay
//
//  Created by dongdong.cheng on 2019/6/21.
//  Copyright © 2019 dong cheng. All rights reserved.
//

import Foundation


extension Optional{
    func g<b>(_ f : (Wrapped) -> b?) -> b? {
        //Optional类型的flatMap，本质就是提供了一个标准化的方式，来实现Optional Value 到只接收非Optional Value逻辑的绑定
        return self.flatMap{ f($0) }
    }
}
