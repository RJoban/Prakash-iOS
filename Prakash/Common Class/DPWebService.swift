import Foundation
import UIKit
import SystemConfiguration
import Kingfisher

enum MediaType: Int64 {
    case text   = 1
    case image  = 2
    case video  = 3
    case audio  = 4
    case gif    = 5
    case doc    = 6
}
enum StatusCode: Int {
    case ok = 200
    case create = 201
    case accepted = 202
    case noContent = 204
    case badRequest = 400
    case unAuthorized = 401
    case forbidden = 403
    case noFound = 404
    case methodNotAllow = 405
    case userExist = 409
    case serverError = 500
    case unavailable = 503
    case requestTimeout = 408
}

public enum APIMethodName : String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case COPY = "COPY"
    case HEAD = "HEAD"
    case OPTIONS = "OPTIONS"
    case LINK = "LINK"
    case UNLINK = "UNLINK"
    case PURGE = "PURGE"
    case LOCK = "LOCK"
    case UNLOCK = "UNLOCK"
}

class DPWebService: NSObject {
    
    fileprivate static let noInternet = ValidationMessages.noInternet
    fileprivate static let noServer = ValidationMessages.noServer
    
    class open func DPService (methodName:APIMethodName, view:UIView?, isUserInteractionEnabled:Bool, returnFailedBlock:Bool,  api:String,message:String, body:NSMutableDictionary?,Handler complition:@escaping (_ JSON:NSDictionary,_ status:Int,_ message:String) -> Void) {
        
        if InternetCheck() == false {
            if returnFailedBlock == true {
                complition([:],StatusCode.serverError.rawValue,noInternet)
                return
            }
            UIAlertController.showAlertError(message:noInternet)
            return
        }
        
        let baseURL = AppConfig.baseURL
        
        var url = URL(string: baseURL + api)
        
        var request = NSMutableURLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config) //session.delegate = self
        request.httpMethod = methodName.rawValue
        
        request = DPWebService.header(request: request, apiName: api, body: body)
        
        let apiParameter = DPWebService.stringFromDictionary(apibody: body ?? [:])
        if (methodName == .GET || methodName == .DELETE){
            url = URL.init(string:"\(url!.absoluteString)\(apiParameter)".encodeUrl())
        }
        if url == nil {
            UIAlertController.showAlertError(message: "Please check URL its Just for Development")
            return
        }
        
        
        let apibody = DPWebService.getBody(body: body, apiName: api)
        if DPWebService.checkMultipart(apibody) {
            request = self.multiPart(request: request, apibody: apibody)
        }else{
            if methodName != .GET && methodName != .DELETE {
                let jsonData = try! JSONSerialization.data(withJSONObject: apibody, options: [])
                request.httpBody = jsonData
            }
        }
        
        if view != nil  {
            LoaderView.show(InView:view, message)
        }
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            DispatchQueue.main.async {
                
                if view != nil  {
                    LoaderView.dismiss(InView:view)
                }
                
                if data != nil {
                    let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    
                    do {
                        if  let JSON = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            
                            var message = "No message from Server side"
                            if let msg  = JSON["message"] as? String {
                                message = msg
                            }
                            if JSON["status"] as? Int64 ?? 0 == StatusCode.unAuthorized.rawValue {
                                UIAlertController.showAlert(message: message, complition: {
                                    kUserDefults(false, key: LoginKeys.isLogin)
                                    kUserDefults(nil, key: LoginKeys.loginUser) // user model data
                                    
                                })
                                return
                            }
                            
                            guard let httpResponse = response as? HTTPURLResponse else{return}
                            
                            if httpResponse.statusCode == StatusCode.ok.rawValue{
                                if returnFailedBlock == false{
                                    if let isError = JSON["isError"] as? Bool{
                                        if isError{
                                            UIAlertController.showAlertError(message: message)
                                            return
                                        }
                                    }
                                }
                                complition(JSON,httpResponse.statusCode,message)
                                
                            }else{
                                
                                if returnFailedBlock == true {
                                    complition(JSON,StatusCode.serverError.rawValue,message)
                                    return
                                }else{
                                    UIAlertController.showAlertError(message: message)
                                }
                            }
                        }
                    } catch {
                        if returnFailedBlock == true {
                            complition([:],StatusCode.serverError.rawValue,"Please contact to admin")
                            kUserDefults(false, key: LoginKeys.isLogin)
                            kUserDefults(nil, key: LoginKeys.loginUser) // user model data
                            
                            return
                        }
                        UIAlertController.showAlert(message: "Please contact to admin", complition: {
                            kUserDefults(false, key: LoginKeys.isLogin)
                            kUserDefults(nil, key: LoginKeys.loginUser) // user model data
                        })
                    }
                } else {
                    
                    if returnFailedBlock == true {
                        complition([:],StatusCode.serverError.rawValue,noServer)
                        return
                    }
                    
                    UIAlertController.showAlertError(message: noServer)
                }
            }
        })
        task.resume()
    }
    
    
    fileprivate class func multiPart(request:NSMutableURLRequest,apibody:NSMutableDictionary) -> NSMutableURLRequest {
        
        let boundary = "---------------------------14737809831466499882746641449"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        for key in apibody.allKeys {
            if apibody[key as! String]!  is NSString {
                
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(apibody[key as! String]!)\r\n".data(using: String.Encoding.utf8)!)
                
            }
            else if apibody[key as! String]!  is NSNumber {
                
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(apibody[key as! String]!)\r\n".data(using: String.Encoding.utf8)!)
                
            }
            else if apibody[key as! String]! is UIImage {
                
                let image = apibody[key as! String] as! UIImage
                let imageData = image.jpegData(compressionQuality: 0.3)
                if imageData == nil {
                    break;
                }
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"\(key)\"; filename=\"a.jpg\"\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Type: \("image/jpeg")\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(imageData!)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
            }
                
            else if apibody[key as! String]! is [UIImage] {
                let imageArray = apibody[key as! String] as! [UIImage]
                for i in 0..<imageArray.count {
                    let image = imageArray[i]
                    let imageData = image.jpegData(compressionQuality: 0.3)
                    if imageData == nil {
                        break;
                    }
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Disposition:form-data; name=\"\(key)[]\"; filename=\"\(i).jpg\"\"\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Type: \("image/jpeg")\r\n\r\n".data(using: String.Encoding.utf8)!)
                    body.append(imageData!)
                    body.append("\r\n".data(using: String.Encoding.utf8)!)
                }
            }
                
            else if apibody[key as! String]! is NSData {
                
                let imageData = apibody[key as! String] as! NSData
               
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"\(key)\"; filename=\"a.png\"\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Type: \("image/png")\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(imageData as Data)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
            }
                
            else if let communication = apibody[key as! String] as? [[String:Any]] {
                //communication passed from chat(image and documents)
                for object in communication {
                    var contentType = ""
                    if let type = object["mediaType"] as? Int64 {
                        if type == MediaType.image.rawValue || type == MediaType.gif.rawValue {
                            contentType = "image/png"
                        }else if type == MediaType.doc.rawValue {
                            contentType = "application/\(object["mediaExt"] as! String)"
                        }
                    }
                    if let fileData = object["mediaData"] as? Data {
                        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        body.append("Content-Disposition:form-data; name=\"\(key)[]\"; filename=\"\(object["mediaName"] as! String).\(object["mediaExt"] as! String)\"\r\n".data(using: String.Encoding.utf8)!)
                        body.append("Content-Type: \(contentType)\r\n\r\n".data(using: String.Encoding.utf8)!)
                        body.append(fileData)
                        body.append("\r\n".data(using: String.Encoding.utf8)!)
                    }
                }
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        //print(NSString(data: request.httpBody!, encoding:String.Encoding.utf8.rawValue)!)
        return request
        
    }
    
    class func header(request: NSMutableURLRequest, apiName: String, body: NSMutableDictionary? = nil) -> NSMutableURLRequest {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if apiName != APIName.login && apiName != APIName.forgotPassword && apiName != APIName.signUp {
            request.setValue(kUserDefults_(UserDefaultsKeyName.apiCallToken) as? String ?? "", forHTTPHeaderField: "Authorization")
            //request.setValue("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjIyLCJlbWFpbCI6Im1haGVrQGdtYWlsLmNvbSIsInJvbGVJZCI6MSwiY2VudGVySWQiOjE1fQ.0JEvi8ucKquaGRtVMMT8XilG9vn6aVE8_6pfRAiAPeY", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    class func getBody(body:NSMutableDictionary?, apiName: String) -> NSMutableDictionary{
        
        var apibody:NSMutableDictionary!
        if body == nil {
            apibody = NSMutableDictionary()
        }else{
            apibody = body!.mutableCopy() as? NSMutableDictionary
        }
        return apibody
    }
        
    class func stringFromDictionary(apibody:NSMutableDictionary) -> NSMutableString {
        
        let  apiParameter = NSMutableString()
        for key in apibody.allKeys {
            if apiParameter.length != 0 {
                apiParameter.append("&")
            }
            if apibody[key as! String]! is NSString {
                
                let str = apibody.value(forKey: key as! String)! as! String
                apibody[key as! String] = str.replacingOccurrences(of: "&", with: "%26")
            }else  if apibody[key as! String]! is NSNumber {
                
                
                apibody[key as! String] = "\(apibody.value(forKey: key as! String)!)"
            }
            
            apiParameter.append("\(key)=\(apibody[key as! String]!)")
            
        }
        return apiParameter
    }
    
    private  class func checkMultipart(_ apibody:NSMutableDictionary) -> Bool {
        
        for key in apibody.allValues
        {
            if key is UIImage || key is URL || key is NSData || key is Data || key is [UIImage] {
                return true
            }
        }
        
        if (apibody.allKeys as! [String]).contains("communication") || ((apibody.allKeys as! [String]).contains("additionalAttachment") && (apibody.allKeys as! [String]).contains("playtimeAttachment")) {
            if let _ = apibody.value(forKey: "communication") as? [[String:Any]] {
                return true
            }
            if let _ = apibody.value(forKey: "additionalAttachment") as? [[String:Any]],  let _ = apibody.value(forKey: "playtimeAttachment") as? [[String:Any]]{
                return true
            }
            if let _ = apibody.value(forKey: "petImageGallery") as? [UIImage]{
                return true
            }
        }
        
        return false
    }
    public class func showAlert(_ JSON:NSDictionary)  {
        
        var message = "No message from Server side"
        if let msg  = JSON["message"] as? String{
            message = msg
        }
        UIAlertController.showAlertError(message:message)
    }
}

//MARK: - FunctionDefination -
func InternetCheck () -> Bool {
    let reachability =  Reachability()
    let networkStatus  = reachability?.currentReachabilityStatus
    if networkStatus == .notReachable {
        return false
    }
    return true
}


//MARK:  - DPLoader Class -

class LoaderView : UIView {
    
    let blackView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let activityIndicater = UIActivityIndicatorView()
        activityIndicater.style = .whiteLarge
        activityIndicater.color = UIColor.white
        activityIndicater.startAnimating()
        
        self.blackView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicater.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(blackView)
        blackView.addSubview(activityIndicater)
        
        blackView.backgroundColor = UIColor.black
        blackView.layer.cornerRadius = 4
        blackView.layer.masksToBounds = true
        
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        self.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        
        blackView.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem:nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120))
        
        blackView.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem:nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120))
        
        blackView.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .height, relatedBy: .lessThanOrEqual, toItem:nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.width - 40))
        
        blackView.addConstraint(NSLayoutConstraint.init(item: blackView, attribute: .width, relatedBy: .lessThanOrEqual, toItem:nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.size.width - 40))
        
        
        blackView.addConstraint(NSLayoutConstraint.init(item: activityIndicater, attribute: .centerX, relatedBy: .equal, toItem: blackView, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        blackView.addConstraint(NSLayoutConstraint.init(item: activityIndicater, attribute: .centerY, relatedBy: .equal, toItem: blackView, attribute: .centerY, multiplier: 1.0, constant: 0))
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func show(InView:UIView?, _ message:String){
        
        DispatchQueue.main.async(execute: {
            if InView == nil{
                return
            }
            guard let loader = InView?.viewWithTag(1322) as? LoaderView else {
                
                let rect = CGRect.init(x: 0, y: 0, width: InView!.frame.width, height: InView!.frame.height)
                let loader = LoaderView.init(frame:rect)
                loader.tag = 1322
                InView?.addSubview(loader)
                
                return
            }
            
            loader.tag = 1322
            InView?.addSubview(loader)
        })
    }
    
    class func dismiss(InView:UIView?) {
        
        guard let loader = InView?.viewWithTag(1322) as? LoaderView else {return}
        loader.removeFromSuperview()
    }
}


//MARK:  - Reachability Class -

public enum ReachabilityError: Error {
    case FailedToCreateWithAddress(sockaddr_in)
    case FailedToCreateWithHostname(String)
    case UnableToSetCallback
    case UnableToSetDispatchQueue
}

public let ReachabilityChangedNotification = NSNotification.Name("ReachabilityChangedNotification")

func callback(reachability:SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) {
    
    guard let info = info else { return }
    
    let reachability = Unmanaged<Reachability>.fromOpaque(info).takeUnretainedValue()
    
    DispatchQueue.main.async {
        reachability.reachabilityChanged()
    }
}

public class Reachability {
    
    public typealias NetworkReachable = (Reachability) -> ()
    public typealias NetworkUnreachable = (Reachability) -> ()
    
    public enum NetworkStatus: CustomStringConvertible {
        
        case notReachable, reachableViaWiFi, reachableViaWWAN
        
        public var description: String {
            switch self {
            case .reachableViaWWAN: return "Cellular"
            case .reachableViaWiFi: return "WiFi"
            case .notReachable: return "No Connection"
            }
        }
    }
    
    public var whenReachable: NetworkReachable?
    public var whenUnreachable: NetworkUnreachable?
    public var reachableOnWWAN: Bool
    
    // The notification center on which "reachability changed" events are being posted
    public var notificationCenter: NotificationCenter = NotificationCenter.default
    
    public var currentReachabilityString: String {
        return "\(currentReachabilityStatus)"
    }
    
    public var currentReachabilityStatus: NetworkStatus {
        guard isReachable else { return .notReachable }
        
        if isReachableViaWiFi {
            return .reachableViaWiFi
        }
        if isRunningOnDevice {
            return .reachableViaWWAN
        }
        
        return .notReachable
    }
    
    fileprivate var previousFlags: SCNetworkReachabilityFlags?
    
    fileprivate var isRunningOnDevice: Bool = {
        #if targetEnvironment(simulator)
        return false
        #else
        return true
        #endif
    }()
    
    fileprivate var notifierRunning = false
    fileprivate var reachabilityRef: SCNetworkReachability?
    
    fileprivate let reachabilitySerialQueue = DispatchQueue(label: "uk.co.ashleymills.reachability")
    
    required public init(reachabilityRef: SCNetworkReachability) {
        reachableOnWWAN = true
        self.reachabilityRef = reachabilityRef
    }
    
    public convenience init?(hostname: String) {
        
        guard let ref = SCNetworkReachabilityCreateWithName(nil, hostname) else { return nil }
        
        self.init(reachabilityRef: ref)
    }
    
    public convenience init?() {
        
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)
        
        guard let ref: SCNetworkReachability = withUnsafePointer(to: &zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else { return nil }
        
        self.init(reachabilityRef: ref)
    }
    
    deinit {
        stopNotifier()
        
        reachabilityRef = nil
        whenReachable = nil
        whenUnreachable = nil
    }
}

public extension Reachability {
    
    // MARK: - *** Notifier methods ***
    func startNotifier() throws {
        
        guard let reachabilityRef = reachabilityRef, !notifierRunning else { return }
        
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged<Reachability>.passUnretained(self).toOpaque())
        if !SCNetworkReachabilitySetCallback(reachabilityRef, callback, &context) {
            stopNotifier()
            throw ReachabilityError.UnableToSetCallback
        }
        
        if !SCNetworkReachabilitySetDispatchQueue(reachabilityRef, reachabilitySerialQueue) {
            stopNotifier()
            throw ReachabilityError.UnableToSetDispatchQueue
        }
        
        // Perform an intial check
        reachabilitySerialQueue.async {
            self.reachabilityChanged()
        }
        
        notifierRunning = true
    }
    
    func stopNotifier() {
        defer { notifierRunning = false }
        guard let reachabilityRef = reachabilityRef else { return }
        
        SCNetworkReachabilitySetCallback(reachabilityRef, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachabilityRef, nil)
    }
    
    // MARK: - *** Connection test methods ***
    var isReachable: Bool {
        
        guard isReachableFlagSet else { return false }
        
        if isConnectionRequiredAndTransientFlagSet {
            return false
        }
        
        if isRunningOnDevice {
            if isOnWWANFlagSet && !reachableOnWWAN {
                // We don't want to connect when on 3G.
                return false
            }
        }
        
        return true
    }
    
    var isReachableViaWWAN: Bool {
        // Check we're not on the simulator, we're REACHABLE and check we're on WWAN
        return isRunningOnDevice && isReachableFlagSet && isOnWWANFlagSet
    }
    
    var isReachableViaWiFi: Bool {
        
        // Check we're reachable
        guard isReachableFlagSet else { return false }
        
        // If reachable we're reachable, but not on an iOS device (i.e. simulator), we must be on WiFi
        guard isRunningOnDevice else { return true }
        
        // Check we're NOT on WWAN
        return !isOnWWANFlagSet
    }
    
    var description: String {
        
        let W = isRunningOnDevice ? (isOnWWANFlagSet ? "W" : "-") : "X"
        let R = isReachableFlagSet ? "R" : "-"
        let c = isConnectionRequiredFlagSet ? "c" : "-"
        let t = isTransientConnectionFlagSet ? "t" : "-"
        let i = isInterventionRequiredFlagSet ? "i" : "-"
        let C = isConnectionOnTrafficFlagSet ? "C" : "-"
        let D = isConnectionOnDemandFlagSet ? "D" : "-"
        let l = isLocalAddressFlagSet ? "l" : "-"
        let d = isDirectFlagSet ? "d" : "-"
        
        return "\(W)\(R) \(c)\(t)\(i)\(C)\(D)\(l)\(d)"
    }
}

fileprivate extension Reachability {
    
    func reachabilityChanged() {
        
        let flags = reachabilityFlags
        
        guard previousFlags != flags else { return }
        
        let block = isReachable ? whenReachable : whenUnreachable
        block?(self)
        
        self.notificationCenter.post(name: ReachabilityChangedNotification, object:self)
        
        previousFlags = flags
    }
    
    var isOnWWANFlagSet: Bool {
        #if os(iOS)
        return reachabilityFlags.contains(.isWWAN)
        #else
        return false
        #endif
    }
    var isReachableFlagSet: Bool {
        return reachabilityFlags.contains(.reachable)
    }
    var isConnectionRequiredFlagSet: Bool {
        return reachabilityFlags.contains(.connectionRequired)
    }
    var isInterventionRequiredFlagSet: Bool {
        return reachabilityFlags.contains(.interventionRequired)
    }
    var isConnectionOnTrafficFlagSet: Bool {
        return reachabilityFlags.contains(.connectionOnTraffic)
    }
    var isConnectionOnDemandFlagSet: Bool {
        return reachabilityFlags.contains(.connectionOnDemand)
    }
    var isConnectionOnTrafficOrDemandFlagSet: Bool {
        return !reachabilityFlags.intersection([.connectionOnTraffic, .connectionOnDemand]).isEmpty
    }
    var isTransientConnectionFlagSet: Bool {
        return reachabilityFlags.contains(.transientConnection)
    }
    var isLocalAddressFlagSet: Bool {
        return reachabilityFlags.contains(.isLocalAddress)
    }
    var isDirectFlagSet: Bool {
        return reachabilityFlags.contains(.isDirect)
    }
    var isConnectionRequiredAndTransientFlagSet: Bool {
        return reachabilityFlags.intersection([.connectionRequired, .transientConnection]) == [.connectionRequired, .transientConnection]
    }
    
    var reachabilityFlags: SCNetworkReachabilityFlags {
        
        guard let reachabilityRef = reachabilityRef else { return SCNetworkReachabilityFlags() }
        
        var flags = SCNetworkReachabilityFlags()
        let gotFlags = withUnsafeMutablePointer(to: &flags) {
            SCNetworkReachabilityGetFlags(reachabilityRef, UnsafeMutablePointer($0))
        }
        
        if gotFlags {
            return flags
        } else {
            return SCNetworkReachabilityFlags()
        }
    }
}

