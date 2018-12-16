//
//  NewWantContactCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 22.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

class NewWantContactCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    var wantActivity:WantActivity!
    var controller:NewWantController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        emailText.returnKeyType = .done
        emailText.delegate = self
        phoneText.returnKeyType = .next
        phoneText.delegate = self
        phoneText.keyboardType = UIKeyboardType.phonePad
        emailText.keyboardType = UIKeyboardType.emailAddress
        emailText.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == phoneText {
            emailText.becomeFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == self.phoneText){
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0{
                wantActivity.phone = ""
            }
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            let unformattedIndex = 0 as Int
            let unformattedString = NSMutableString()
            
            
            if hasLeadingOne {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@) ", areaCode)
                index += 3
            }
            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            unformattedString.append(decimalString.substring(from: unformattedIndex))
            textField.text = formattedString as String
        
            wantActivity.phone = unformattedString as String
            controller.checkSubmitButton()
            return false
        } else {
            return true
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if (textField == self.emailText){
            wantActivity.email = emailText.text!
            controller.checkSubmitButton()
        }
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isPhoneNumber() -> Bool {
        let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
}
