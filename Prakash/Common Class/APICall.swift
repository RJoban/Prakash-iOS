import Foundation
import CoreData
import UIKit

extension NSManagedObject {
    
    func dictionaryWithValues() -> NSDictionary?{
        let allkeys = Array(self.entity.attributesByName.keys)
        return self.dictionaryWithValues(forKeys: allkeys) as NSDictionary
    }
}

struct APICall {

    public static func CallAPI(view: UIView? ,isIndicater: Bool = false, apiName: String, apiMethod: APIMethodName, apiCallTimeKeyName: String, dictionary: [String:Any]?, complition:@escaping (Bool,Int,String, [String:Any]?) -> Void) {
        DPWebService.DPService(methodName: apiMethod, view: view, isUserInteractionEnabled: false, returnFailedBlock: true, api: apiName, message: "Please wait..", body: NSMutableDictionary(dictionary: dictionary ?? [:])) { (JSON, statusCode, message) in
            if message == ValidationMessages.noInternet {
                UIAlertController.showAlertError(message:ValidationMessages.noInternet)
                return
            }
//            guard let responseCode = JSON["code"] as? Int else {
//                complition(false,statusCode,message,nil)
//                return
//            }
            
//            if let response = JSON["response"] as? [String:Any] {
//                complition(true,responseCode,message,response)
//                return
//            }
            if(JSON["error"] as? Bool ?? true == false){
                complition(true,statusCode,message,JSON as? [String : Any])
                return
            }
            complition(false,204,message,nil)
        }
    }
    
}
