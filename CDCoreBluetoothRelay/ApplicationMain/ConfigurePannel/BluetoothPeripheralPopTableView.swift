//
//  BluetoothPeripheralPopTableView.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/24.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit
import CoreBluetooth

private let cellIdentifier = "cellIdentifier"

class BluetoothPeripheralPopTableView: UIView,UITableViewDataSource,UITableViewDelegate {
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(kDiscoverBluetoothPeripheral), object: nil)
    }

    var selectCousure : ((CBPeripheral) -> Void)?
    
    var arrCellData : [CBPeripheral]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let viewWidth : CGFloat = 280
    
    private let viewHeight : CGFloat = 396
    
    private lazy var backgroundMaskView : UIView = {
        let mask = UIView(frame: CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.bounds.width)!, height: (UIApplication.shared.keyWindow?.bounds.height)!))
        let tap = UITapGestureRecognizer(target: self, action: #selector(maskViewTapped))
        mask.addGestureRecognizer(tap)
        return mask
    }()
    
    private lazy var tableView : UITableView = {
        let tableV = UITableView()
        tableV.delegate = self
        tableV.dataSource = self
        let view = UIView()
        tableV.tableFooterView = view
        tableV.separatorInset = .zero
        tableV.backgroundColor = UIColor.clear
        tableV.backgroundView = nil
        tableV.showsVerticalScrollIndicator = false
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        return tableV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPeripheralTableView), name: Notification.Name(kDiscoverBluetoothPeripheral), object: nil)
        backgroundColor = UIColor.init(white: 0.25, alpha: 0.6)
        addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = CGRect(x: 10, y: 20, width: frame.width - 20, height: frame.height - 30)
        layer.borderColor = UIColor(red: 53.0/255.0, green: 133.0/255.0, blue: 202.0/255.0, alpha: 1.0).cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    func show() -> Void {
        CDCoreBluetoothTool.shared.scanPeripheral()
        if let keyWindow = UIApplication.shared.keyWindow {
            if backgroundMaskView.superview == nil {
                keyWindow.addSubview(backgroundMaskView)
            }
            if self.superview == nil {
                keyWindow.addSubview(self)
            }
            self.center = CGPoint(x: ScreenWidth * 0.5, y: ScreenHeight * 0.5)
        }
    }
    
    func hide() -> Void {
        CDCoreBluetoothTool.shared.stopScanPeripheral()
        if backgroundMaskView.superview != nil{
            backgroundMaskView.removeFromSuperview()
        }
        if self.superview != nil {
            self.removeFromSuperview()
        }
    }
    
    @objc func refreshPeripheralTableView(){
        arrCellData = CDCoreBluetoothTool.shared.arrPeri
    }
    
    @objc private func maskViewTapped(){
        hide()
    }

}

extension BluetoothPeripheralPopTableView{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arr = arrCellData else {
            return 0
        }
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell?.textLabel?.textColor = UIColor.white
        let peri = arrCellData![indexPath.row]
        cell!.textLabel?.text = peri.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let closure = self.selectCousure {
            closure(arrCellData![indexPath.row])
        }
        hide()
    }
}
