//
//  CDCoreBluetoothTool.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/18.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit
import CoreBluetooth
///服务的UUID
private let ServiceUUID = "FFE0"
///Write,Notify特征的UUID
private let CharacteristicUUID = "FFE1"
///存储最新连接的RP8蓝牙外设UUID的UUIDKey
private let kBluetoothPeripheralRP8UUIDKey = "kBluetoothPeripheralRP8UUIDKey"
///存储最新连接的RP5蓝牙外设UUID的UUIDKey
private let kBluetoothPeripheralRP5UUIDKey = "kBluetoothPeripheralRP5UUIDKey"
///发现新的蓝牙外设通知
let kDiscoverBluetoothPeripheral = "DiscoverBluetoothPeripheral"
///外设连接状态改变通知
let kPeripheralConnectStateChanged = "kPeripheralConnectStateChanged"
///收到RP5外设发送的数据
let kReceivedRP5Value = "kReceivedRP5Value"
///收到RP8外设发送的数据
let kReceivedRP8Value = "kReceivedRP8Value"

class CDCoreBluetoothTool: NSObject,CBCentralManagerDelegate,CBPeripheralDelegate {
    
    static let shared : CDCoreBluetoothTool = CDCoreBluetoothTool()
    
    var discoverPeripheralUnconnectClosure : (() -> Void)?
    
    var peripheralConnectState : Bool = false
    
    private var cMgr : CBCentralManager?
    
    private override init() {
        super.init()
        cMgr = CBCentralManager(delegate: self, queue: nil)
    }
    
    private var peripheral : CBPeripheral?
    
    private var characteristic : CBCharacteristic?
    
    private var notifyCharteristic : CBCharacteristic?
    
    private(set) var arrPeri : [CBPeripheral] = Array()
    
    private var arrPeriUUID = [String]()
    
    private var peripheralConnectRetry = 0
    ///获取所有按钮初始状态
    func getAllButtonState() -> Void {
        if (relayModel() != nil && relayModel()! == arrRelayModel.first!) {
            sendToPeripheralWith(hexString: "550102F5F59F")
        }else{
//            print(String(format: "CRC8：%02X", calculateCRC8(data: dataFrom(hexString: "550102F5F5"))!))
            sendToPeripheralWith(hexString: "55AA0111C2")
        }
        
//        sendToPeripheralWith(hexString: "5501020001d9")//测试
//        sendToPeripheralWith(hexString: "55010201011d")//测试
//        sendToPeripheralWith(hexString: "5500020002b4")//测试
//        sendToPeripheralWith(hexString: "550002000469")//测试
//        sendToPeripheralWith(hexString: "5500020008ca")//测试
//        sendToPeripheralWith(hexString: "550002001095")//测试
//        sendToPeripheralWith(hexString: "55000200202b")//测试
//        sendToPeripheralWith(hexString: "5500020003ea")//测试
//        sendToPeripheralWith(hexString: "550002000008")//测试
//        55AA0312000198
//        55AA0312001105
        
    }
    ///向外设发送16进制字符串
    func sendToPeripheralWith(hexString : String?) {
        if let hexStr = hexString,let data = dataFrom(hexString: hexStr) {
            if let peripheral = self.peripheral{
                peripheral.writeValue(data, for: self.characteristic!, type: CBCharacteristicWriteType.withResponse)
            }else{
                CDAutoHideMessageHUD.showMessage(NSLocalizedString("ConnectManually", comment: ""))
            }
        }
    }
    ///连接到外设
    func connectTo(peripheral : CBPeripheral) -> Void {
        //保存连接的外设
        self.peripheral = peripheral
        cMgr!.connect(peripheral, options: nil)
    }
    ///扫描外设
    func scanPeripheral() -> Void {
        cMgr!.scanForPeripherals(withServices: nil, options: nil)
    }
    ///停止扫描
    func stopScanPeripheral() -> Void {
        cMgr!.stopScan()
    }
    /// 断开当前外设连接
    func cancelConnection() -> Void {
        if self.peripheral != nil {
            cMgr!.cancelPeripheralConnection(self.peripheral!)
        }
        arrPeriUUID.removeAll()
        arrPeri.removeAll()
    }
    
}

extension CDCoreBluetoothTool {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            CDAutoHideMessageHUD.showMessage(NSLocalizedString("BluetoothPowerOff", comment: ""))
        case .poweredOn:
            print("蓝牙已开启")
            scanPeripheral()
        case .resetting:
            CDAutoHideMessageHUD.showMessage(NSLocalizedString("BluetoothResetting", comment: ""))
        case .unauthorized:
            CDAutoHideMessageHUD.showMessage(NSLocalizedString("BluetoothUnauthorized", comment: ""))
        case .unknown:
            CDAutoHideMessageHUD.showMessage(NSLocalizedString("BluetoothUnknown", comment: ""))
        case .unsupported:
            CDAutoHideMessageHUD.showMessage(NSLocalizedString("BluetoothUnsupport", comment: ""))
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(">>>>>------peripheral : \(peripheral), advertisementData : \(advertisementData), RSSI : \(RSSI)")
        //"根据切换的继电器类型，过滤扫描到的外设"
//        let key = (relayModel() != nil && relayModel()! == arrRelayModel.first!) ? "RP-5" : "RP-8"
//        if let periname = peripheral.name,periname.uppercased().hasPrefix(key) {
            let uuidString = peripheral.identifier.uuidString
            //保存外设
            if !arrPeriUUID.contains(uuidString) {
                arrPeri.append(peripheral)
                arrPeriUUID.append(uuidString)
                //通知更新外设列表显示
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kDiscoverBluetoothPeripheral), object: nil)
            }
            
            let key = (relayModel() != nil && relayModel()! == arrRelayModel.first!) ? kBluetoothPeripheralRP5UUIDKey : kBluetoothPeripheralRP8UUIDKey
            //已连接过的设备，自动连接
            if let uuid = UserDefaults.standard.object(forKey: key) as? String, uuid == peripheral.identifier.uuidString {
                connectTo(peripheral: peripheral)
            }else{//搜到设备，但未连接,需要手动连接
                "FIXIT : 这里有问题，可能被执行多次"
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {[weak self] in
                    //等待3秒如果还是没有连接上，就跳转到配置页，手动连接
                    if !(self?.peripheralConnectState)! {
                        if let closure = self?.discoverPeripheralUnconnectClosure {
                            closure()
                        }
                    }
                })
            }
//        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("外设连接成功")
        //停止扫描
        stopScanPeripheral()
        self.peripheral?.delegate = self
        // services:传入nil代表扫描所有服务
        self.peripheral?.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        self.peripheral = nil
        CDAutoHideMessageHUD.showMessage(NSLocalizedString("FailConnect", comment: ""))
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("外设断开连接")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPeripheralConnectStateChanged), object: false)
        peripheralConnectState = false
        self.peripheral = nil
        //外设断开连接重试次数
        if peripheralConnectRetry < 1 {
            connectTo(peripheral: peripheral)
            peripheralConnectRetry += 1
        }
    }
}

extension CDCoreBluetoothTool {
    
    /// 修改服务触发
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        // 重新扫描
        self.peripheral?.discoverServices(nil)
    }
    
    /// 发现服务时触发
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("发现服务")
        if let error = error {
            print(error.localizedDescription)
            return
        }
        for service in peripheral.services! {
//            if service.uuid.uuidString == ServiceUUID {
                print("找到了serviceUUID : \(service.uuid.uuidString)")
                //根据服务扫描特征,传nil代表扫描所有特征
                peripheral.discoverCharacteristics(nil, for: service)
//            }
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
            if characteristic.uuid.uuidString.hasPrefix("49535343")  {//CharacteristicUUID
                let writeValue = characteristic.properties.rawValue & CBCharacteristicProperties.write.rawValue
                let writeWithoutValue = characteristic.properties.rawValue & CBCharacteristicProperties.writeWithoutResponse.rawValue
            
                if (writeValue != 0) && (writeWithoutValue != 0) {
                    self.characteristic = characteristic
                }
                if (characteristic.properties.rawValue & CBCharacteristicProperties.notify.rawValue) != 0 {
                    self.notifyCharteristic = characteristic
                    peripheral.setNotifyValue(true, for: self.notifyCharteristic!)
                }
            }
        }
        if self.characteristic != nil && self.notifyCharteristic != nil {
            //外设连接并扫描特征成功
            //保存uuid
            let key = (relayModel() != nil && relayModel()! == arrRelayModel.first!) ? kBluetoothPeripheralRP5UUIDKey : kBluetoothPeripheralRP8UUIDKey
            UserDefaults.standard.set(peripheral.identifier.uuidString, forKey: key)
            UserDefaults.standard.synchronize()
            ///通知可以通信了
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPeripheralConnectStateChanged), object: true)
            peripheralConnectState = true
            peripheralConnectRetry = 0
            getAllButtonState()
        }
    }
    /// 外设可以发送数据给中心设备，中心设备也可以从外设读取数据，当发生这些事情的时候，就会回调这个方法。通过特征中的value属性拿到原始数据，然后根据需求解析数据。
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("读取外设数据调用")
        if let error = error {
            print("读取外设数据错误 ：\(error.localizedDescription)")
            return
        }
//        if characteristic.uuid.uuidString != CharacteristicUUID {
//            return
//        }
        if let data = characteristic.value, let receiveStr = hexStringFrom(data: data)?.uppercased() {
            print("读取外设数据 receiveStr : \(receiveStr)")
            if receiveStr.hasPrefix("5500") || receiveStr.hasPrefix("55AA0312") {
                var subData = data
                subData.remove(at: (data.count-1))
                //校验crc8
                if let crc = calculateCRC8(data: subData),receiveStr.hasSuffix(String(format: "%02X", crc)) {
                    print(String(format: "CRC :%02X", crc))
//                    let key = (relayModel() != nil && relayModel()! == arrRelayModel.first!) ? kReceivedRP5Value : kReceivedRP8Value
                    let key = receiveStr.hasPrefix("5500") ? kReceivedRP5Value : kReceivedRP8Value
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: key), object: subData)
                }
            }
        }
    }
    //订阅状态发生改变时调用改变
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("订阅状态发生改变")
        if let error = error {
            print("订阅失败 ： \(error.localizedDescription)")
            return
        }
        if (characteristic.isNotifying) {
            print("订阅成功")
        } else {
            print("取消订阅")
        }
    }
    //中心向外设写数据是否成功
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("向外设写数据")
        if let error = error {
            CDAutoHideMessageHUD.showMessage(error.localizedDescription)
            return
        }
        print("向外设写数据成功")
    }
}
