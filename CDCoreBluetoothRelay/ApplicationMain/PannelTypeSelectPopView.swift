//
//  PannelTypeSelectPopView.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/19.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit

enum SelectViewType {
    case relayModel
    case pannelType
}

class PannelTypeSelectPopView: UIView,UITableViewDataSource,UITableViewDelegate {
    
    var selectCousure : ((_ selectViewType : SelectViewType,_ selectIndex : Int) -> Void)?
    
    var arrCellData : [String]?
    
    var selectViewType : SelectViewType = .relayModel
    
    private let cellIdentifier = "cellIdentifier"
    
    private lazy var backgroundImageView : UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true
        img.image = UIImage(named: "main_pannel_popview")
        return img
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
        super.init(frame: CGRect(x: 0, y: 0, width: 145, height: 250))
        backgroundColor = UIColor.clear
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.frame = self.bounds
        tableView.frame = CGRect(x: 10, y: 20, width: backgroundImageView.frame.width - 20, height: backgroundImageView.frame.height - 30)
    }
    
    func show() -> Void {
        if let keyWindow = UIApplication.shared.keyWindow {
            if self.superview == nil {
                keyWindow.addSubview(self)
            }
            self.center = CGPoint(x: keyWindow.bounds.width * 0.5, y: keyWindow.bounds.height * 0.5)
        }
    }
    
    func hide() -> Void {
        self.removeFromSuperview()
    }

}

extension PannelTypeSelectPopView{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arr = arrCellData else {
            return 0
        }
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.textColor = UIColor.white
        cell!.textLabel?.text = arrCellData![indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.selectViewType == .pannelType && indexPath.row == arrCellData!.count - 1{
            let emailView = EmailRSSView(viewType: .customizeBoat)
            emailView.show()
        }else{
            if let closure = self.selectCousure {
                closure(self.selectViewType, indexPath.row)
            }
        }
        
    }
}
