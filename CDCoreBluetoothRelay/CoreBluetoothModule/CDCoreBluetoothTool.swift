//
//  CDCoreBluetoothTool.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/18.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit
import CoreBluetooth

private let ServiceUUID = "FFE0"//"ffe0"
private let WriteCharacteristicUUID = "FFE1"//"ffe1"
private let NotifyCharacteristicUUID = "FFE1"//"ffe1"

class CDCoreBluetoothTool: NSObject,CBCentralManagerDelegate,CBPeripheralDelegate {
    
    static let shared : CDCoreBluetoothTool = CDCoreBluetoothTool()
    
    private var cMgr : CBCentralManager?
    
    private override init() {
        super.init()
        cMgr = CBCentralManager(delegate: self, queue: nil)
    }
    
    private var peripheral : CBPeripheral?
    
    private var characteristic : CBCharacteristic?
    
    private var notifyCharteristic : CBCharacteristic?
    
    func writeData() -> Void {
        let data = dataFrom(hexString: "5501020001D9")
//        let data = "1101".data(using: String.Encoding.utf8)
        self.peripheral?.writeValue(data!, for: self.characteristic!, type: CBCharacteristicWriteType.withResponse)
    }
    
    private func dataFrom(hexString : String) -> Data? {
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
    
}

extension CDCoreBluetoothTool {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("蓝牙未开启")
        case .poweredOn:
            print("蓝牙已开启")
            ///扫描外设
            cMgr!.scanForPeripherals(withServices: nil, options: nil)
            print("\(cMgr!.isScanning)")
        case .resetting:
            print("正在重启")
        case .unauthorized:
            print("未授权")
        case .unknown:
            print("状态未知")
        case .unsupported:
            print("不支持蓝牙")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(">>>>>------peripheral : \(peripheral), advertisementData : \(advertisementData), RSSI : \(RSSI)")
        if let name = peripheral.name, name.contains("Blank") {
            self.peripheral = peripheral
            cMgr!.connect(peripheral, options: nil)
            cMgr!.stopScan()
        }
//        if peripheral.identifier.uuidString == ServiceUUID {
//
//        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("外设连接成功")
        self.peripheral?.delegate = self
        // services:传入nil代表扫描所有服务
        self.peripheral?.discoverServices(nil)//[CBUUID(string: ServiceUUID)]
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("外设连接失败")
        cMgr!.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("外设断开连接")
    }
}

extension CDCoreBluetoothTool {
    
    // 外设端发现了服务时触发
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("外设发现了服务")
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        for service in peripheral.services! {
            print("service.uuid.uuidString : \(service.uuid.uuidString)")
            if service.uuid.uuidString == ServiceUUID {
                print("找到了serviceUUID : \(service.uuid.uuidString)")
                //根据服务扫描特征,传nil代表扫描所有特征
                peripheral.discoverCharacteristics(nil, for: service)//[CBUUID(string: WriteCharacteristicUUID)]
            }
        }
        
    }
    //从服务获取特征
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("发现特征")
        if let error = error {
            print(error.localizedDescription)
            return
        }
        for characteristic in service.characteristics! {
            print("characteristic.uuid.uuidString : \(characteristic.uuid.uuidString)")
            
            if characteristic.uuid.uuidString == NotifyCharacteristicUUID {
                self.notifyCharteristic=characteristic
                peripheral.setNotifyValue(true, for: self.notifyCharteristic!)
            }

            if characteristic.uuid.uuidString == WriteCharacteristicUUID {
                self.characteristic = characteristic
//                peripheral.readValue(for: self.notifyCharteristic!)
            }
            
        }
        
    }
    //读数据
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("读取外设数据")
        if let error = error {
            print("读取外设数据错误 ： \(error.localizedDescription)")
            return
        }
        print("读取外设数据 characteristic.uuid.uuidString : \(characteristic.uuid.uuidString)")
        if characteristic.uuid.uuidString == WriteCharacteristicUUID {
            //characteristic.value就是你要的数据
            let data = characteristic.value
            //String(data: data!, encoding: String.Encoding.utf8)
            let receiveStr = DataTransformUtilities.hexString(from: data)
            print("receiveStr : \(receiveStr)")
        }
    }
    //中心读取外设实时数据
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("读取订阅外设实时数据")
        if let error = error {
            print("读取订阅外设实时数据 ： \(error.localizedDescription)")
            return
        }
        
    }
    //中心向外设写数据是否成功
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("向外设写数据")
        if let error = error {
            print(error.localizedDescription)
            return
        }
    }
}
