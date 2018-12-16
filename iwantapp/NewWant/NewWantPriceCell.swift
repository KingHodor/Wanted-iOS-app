//
//  NewWantPriceCell.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 22.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

struct Constants {
    static let MAX_BEFORE_DECIMAL_DIGITS = 8
    static let MAX_AFTER_DECIMAL_DIGITS = 1
}
class NewWantPriceCell: UITableViewCell, UITextFieldDelegate  {

    @IBOutlet weak var maxText: UITextField!
    @IBOutlet weak var minText: UITextField!
    var wantActivity:WantActivity!
    
    @IBOutlet weak var countLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        minText.returnKeyType = .done
        maxText.returnKeyType = .done
        minText.delegate = self
        maxText.delegate = self
        minText.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        maxText.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.minText.text = "100.0"
        self.maxText.text = "2000.0"
        minText.keyboardType = .decimalPad
        maxText.keyboardType = .decimalPad
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if textField == minText {
            if minText.text != ""{
               self.wantActivity.minPrice = Double(minText.text!)
            }
            else{
               self.wantActivity.minPrice = Double(-1)
            }
            
        }else  if textField == maxText {
            if maxText.text != ""{
                 self.wantActivity.maxPrice = Double(maxText.text!)
            }
            else{
                 self.wantActivity.maxPrice = Double(-1)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let computationString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        // Take number of digits present after the decimal point.
        let arrayOfSubStrings = computationString.components(separatedBy: ".")
        
        if arrayOfSubStrings.count == 1 && computationString.characters.count > Constants.MAX_BEFORE_DECIMAL_DIGITS {
            return false
        } else if arrayOfSubStrings.count == 2 {
            let stringPostDecimal = arrayOfSubStrings[1]
            return stringPostDecimal.characters.count <= Constants.MAX_AFTER_DECIMAL_DIGITS
        }
        
        return true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
