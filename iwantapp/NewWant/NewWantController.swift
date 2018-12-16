//
//  NewWantController.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 21.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit

protocol EditWantDelegate: class {
    func editDone(_wantActivity:WantActivity, indexPath: IndexPath)
}

class NewWantController: UIViewController, UITableViewDelegate, UITableViewDataSource, SelectLocationDelegate, SelectCategoryDelegate  {
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var wantActivity:WantActivity!
    private var indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    private var errorPopup:CNPPopupController?
    private var isErrorDialogOpen = false
    public var type:Int = 0 // 0: submit,  1: edit
    weak var editWantDelegate: EditWantDelegate? = nil
    var indexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designTableView()
        self.createIndicator()
        self.fillDefaultAttributes()
        self.checkSubmitButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fillDefaultAttributes(){
        if type == 0 {
            wantActivity = WantActivity()
            wantActivity.city = User.sharedInstance.city
            wantActivity.country = User.sharedInstance.country
            if User.sharedInstance.phone != "" {
                wantActivity.phone = User.sharedInstance.phone
            }
            else{
                wantActivity.phone = ""
            }
            
            if User.sharedInstance.email != "" {
                wantActivity.email = User.sharedInstance.email
            }
            else{
                wantActivity.email = ""
            }
            wantActivity.latitude = User.sharedInstance.latitude
            wantActivity.longitude = User.sharedInstance.longitude
            wantActivity.category = -1
            wantActivity.minPrice = 100.0
            wantActivity.maxPrice = 2000.0
            actionButton.setTitle("SUBMIT YOUR WANTED", for: .normal)
        }else{
            actionButton.setTitle("EDIT YOUR WANTED", for: .normal)
        }
    }
    
    private func designTableView(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardDidHide, object: nil)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func createIndicator(){
        indicator.hidesWhenStopped = true;
        indicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.whiteLarge;
        
        self.indicator.color = UIColor(red: 20/255, green: 141/255, blue: 210/255, alpha: 1)
        self.view.addSubview(self.indicator)
        self.view.bringSubview(toFront: indicator)
        self.indicator.center = self.view.center
        indicator.stopAnimating()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        if index == 0 {
            let cell:NewWantBasicCell = tableView.dequeueReusableCell(withIdentifier: "NewWantBasicCell") as! NewWantBasicCell
            cell.title.text = "I WANT TO"
            cell.wantActivity = self.wantActivity
            cell.isWantText = true
            if type == 1{
                cell.textField.text = wantActivity.want
            }
            cell.controller = self
            return cell
        }
        else if index == 1 {
            let cell:NewWantPriceCell = tableView.dequeueReusableCell(withIdentifier: "NewWantPriceCell") as! NewWantPriceCell
            cell.wantActivity = self.wantActivity
            return cell
        }
        else if index == 2 {
            let cell:NewWantCategoryCell = tableView.dequeueReusableCell(withIdentifier: "NewWantCategoryCell") as! NewWantCategoryCell
            cell.cellLabel.text = "CATEGORY"
            cell.viewController = self
            if wantActivity.category > 0{
                if let categoryText =  CategoryData.sharedInstance.categoryList[wantActivity.category]?.name
                {
                    cell.openViewButton.setTitle(categoryText, for: UIControlState())
                    cell.openViewButton.setTitleColor(UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1), for: .normal)
                }
            }
            else{
                cell.openViewButton.setTitle("Select your category.", for: UIControlState())
                cell.openViewButton.setTitleColor(UIColor.red, for: .normal)
            }
            
            cell.type = "category"
            return cell
        }
        else if index == 3 {
            let cell:NewWantCategoryCell = tableView.dequeueReusableCell(withIdentifier: "NewWantCategoryCell") as! NewWantCategoryCell
            cell.cellLabel.text = "LOCATION"
            cell.openViewButton.setTitle(self.wantActivity.city + ", " +  self.wantActivity.country, for: UIControlState())
            cell.viewController = self
            cell.type = "location"
            return cell
        }
        else if index == 4 {
            let cell:NewWantBasicCell = tableView.dequeueReusableCell(withIdentifier: "NewWantBasicCell") as! NewWantBasicCell
            cell.title.text = "ANYTHING ELSE?"
            cell.wantActivity = self.wantActivity
            cell.isAnyThingText = true
            cell.controller = self
            if type == 1{
                cell.textField.text = wantActivity.descript
            }
            return cell
        }
        else if index == 5 {
            let cell:NewWantContactCell = tableView.dequeueReusableCell(withIdentifier: "NewWantContactCell") as! NewWantContactCell
            if User.sharedInstance.email != ""{
                cell.emailText.text = wantActivity.email
            }
            if User.sharedInstance.phone != ""{
                cell.phoneText.text = format(phoneNumber: wantActivity.phone)
            }
            cell.wantActivity = self.wantActivity
            cell.controller = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height :CGFloat = 0.0
        if indexPath.item == 5 {
            height = CGFloat(107)
        }
        else{
            height = CGFloat(84)
        }
        return height
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            // For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func handleDismissButton(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func submitWantAction(_ sender: Any) {
        if wantActivity.want == nil || wantActivity.want == "" {
            errorDialog("Your want can not be empty")
            return
        }
        
        print(wantActivity.email)
        print(wantActivity.phone)
        if (wantActivity.email == "") && (wantActivity.phone == "") {
            errorDialog("You must provide at least one contact information (phone number or e-mail address).")
            return
        }
        
        if isMinusOs(wantActivity.minPrice) == true{
            errorDialog("Minimum price can not be empty.")
            return
        }
        
        if isMinusOs(wantActivity.maxPrice) == true {
            errorDialog("Maximum price can not be empty.")
            return
        }
        
        if wantActivity.minPrice > wantActivity.maxPrice {
            errorDialog("Minimum price can not be greater then Maximum price.")
            return
        }
        
        if wantActivity.category == -1{
            errorDialog("Please select a category.")
            return
        }
        
        if wantActivity.email != "" && wantActivity.email.isValidEmail() == false{
            errorDialog("The e-mail you entered does not follow a valid format. Please re-enter the e-mail using a valid format (i.e., name@example.ie).")
            return
        }
        
        if wantActivity.phone != "" && wantActivity.phone.isPhoneNumber() == false {
            errorDialog("The telephone number you entered does not follow a valid format. Please re-enter 10 digits phone number including your area code.")
            return
        }
        
        self.gotoSubmit()
    }
    
    func isMinusOs(_ a: Double) -> Bool {
        let b:Double = -1
        return fabs(a - b) < Double.ulpOfOne
    }
    
    func errorDialog(_ title: String)
    {
        if isErrorDialogOpen == false
        {
            isErrorDialogOpen = true
            let width = (UIApplication.shared.keyWindow?.bounds.width)! * 0.70
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
            paragraphStyle.alignment = .center
            
            let title = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedStringKey.paragraphStyle: paragraphStyle])
            let titleLabel = UILabel()
            titleLabel.numberOfLines = 5;
            titleLabel.attributedText = title
            
            let okButton = CNPPopupButton.init(frame: CGRect(x: 0, y: 0, width: (width/3) , height: 30))
            okButton.setTitleColor(UIColor.white, for: UIControlState())
            okButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            okButton.setTitle("OK", for: UIControlState())
            okButton.selectionHandler = { (button) -> Void in
                //CANCEL
                self.isErrorDialogOpen = false
                self.errorPopup?.dismiss(animated: true)
            }
            okButton.backgroundColor =  UIColor(red: 20/255, green: 141/255, blue: 210/255, alpha: 1)
            
            okButton.layer.cornerRadius = 10
            okButton.layer.masksToBounds = true
            
            
            let popupController = CNPPopupController(contents:[titleLabel, okButton])
            popupController.theme = CNPPopupTheme.default()
            popupController.theme.backgroundColor = UIColor.groupTableViewBackground
            
            popupController.theme.popupStyle = .centered
            popupController.delegate = self
            self.errorPopup = popupController
            popupController.present(animated: true)
        }
    }
    
    private func gotoSubmit(){
        self.indicator.startAnimating()
        if type == 0 {
            POST.sharedInstance.callPostSubmit(self.wantActivity, done: responseToSubmit)
        }else{
            POST.sharedInstance.callPostEdit(self.wantActivity, done: responseToEdit)
        }
        
    }
    
    fileprivate func responseToSubmit(_ data:Data?){
        do {
            let json = try JSON(data: data!)
            print(json)
            let error = json["error"]
            if error == nil{
                let result = json["result"].int64
                if result != 0
                {
                    self.wantActivity.id = result
                    User.sharedInstance.addActivity(wantActivity: self.wantActivity)
                    User.sharedInstance.saveUserValues()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.indicator.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    })
                }
                
            }
            else{
                
            }
        } catch {
            
        }
    }
    
    fileprivate func responseToEdit(_ data:Data?){
        do {
            let json = try JSON(data: data!)
            print(json)
            let error = json["error"]
            if error == nil{
                let result = json["result"].boolValue
                if result == true
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.indicator.stopAnimating()
                        self.editWantDelegate?.editDone(_wantActivity: self.wantActivity, indexPath: self.indexPath)
                        self.dismiss(animated: true, completion: nil)
                    })
                }
                
            }
            else{
                
            }
        } catch {
            
        }
    }
    
    func selectLocation(_ result: String){
        let results = result.components(separatedBy: ", ")
        self.wantActivity.city = results[0]
        self.wantActivity.country = results[results.count - 1]
        tableView.reloadData()
    }
    
    func selectCategory(_ categoryId: Int){
        self.wantActivity.category = categoryId
        tableView.reloadData()
    }
    
    public func checkSubmitButton() {
        
    }
    
    func format(phoneNumber sourcePhoneNumber: String) -> String? {
        
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.characters.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.characters.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        
        return leadingOne + areaCode + prefix + "-" + suffix
    }
}

extension NewWantController : CNPPopupControllerDelegate {
    
    internal func popupControllerWillDismiss(_ controller: CNPPopupController) {
        print("Popup controller will be dismissed")
    }
    
    internal func popupControllerDidPresent(_ controller: CNPPopupController) {
        print("Popup controller presented")
    }
}
