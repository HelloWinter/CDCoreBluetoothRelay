//
//  CDSendEmailManager.swift
//  CDCoreBluetoothRelay
//
//  Created by dong cheng on 2018/3/18.
//  Copyright © 2018年 dong cheng. All rights reserved.
//

import UIKit
import MessageUI

class CDSendEmailManager: NSObject,MFMailComposeViewControllerDelegate {
    
    weak var delegate : UIViewController?
    
    var didSentEmailClosure : (() -> Void)?
    
    private lazy var mailComposeVC : MFMailComposeViewController = {
        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = self
        return controller
    }()
    
    override init() {
        super.init()
    }
    
    /// 发送邮件
    ///
    /// - Parameters:
    ///   - recipients: 收件人
    ///   - subject: 主题
    ///   - bccRecipients: 密送,默认无
    ///   - ccRecipients: 抄送,默认无
    ///   - messageBody: 邮件内容
    ///   - isHTML: 邮件内容是否是html,默认false
    func sendEmail(recipients : [String],subject : String,bccRecipients : [String]? = nil,ccRecipients : [String]? = nil,messageBody : String,isHTML : Bool = false) -> Void {
        if !MFMailComposeViewController.canSendMail() {
            CDAutoHideMessageHUD.showMessage(NSLocalizedString("SetAccount", comment: ""))
            return
        }
        mailComposeVC.setToRecipients(recipients)
        mailComposeVC.setSubject(subject)
        mailComposeVC.setBccRecipients(bccRecipients)
        mailComposeVC.setCcRecipients(ccRecipients)
        mailComposeVC.setMessageBody(messageBody, isHTML: isHTML)
        ///添加附件,暂时未用到
//        mailComposeVC.addAttachmentData(<#T##attachment: Data##Data#>, mimeType: <#T##String#>, fileName: <#T##String#>)
        delegate?.present(mailComposeVC, animated: true, completion: {
            
        })
    }
}

extension CDSendEmailManager{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            CDAutoHideMessageHUD.showMessage(error.localizedDescription)
        }
        switch result {
        case .cancelled:
            CDAutoHideMessageHUD.showMessage(NSLocalizedString("EmailCancelled", comment: ""))
        case .failed:
            CDAutoHideMessageHUD.showMessage(NSLocalizedString("EmailFailed", comment: ""))
        case .saved:
            CDAutoHideMessageHUD.showMessage(NSLocalizedString("EmailSaved", comment: ""))
        case .sent:
            CDAutoHideMessageHUD.showMessage(NSLocalizedString("EmailSent", comment: ""))
            if let closure = self.didSentEmailClosure {
                closure()
            }
        }
        delegate?.dismiss(animated: true, completion: {
            
        })
    }
}
