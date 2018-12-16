//
//  User.swift
//  iwantapp
//
//  Created by Ahmet Alptekin on 2.10.2017.
//  Copyright © 2017 IWANT. All rights reserved.
//

import Foundation
import UIKit


struct defaultsUserKeys {
    static let keyUserEmail = "userEmail"
    static let keyUserId = "userId"
    static let keyUserName = "userName"
    static let keyUserAccessToken = "userAccessToken"
    static let keyCity = "userCity"
    static let keyCountry = "userCountry"
    static let keyLatitude = "userLatitudey"
    static let keyLongitude = "userLongitude"
    static let keyPhone = "userPhone"
    static let keyPhonePrefer = "userPhonePrefer"
    static let keyEmailPrefer = "userEmailPrefer"
    static let keyServerRequest = "serverRequest"
     static let keyActivityList = "activityList"
}

class User {
    
    public static var sharedInstance = User()
    
    var activityList:[WantActivity] = []
    var email: String = ""
    var userId: String = ""
    var name: String = ""
    var phone: String = ""
    var accessToken:String = ""
    var latitude: Float = 0.0
    var longitude:Float = 0.0
    var picture: UIImage = UIImage()
    var city:String = ""
    var country:String = ""
    var phonePrefer:Bool = true // email & phone = 3, email = 1, phone = 2
    var emailPrefer:Bool = true // email & phone = 3, email = 1, phone = 2
    var serverRequest:Bool = false
    
    func saveUserValues() {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: defaultsUserKeys.keyUserEmail)
        defaults.set(userId, forKey: defaultsUserKeys.keyUserId)
        defaults.set(name, forKey: defaultsUserKeys.keyUserName)
        defaults.set(accessToken, forKey: defaultsUserKeys.keyUserAccessToken)
        defaults.set(city, forKey: defaultsUserKeys.keyCity)
        defaults.set(country, forKey: defaultsUserKeys.keyCountry)
        defaults.set(phone, forKey: defaultsUserKeys.keyPhone)
        defaults.set(phonePrefer, forKey: defaultsUserKeys.keyPhonePrefer)
        defaults.set(emailPrefer, forKey: defaultsUserKeys.keyEmailPrefer)
        defaults.set(latitude, forKey: defaultsUserKeys.keyLatitude)
        defaults.set(longitude, forKey: defaultsUserKeys.keyLongitude)
        defaults.set(serverRequest, forKey: defaultsUserKeys.keyServerRequest)
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: activityList)
        defaults.set(encodedData, forKey: defaultsUserKeys.keyActivityList)
    }
    
    public func loadUserValues(){
        let defaults = UserDefaults.standard
        if let email = defaults.string(forKey: defaultsUserKeys.keyUserEmail) {
            self.email = email
        }
        if let userId = defaults.string(forKey: defaultsUserKeys.keyUserId) {
            self.userId = userId
        }
        if let name = defaults.string(forKey: defaultsUserKeys.keyUserName) {
            self.name = name
        }
        if let accessToken = defaults.string(forKey: defaultsUserKeys.keyUserAccessToken) {
            self.accessToken = accessToken
        }
        if let city = defaults.string(forKey: defaultsUserKeys.keyCity) {
            self.city = city
        }
        if let country = defaults.string(forKey: defaultsUserKeys.keyCountry) {
            self.country = country
        }
        if let phone = defaults.string(forKey: defaultsUserKeys.keyPhone) {
            self.phone = phone
        }
        
        self.phonePrefer = defaults.bool(forKey: defaultsUserKeys.keyPhonePrefer)
        self.emailPrefer = defaults.bool(forKey: defaultsUserKeys.keyEmailPrefer)
        self.latitude = defaults.float(forKey: defaultsUserKeys.keyLatitude)
        self.longitude = defaults.float(forKey: defaultsUserKeys.keyLongitude)
        self.serverRequest = defaults.bool(forKey: defaultsUserKeys.keyServerRequest)
        
        if let decodedData  = defaults.object(forKey: defaultsUserKeys.keyActivityList) as? Data
        {
            let decodedWants = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as! [WantActivity]
            for wantActivity in decodedWants
            {
                self.activityList.append(wantActivity)
            }
        }
    }
    
    public func addActivity(wantActivity: WantActivity){
       activityList.append(wantActivity)
    }
    
    public func clearAllData(){
        self.activityList.removeAll()
        self.accessToken = ""
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = User()
        copy.activityList = activityList
        print(email)
        copy.email = email
        copy.userId = userId
        copy.name = name
        copy.phone = phone
        copy.accessToken = accessToken
        copy.latitude = latitude
        copy.longitude = longitude
        copy.picture = picture
        copy.city = city
        copy.country = country
        copy.phonePrefer = phonePrefer // email & phone = 3, email = 1, phone = 2
        copy.emailPrefer = emailPrefer// email & phone = 3, email = 1, phone = 2
        copy.serverRequest = serverRequest
        
        return copy
    }
}
