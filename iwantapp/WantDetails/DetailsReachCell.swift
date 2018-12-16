//
//  DetailsReachCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 21.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit
import MessageUI

class DetailsReachCell: UITableViewCell, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    public var controller:UIViewController!
    var phone:String!
    var email:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func callWanter(_ sender: Any) {
        self.callPhone()
    }
    
    @IBAction func sendEmailWanter(_ sender: Any) {
        self.sendEmail()
    }
    
    private func callPhone(){
        print("Phone: " + phone.trimTrailingWhitespace().trim())
        let callphone = "tel://" + phone.trimTrailingWhitespace().trim()
        if let phoneCallURL = URL(string: callphone) {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL)
                }
            }
        }
    }
    
    @objc fileprivate func sendEmail(){
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            
            self.controller.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients([email])
        mailComposerVC.setSubject("Wanted App")
        
        let body = "Your wanted has received attention!" + "\n\n\n\n\n\n"
        
        mailComposerVC.setMessageBody(body, isHTML: false)
        
        return mailComposerVC
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension String {
    func trimTrailingWhitespace() -> String {
        if let trailingWs = self.range(of: "\\s+$", options: .regularExpression) {
            return self.replacingCharacters(in: trailingWs, with: "")
        } else {
            return self
        }
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

}
