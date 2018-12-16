//
//  SettingsController.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 21.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleMobileAds

protocol SettingsControllerDelegate: class {
    func logoutFromMainView()
    func updateLocation()
}

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, SelectLocationDelegate, EditWantDelegate  {
    
    @IBOutlet weak var admobBanner: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    private var indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var tempUser:User = User()
    private var logoutPopup:CNPPopupController?
    weak var settingsControllerDelegate: SettingsControllerDelegate? = nil
    var hasChangedLocation = false
    private var errorPopup:CNPPopupController?
    private var isErrorDialogOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designTableView()
        self.createIndicator()
        self.adMobBanner()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // self.checkWantsFromServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func adMobBanner(){
        admobBanner.adUnitID = "ca-app-pub-4718763794985958/6843155589"
        admobBanner.rootViewController = self
        //self.view.addSubview(admobBanner)
        var request: GADRequest = GADRequest()
        admobBanner.load(request)
    }
    
    private func checkWantsFromServer(){
        if tempUser.serverRequest == false {
            indicator.startAnimating()
            GET.sharedInstance.callOwnWants(responseToWants)
        }
    }
    
    fileprivate func responseToWants(_ data:Data?){
        do {
            let json = try JSON(data: data!)
            print(json)
            let error = json["error"]
            if error == nil{
                let result = json["result"].arrayValue
                if result.count > 0{
                    for i in 0 ..< result.count
                    {
                        let wantId =  result[i]["id"].int64Value
                        let want = result[i]["want"].stringValue
                        let category = result[i]["category"].intValue
                        let phone = result[i]["phone"].stringValue
                        let email = result[i]["email"].stringValue
                        let minPrice = result[i]["minPrice"].doubleValue
                        let maxPrice = result[i]["maxPrice"].doubleValue
                        let description = result[i]["description"].stringValue
                        let city = result[i]["city"].stringValue
                        let country = result[i]["country"].stringValue
                        let currency = result[i]["country"].stringValue
                        let emailPrefer = result[i]["emailPrefer"].intValue
                        let phonePrefer = result[i]["phonePrefer"].intValue
                        let act = WantActivity(want: want, category: category, phone: phone, email: email, minPrice: minPrice, maxPrice: maxPrice, city: city, country: country, currency:currency, description: description, emailPrefer:emailPrefer, phonePrefer:phonePrefer)
                        act.id = wantId
                        tempUser.addActivity(wantActivity:act)
                        User.sharedInstance.addActivity(wantActivity: act)
                    }
                }
                User.sharedInstance.serverRequest = true
                tempUser.serverRequest = true
                User.sharedInstance.saveUserValues()
            }
            else{
                
            }
        } catch {
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.indicator.stopAnimating()
            self.tableView.reloadData()
        })
    }
    
    private func designTableView(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardDidHide, object: nil)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tempUser = User.sharedInstance.copy() as! User
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
        return 7 + tempUser.activityList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.item
        if index == 0 {
            let cell:SettingsBasicCell = tableView.dequeueReusableCell(withIdentifier: "SettingsBasicCell") as! SettingsBasicCell
            cell.titleLabel.text = "NAME AND SURNAME"
            cell.cellText.text = tempUser.name
            cell.isNameText = true
            cell.controller = self
            cell.designCell()
            return cell
        }
        else if index == 1 {
            let cell:SettingsBasicCell = tableView.dequeueReusableCell(withIdentifier: "SettingsBasicCell") as! SettingsBasicCell
            cell.titleLabel.text = "PHONE NUMBER"
            if tempUser.phone != nil && tempUser.phone != ""{
                cell.cellText.text = format(phoneNumber: tempUser.phone)
            }
            cell.controller = self
            cell.isPhoneText = true
            cell.designCell()
            return cell
        }
        else if index == 2 {
            let cell:SettingsBasicCell = tableView.dequeueReusableCell(withIdentifier: "SettingsBasicCell") as! SettingsBasicCell
            cell.titleLabel.text = "E-MAIL ADDRESS"
            cell.cellText.text = tempUser.email
            cell.isEmailText = true
            cell.controller = self
            cell.designCell()
            return cell
        }
        else if index == 3 {
            let cell:SettingsContactCell = tableView.dequeueReusableCell(withIdentifier: "SettingsContactCell") as! SettingsContactCell
            if tempUser.emailPrefer == true{
                cell.emailButton.isOn = true
            }else{
                cell.emailButton.isOn = false
            }
            
            if tempUser.phonePrefer == true{
                cell.phoneButton.isOn = true
            }else{
                cell.phoneButton.isOn = false
            }
            cell.controller = self
            return cell
        }
        else if index == 4 {
            let cell:SettingsLocationCell = tableView.dequeueReusableCell(withIdentifier: "SettingsLocationCell") as! SettingsLocationCell
            cell.locationButton.setTitle(tempUser.city + ", " + tempUser.country, for: .normal) //.text = tempUser.city + ", " + tempUser.country
            cell.viewController = self
            return cell
        }
        else if index == 5 {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingsWantTitleCell")!
            return cell
        }
        else if index == 6 + tempUser.activityList.count {
            let cell:SettingsLogoutCell = tableView.dequeueReusableCell(withIdentifier: "SettingsLogoutCell") as! SettingsLogoutCell
            cell.settingsController = self
            return cell
        }
        else{
            let index = indexPath.item - 6
            let wantActivity:WantActivity = tempUser.activityList[index]
            let cell:SettingsWantCell = tableView.dequeueReusableCell(withIdentifier: "SettingsWantCell") as! SettingsWantCell
            let id = wantActivity.category
            if let category = CategoryData.sharedInstance.categoryList[id!]{
                cell.iconView.image = category.c_image
            }
            cell.wantText.text = wantActivity.want
            cell.controller = self
            cell.indexPath = indexPath
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height :CGFloat = 0.0
        let index = indexPath.item
        if index == 0 {
            height = CGFloat(84.0)
        }
        else if index == 1 {
            height = CGFloat(84.0)
        }
        else if index == 2 {
            height = CGFloat(84.0)
        }
        else if index == 3 {
            height = CGFloat(127.0)
        }
        else if index == 4 {
            height = CGFloat(84.0)
        }
        else if index == 5 {
            height = CGFloat(34.0)
        }
        else if index == 6 + tempUser.activityList.count {
            height = CGFloat(64.0)
        }
        else{
            height = CGFloat(65.0)
        }
        return height
    }
    
    public func deleteActivity(indexPath:IndexPath){
        self.indicator.startAnimating()
        let activity:WantActivity = tempUser.activityList[indexPath.item - 6]
        POST.sharedInstance.callDeactivateWant(activity.id, indexPath: indexPath,  done: responseToDeactive)
    }
    
    public func editActivity(indexPath:IndexPath){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popup =  storyboard.instantiateViewController(withIdentifier: "NewWantController") as? NewWantController
        let activity:WantActivity = tempUser.activityList[indexPath.item - 6]
        popup?.modalPresentationStyle = .currentContext
        popup?.modalTransitionStyle = .coverVertical
        popup?.type = 1
        popup?.wantActivity = activity.wantCopy()
        popup?.editWantDelegate = self
        popup?.indexPath = indexPath
        self.present(popup!, animated:true, completion: nil)
    }
    
    
    fileprivate func responseToDeactive(_ data:Data?, wantId:Int64?, indexPath:IndexPath? ){
        do {
            let json = try JSON(data: data!)
            print(json)
            let error = json["error"]
            if error == nil{
                let result = json["result"]
                print(result)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    User.sharedInstance.activityList.remove(at: (indexPath?.item)! - 6)
                    self.tempUser.activityList.remove(at: (indexPath?.item)! - 6)
                    
                    self.tableView.reloadData()
                    User.sharedInstance.saveUserValues()
                })
            }
            else{
                
            }
        } catch {
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.indicator.stopAnimating()
        })
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
    
    @IBAction func handleForwardButton(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func handleSaveButton(_ sender: Any) {
        
        if ((tempUser.email.isValidEmail()) == false) {
            errorDialog("The e-mail you entered does not follow a valid format. Please re-enter the e-mail using a valid format (i.e., name@example.ie).")
            return
        }
        
        if tempUser.phone.isPhoneNumber() == false {
            errorDialog("The telephone number you entered does not follow a valid format. Please re-enter 10 digits phone number including your area code.")
            return
        }
        
        if tempUser.name == "" {
            errorDialog("Your name can not be empty.")
            return
        }
        if tempUser.emailPrefer == false && tempUser.phonePrefer == false{
            errorDialog("You must select at least one contact information (phone number or e-mail address).")
            return
        }
        
        self.indicator.startAnimating()
        POST.sharedInstance.callPutUpdate(tempUser.name, userEmail: tempUser.email, userPhone: tempUser.phone, city: tempUser.city, country: tempUser.country,  emailPrefer:tempUser.emailPrefer, phonePrefer:tempUser.phonePrefer, done: self.responseToUpdate)
    }
    
    private func checkYourValues(){
        if ((User.sharedInstance.email.isValidEmail()) == false) {
            return
        }
        
        if User.sharedInstance.phone.isPhoneNumber() == false {
            return
        }
        
        if User.sharedInstance.name == "" {
            return
        }
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
    
    private func rawPhoneNumber() -> String{
        let rawPhone = ""
        
        return rawPhone
    }
    
    fileprivate func responseToUpdate(_ data:Data?){
        do {
            let json = try JSON(data: data!)
            print(json)
            let error = json["error"]
            if error == nil{
                let result = json["result"]
                print(result)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    User.sharedInstance.name = self.tempUser.name
                    User.sharedInstance.email = self.tempUser.email
                    User.sharedInstance.phone = self.tempUser.phone
                    User.sharedInstance.city = self.tempUser.city
                    User.sharedInstance.country = self.tempUser.country
                    User.sharedInstance.emailPrefer = self.tempUser.emailPrefer
                    User.sharedInstance.phonePrefer = self.tempUser.phonePrefer
                    for i in 0 ..< self.tempUser.activityList.count
                    {
                        self.tempUser.activityList[i].email = self.tempUser.email
                        self.tempUser.activityList[i].phone = self.tempUser.phone
                    }
                    User.sharedInstance.saveUserValues()
                    self.indicator.stopAnimating()
                    if self.hasChangedLocation == true{
                      self.settingsControllerDelegate?.updateLocation()
                    }
                    self.dismiss(animated: true, completion: nil)
                })
            }
            else{
                
            }
        } catch {
            
        }
    }
    
    public func logOut(){
        self.dismiss(animated: true, completion: nil)
        self.settingsControllerDelegate?.logoutFromMainView()
    }
    
    
    public func openLogoutPopup() {
        
        let width = (UIApplication.shared.keyWindow?.bounds.width)! * 0.70
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyle.alignment = NSTextAlignment.center
        
        let title = NSAttributedString(string: "Are you sure?", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.paragraphStyle: paragraphStyle])
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2;
        titleLabel.attributedText = title
        
        let buttonView = UIView(frame:  CGRect(x: 0, y: 0, width: width, height: 50))
        
        let applyButton = CNPPopupButton.init(frame: CGRect(x: width/9, y: 20, width: width/3, height: 30))
        applyButton.setTitleColor(UIColor(red: 20/255, green: 141/255, blue: 210/255, alpha: 1), for: UIControlState())
        applyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        applyButton.setTitle("Sign Out", for: UIControlState())
        applyButton.selectionHandler = { (button) -> Void in
            self.logoutPopup?.dismiss(animated: true)
            self.logOut()
       
        }
        applyButton.backgroundColor = UIColor.clear
        applyButton.layer.cornerRadius = 10
        applyButton.layer.masksToBounds = true
        
        buttonView.addSubview(applyButton)
        
        let cancelButton = CNPPopupButton.init(frame: CGRect(x: (width * 5)/9, y: 20, width: width/3, height: 30))
        cancelButton.setTitleColor(UIColor(red: 20/255, green: 141/255, blue: 210/255, alpha: 1), for: UIControlState())
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cancelButton.setTitle("Cancel", for: UIControlState())
        cancelButton.selectionHandler = { (button) -> Void in
            //CANCEL
            self.logoutPopup?.dismiss(animated: true)
        }
        cancelButton.backgroundColor =  UIColor.clear
        
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.masksToBounds = true
        
        buttonView.addSubview(cancelButton)
        
        let popupController = CNPPopupController(contents:[titleLabel, buttonView])
        popupController.theme = CNPPopupTheme.default()
        popupController.theme.backgroundColor = UIColor.groupTableViewBackground
        
        popupController.theme.popupStyle = .centered
        popupController.delegate = self
        self.logoutPopup = popupController
        popupController.present(animated: true)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    
    func selectLocation(_ result: String){
        let results = result.components(separatedBy: ", ")
        self.tempUser.city = results[0]
        self.tempUser.country = results[results.count - 1]
        hasChangedLocation = true
        tableView.reloadData()
    }
    
    func editDone(_wantActivity wantActivity:WantActivity, indexPath: IndexPath){
        User.sharedInstance.activityList[(indexPath.item) - 6] = wantActivity.wantCopy()
        self.tempUser.activityList[(indexPath.item) - 6] = wantActivity
        User.sharedInstance.saveUserValues()
        self.tableView.reloadData()
    }
}

extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.fillMode = kCAFillModeRemoved;
        view.window!.layer.add(transition, forKey: nil)
        self.present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        transition.fillMode = kCAFillModeRemoved;
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.dismiss(animated: false, completion: nil)
    }
}

extension SettingsController : CNPPopupControllerDelegate {
    
    internal func popupControllerWillDismiss(_ controller: CNPPopupController) {
        print("Popup controller will be dismissed")
    }
    
    internal func popupControllerDidPresent(_ controller: CNPPopupController) {
        print("Popup controller presented")
    }
}
