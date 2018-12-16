

import Foundation
import Alamofire
import AdSupport

class POST:NSObject
{
    static let sharedInstance = POST()
    
   
    func callPostRegister(_ done: @escaping (Data?) -> ())
    {
        let userId = User.sharedInstance.userId
        let email = User.sharedInstance.email
        let name = User.sharedInstance.name
        let token = User.sharedInstance.accessToken
        let url = serviceURL + "register"
     
        let params = ["userId" : userId, "name": name, "email": email, "token":token]
        print(params)
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                done(response.data)
        }
    }
    
    func callPutUpdate(_ userName:String, userEmail:String, userPhone:String, city:String, country:String, emailPrefer:Bool, phonePrefer:Bool, done: @escaping (Data?) -> ())
    {
        let url = serviceURL + "update"
        let headers: HTTPHeaders = [
            "X-AUTH-TOKEN": User.sharedInstance.accessToken,
            "Content-Type": "application/json"
        ]
        var params:[String:Any] = [:]
        if userName != "" {
            params["name"] = userName
        }
        if userEmail != "" {
            params["email"] = userEmail
        }
        if userPhone != "" {
            params["phone"] = userPhone
        }
        if city != "" {
            params["city"] = city
        }
        if country != "" {
            params["country"] = country
        }
        
        if emailPrefer == true {
           params["emailPrefer"] = 1
        }else {
           params["emailPrefer"] = 0
        }
        
        if phonePrefer == true {
            params["phonePrefer"] = 1
        }else {
            params["phonePrefer"] = 0
        }
        
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headers)
            .responseJSON { response in
                done(response.data)
        }
    }
    
    func callPostSubmit(_ wantActiviy:WantActivity, done: @escaping (Data?) -> ())
    {
        let url = serviceURL + "submit"
        let headers: HTTPHeaders = [
            "X-AUTH-TOKEN": User.sharedInstance.accessToken,
            "Content-Type": "application/json"
        ]
        var params:[String:Any] = [:]
        params["want"] = wantActiviy.want
        params["category"] = wantActiviy.category
        if wantActiviy.phone != nil || wantActiviy.phone != ""{
           params["phone"] = wantActiviy.phone
        }
        if wantActiviy.email != nil || wantActiviy.email != ""{
             params["email"] = wantActiviy.email
        }
       
        params["minPrice"] = wantActiviy.minPrice
        params["maxPrice"] = wantActiviy.maxPrice
        params["description"] = wantActiviy.descript
        params["latitude"] = wantActiviy.latitude
        params["longitude"] = wantActiviy.longitude
        params["city"] = wantActiviy.city
        params["country"] = wantActiviy.country
        print(params)
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headers)
            .responseJSON { response in
                done(response.data)
        }
    }
    
    func callPostEdit(_ wantActiviy:WantActivity, done: @escaping (Data?) -> ())
    {
        let url = serviceURL + "edit"
        let headers: HTTPHeaders = [
            "X-AUTH-TOKEN": User.sharedInstance.accessToken,
            "Content-Type": "application/json"
        ]
        var params:[String:Any] = [:]
        params["wantId"] = wantActiviy.id
        params["want"] = wantActiviy.want
        params["category"] = wantActiviy.category
        if wantActiviy.phone != nil || wantActiviy.phone != ""{
            params["phone"] = wantActiviy.phone
        }
        if wantActiviy.email != nil || wantActiviy.email != ""{
            params["email"] = wantActiviy.email
        }
        
        params["minPrice"] = wantActiviy.minPrice
        params["maxPrice"] = wantActiviy.maxPrice
        params["description"] = wantActiviy.descript
        params["latitude"] = wantActiviy.latitude
        params["longitude"] = wantActiviy.longitude
        params["city"] = wantActiviy.city
        params["country"] = wantActiviy.country
        print(params)
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headers)
            .responseJSON { response in
                done(response.data)
        }
    }
    
    
    func callDeactivateWant(_ id:Int64, indexPath:IndexPath, done: @escaping (Data?, Int64?, IndexPath?) -> ())
    {
        let url = serviceURL + "deactive"
        print(User.sharedInstance.accessToken)
        
        let headers: HTTPHeaders = [
            "X-AUTH-TOKEN": User.sharedInstance.accessToken,
            "Content-Type": "application/json"
        ]
        var params:[String:Any] = [:]
        params["wantId"] = id
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headers)
            .responseJSON { response in
                done(response.data, id, indexPath)
        }
    }
    
    func callWanters(_ pageNum:Int64, categoryFilter:Int, search:String,  done: @escaping (Data?) -> ())
    {
        let url = serviceURL + "wanters"
        let headers: HTTPHeaders = [
            "X-AUTH-TOKEN": User.sharedInstance.accessToken,
            "Content-Type": "application/json"
        ]
        var params:[String:Any] = [:]
        var country = FilterData.sharedInstance.country
        if country == nil {
            country = User.sharedInstance.country
        }
        var city = FilterData.sharedInstance.city
        if city == nil {
            city = User.sharedInstance.city
        }
        let minPrice = FilterData.sharedInstance.minPrice
        let maxPrice = FilterData.sharedInstance.maxPrice
        let dateOption = FilterData.sharedInstance.dateOption
        params["country"] = country
        params["minPrice"] = minPrice
        params["maxPrice"] = maxPrice
        params["dateOption"] = dateOption
        params["pageNum"] = pageNum
        params["city"] = city
        params["perPageCount"] = 10
        params["categoryFilter"] = categoryFilter
        if search != ""{
           params["search"] = search
        }
       print(params)
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headers)
            .responseJSON { response in
                done(response.data)
        }
    }
    
}
