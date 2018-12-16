//
//  LoginViewController.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 2.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit


class LoginViewController: UIViewController, LoginViewDelegate {

    @IBOutlet weak var splashView: UIImageView!
    private var dict : [String : AnyObject]!
    private var indicator: UIActivityIndicatorView = UIActivityIndicatorView()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.desideViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkFacebookButton(){
        if User.sharedInstance.accessToken == ""{
            self.createFacebookLogin()
            self.createIndicator()
        }
    }
    
    private func desideViewController(){
        let accessToken = FBSDKAccessToken.current()
        if accessToken != nil && User.sharedInstance.accessToken != ""{
            
            getFBUserData(tokenString: (accessToken?.tokenString)!)
            
        }else{
            self.createFacebookLogin()
            self.createIndicator()
        }
    }
    
    func getFBUserData(tokenString:String){
        if((FBSDKAccessToken.current()) != nil){
            self.performSegue(withIdentifier: "loginMainSegue", sender: self)
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    User.sharedInstance.userId = self.dict["id"] as! String
                    if User.sharedInstance.email == ""{
                        User.sharedInstance.email = self.dict["email"] as! String
                    }
                    
                    User.sharedInstance.name = self.dict["name"] as! String
                    User.sharedInstance.accessToken = tokenString
                    User.sharedInstance.saveUserValues()
                    
                }
            })
        }
    }
    
    private func createFacebookLogin(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let buttonWidth = UIScreen.main.bounds.width - 75
        let buttonX = (UIScreen.main.bounds.width - buttonWidth) / 2
        let buttonHeight = CGFloat(64)
        let buttonY = (UIScreen.main.bounds.height - 164)
        
        let loginButton:UIButton = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight))
        loginButton.backgroundColor = .clear
        loginButton.addTarget(self, action:#selector(self.loginButtonClicked), for: .touchUpInside)
        let backgroundImage = UIImage(named: "login_facebook");
        loginButton.setImage(backgroundImage, for: .normal)
        view.addSubview(loginButton)
        view.bringSubview(toFront: loginButton)
        
    }
    
    private func createIndicator(){
        indicator.hidesWhenStopped = true;
        indicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.whiteLarge;
        
        self.indicator.color = UIColor.white
        self.view.addSubview(self.indicator)
        self.view.bringSubview(toFront: indicator)
        self.indicator.center = self.view.center
        indicator.stopAnimating()
    }
    
    @objc func loginButtonClicked() {
      
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _,  _):
                self.indicator.startAnimating()
                self.getFBUserData()
            }
        }
    }
    
    //function is fetching the user data
    //    {
    //        email = "sfa.alptekin@gmail.com";
    //        id = 345367215924404;
    //        name = "Ahmet Alptekin";
    //        picture =     {
    //            data =         {
    //            "is_silhouette" = 0;
    //            url = "https://scontent.xx.fbcdn.net/v/t1.0-1/19702374_304390783355381_6760321373964559784_n.jpg?oh=78af4b0737cb219fe9e62158732f0e0f&oe=5A867F5F";
    //            };
    //        };
    //    }
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(self.dict)
                    User.sharedInstance.userId = self.dict["id"] as! String
                    User.sharedInstance.email = self.dict["email"] as! String
                    User.sharedInstance.name = self.dict["name"] as! String
                    User.sharedInstance.accessToken = FBSDKAccessToken.current().tokenString
                    User.sharedInstance.saveUserValues()
                    POST.sharedInstance.callPostRegister(self.responseToRegister)
                    
                }
            })
        }
    }
    
    fileprivate func responseToRegister(_ data:Data?){
        do {
            let json = try JSON(data: data!)
            print(json)
            let error = json["error"]
            if error == nil{
                let city = json["result"]["city"].stringValue
                let country = json["result"]["country"].stringValue
                let emailPrefer = json["result"]["emailPrefer"].intValue
                let phonePrefer = json["result"]["phonePrefer"].intValue
                let phone = json["result"]["phone"].stringValue
                User.sharedInstance.city = city
                User.sharedInstance.country = country
                if emailPrefer == 1{
                    User.sharedInstance.emailPrefer = true
                }
                else{
                    User.sharedInstance.emailPrefer = false
                }
                if phonePrefer == 1{
                    User.sharedInstance.phonePrefer = true
                }
                else{
                    User.sharedInstance.phonePrefer = false
                }
                User.sharedInstance.phone = phone
                let wants = json["result"]["wantList"].arrayValue
                if wants.count > 0{
                    for i in 0 ..< wants.count
                    {
                        let wantId =  wants[i]["id"].int64Value
                        let want = wants[i]["want"].stringValue
                        let category = wants[i]["category"].intValue
                        let phone = wants[i]["phone"].stringValue
                        let email = wants[i]["email"].stringValue
                        let minPrice = wants[i]["minPrice"].doubleValue
                        let maxPrice = wants[i]["maxPrice"].doubleValue
                        let description = wants[i]["description"].stringValue
                        let city = wants[i]["city"].stringValue
                        let country = wants[i]["country"].stringValue
                        let currency = wants[i]["country"].stringValue
                        let emailPrefer = wants[i]["emailPrefer"].intValue
                        let phonePrefer = wants[i]["phonePrefer"].intValue
                        let act = WantActivity(want: want, category: category, phone: phone, email: email, minPrice: minPrice, maxPrice: maxPrice, city: city, country: country, currency:currency, description: description, emailPrefer:emailPrefer, phonePrefer:phonePrefer)
                        act.id = wantId
                        User.sharedInstance.addActivity(wantActivity: act)
                    }
                }
                
                User.sharedInstance.saveUserValues()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.indicator.stopAnimating()
                    self.performSegue(withIdentifier: "loginMainSegue", sender: self)
                })
               
            }
            else{
                
            }
        } catch {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "loginMainSegue"){
            if let controller:MainViewController = segue.destination as? MainViewController{
              controller.loginViewDelegate = self
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
