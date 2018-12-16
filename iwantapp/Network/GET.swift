

import Foundation
import Alamofire

class GET:NSObject
{
    static let sharedInstance = GET()
    
    func callOwnWants( _ done: @escaping (Data?) -> ())
    {
        let url = serviceURL + "wants" 
        let headers: HTTPHeaders = [
            "X-AUTH-TOKEN": User.sharedInstance.accessToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url, method: .get, headers:headers)
            .responseJSON { response in
                done(response.data)
        }
    }
    
    func callSearchKeywords( _ done: @escaping (Data?) -> ())
    {
        let url = serviceURL + "keywords"
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                done(response.data)
        }
    }
}
