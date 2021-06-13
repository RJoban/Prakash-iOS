
 import Foundation
 import UIKit
 import AVFoundation

 let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
 let SCREEN_WIDTH  = UIScreen.main.bounds.size.width
 let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
 let IS_IPHONE_4_OR_LESS  =  SCREEN_HEIGHT < 568.0
 let IS_IPHONE_5          =  SCREEN_HEIGHT == 568.0
 let IS_IPHONE_6          =  SCREEN_HEIGHT == 667.0
 let IS_IPHONE_6_PLUS     =  SCREEN_HEIGHT == 736.0
 
 let appDelegate = UIApplication.shared.delegate as! AppDelegate

 public func kUserDefults(_ value: Any?, key: String, isArchive: Bool = false ) {
    let defults = UserDefaults.standard
    if  value != nil {
        let data = NSKeyedArchiver.archivedData(withRootObject: value!)
        defults.setValue(data, forKey: key )
    }else {
        defults.removeObject(forKey: key)
    }
    defults.synchronize()
}
public func kUserDefults_( _ key : String) -> Any? {
    let defults = UserDefaults.standard
    if  let data = defults.value(forKey: key) as? Data {
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }
    return defults.value(forKey: key)
}

func numberOfDaysInTwoDates(smallerDate: Date, biggerDate: Date) -> Int {
    let calendar = Calendar.current
    let date1 = calendar.startOfDay(for: smallerDate)
    let date2 = calendar.startOfDay(for: biggerDate)
    let components = calendar.dateComponents([.day], from: date1, to: date2)
    return components.day ?? 0
}

//public func showToast(message: String) {
//    if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//        window.makeToast(message)
//    }
//}

//func colorForAlphabets(_ firstChar: String) -> UIColor {
//    switch firstChar {
//    case Alphabets.A.rawValue:
//        return UIColor.init(red: 240.0/255.0, green: 174.0/255.0, blue: 188.0/255.0, alpha: 1)
//    case Alphabets.B.rawValue:
//        return UIColor.init(red: 74.0/255.0, green: 98.0/255.0, blue: 168.0/255.0, alpha: 1)
//    case Alphabets.C.rawValue:
//        return UIColor.init(red: 27.0/255.0, green: 73.0/255.0, blue: 106.0/255.0, alpha: 1)
//    case Alphabets.D.rawValue:
//        return UIColor.init(red: 68.0/255.0, green: 163.0/255.0, blue: 139.0/255.0, alpha: 1)
//    case Alphabets.E.rawValue:
//        return UIColor.init(red: 104.0/255.0, green: 197.0/255.0, blue: 170.0/255.0, alpha: 1)
//    case Alphabets.F.rawValue:
//        return UIColor.init(red: 85.0/255.0, green: 135.0/255.0, blue: 126.0/255.0, alpha: 1)
//    case Alphabets.G.rawValue:
//        return UIColor.init(red: 131.0/255.0, green: 207.0/255.0, blue: 205.0/255.0, alpha: 1)
//    case Alphabets.H.rawValue:
//        return UIColor.init(red: 179.0/255.0, green: 156.0/255.0, blue: 148.0/255.0, alpha: 1)
//    case Alphabets.I.rawValue:
//        return UIColor.init(red: 84.0/255.0, green: 196.0/255.0, blue: 200.0/255.0, alpha: 1)
//    case Alphabets.J.rawValue:
//        return UIColor.init(red: 196.0/255.0, green: 195.0/255.0, blue: 175.0/255.0, alpha: 1)
//    case Alphabets.K.rawValue:
//        return UIColor.init(red: 193.0/255.0, green: 105.0/255.0, blue: 154.0/255.0, alpha: 1)
//    case Alphabets.L.rawValue:
//        return UIColor.init(red: 49.0/255.0, green: 137.0/255.0, blue: 175.0/255.0, alpha: 1)
//    case Alphabets.M.rawValue:
//        return UIColor.init(red: 41.0/255.0, green: 122.0/255.0, blue: 143.0/255.0, alpha: 1)
//    case Alphabets.N.rawValue:
//        return UIColor.init(red: 187.0/255.0, green: 82.0/255.0, blue: 139.0/255.0, alpha: 1)
//    case Alphabets.O.rawValue:
//        return UIColor.init(red: 61.0/255.0, green: 120.0/255.0, blue: 136.0/255.0, alpha: 1)
//    case Alphabets.P.rawValue:
//        return UIColor.init(red: 237.0/255.0, green: 90.0/255.0, blue: 98.0/255.0, alpha: 1)
//    case Alphabets.Q.rawValue:
//        return UIColor.init(red: 130.0/255.0, green: 84.0/255.0, blue: 133.0/255.0, alpha: 1)
//    case Alphabets.R.rawValue:
//        return UIColor.init(red: 130.0/255.0, green: 206.0/255.0, blue: 204.0/255.0, alpha: 1)
//    case Alphabets.S.rawValue:
//        return UIColor.init(red: 122.0/255.0, green: 136.0/255.0, blue: 183.0/255.0, alpha: 1)
//    case Alphabets.T.rawValue:
//        return UIColor.init(red: 245.0/255.0, green: 174.0/255.0, blue: 152.0/255.0, alpha: 1)
//    case Alphabets.U.rawValue:
//        return UIColor.init(red: 164.0/255.0, green: 199.0/255.0, blue: 97.0/255.0, alpha: 1)
//    case Alphabets.V.rawValue:
//        return UIColor.init(red: 240.0/255.0, green: 174.0/255.0, blue: 188.0/255.0, alpha: 1)
//    case Alphabets.W.rawValue:
//        return UIColor.init(red: 74.0/255.0, green: 98.0/255.0, blue: 168.0/255.0, alpha: 1)
//    case Alphabets.X.rawValue:
//        return UIColor.init(red: 27.0/255.0, green: 73.0/255.0, blue: 106.0/255.0, alpha: 1)
//    case Alphabets.Y.rawValue:
//        return UIColor.init(red: 68.0/255.0, green: 163.0/255.0, blue: 139.0/255.0, alpha: 1)
//    case Alphabets.Z.rawValue:
//        return UIColor.init(red: 104.0/255.0, green: 197.0/255.0, blue: 170.0/255.0, alpha: 1)
//        
//    default:
//        break
//    }
//    
//    return UIColor.lightGreyColor
//}

  public struct ReadJsonConstant {
    public static func readJson(fileName:String) -> NSDictionary? {
        do {
            let file = Bundle.main.url(forResource: fileName, withExtension: "json")!
            let data = try Data(contentsOf: file)
            return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            
        } catch {
            return nil
        }
    }
 }

public struct AppConfig {
    private enum APIMode:Int {
        case testing = 0
        case staging = 1
        case production = 2

        var apiURL: String {
            switch self {
            case .testing:
                return "http://192.168.1.173/mypetopia/api/v1/"
            case .staging:
                return "http://159.65.150.17/api/v1"
            case .production:
                return "https://api.petopia.xyz/api/v1/"
            }
        }
        var imageURL : String {
            switch self {
            case .testing:
                return "http://192.168.1.173"
            case .staging:
                return "http://159.65.150.17/assets/public/"
            case .production:
                return "http://159.65.150.17/assets/public/"
            }
        }
    }
    
    public static let baseURL             = baseLoginURL
    public static let baseLoginURL        = APIMode.staging.apiURL
    public static let baseImageURL        = APIMode.staging.imageURL
 }

 public struct ValidationMessages {
    public static let noInternet          = "Please check your internet connection and try again"
    public static let noServer            = "Server is not responding. Please try again later"
    public static let validEmail          = "Please enter valid Email"
    public static let email               = "Please enter Email"
    public static let oldPassword         = "Please enter current Password"
    public static let password            = "Please enter Password"
    public static let passwordChar        = "Password must be minimum 8 characters"
    public static let confirmPassword     = "Please enter Confirm Password"
    public static let passwordUnmatch     = "Both password should be same"
    public static let logoutMessage       = "Are you sure, you want to logout?"
    public static let firstName           = "Please enter First Name"
    public static let lastName            = "Please enter Last Name"
    public static let selectRole          = "Please select Role"
    public static let noResult            = "No Result found"
    public static let deleteMedia         = "Are you sure, you want to delete this media ?"
    public static let noCamera            = "You don't have camera in your device"
    public static let photoPermission     = "You have disabled the Photo Library permission. So would you like to enable the permission ?"
    public static let cameraPermission    = "You have disabled the Camera permission. So would you like to enable the permission ?"
    public static let confirmBooking      = "Are you sure you want to confirm this booking?"
    public static let rejectBooking       = "Are you sure you want to reject this booking?"
    public static let payNowBooking       = "Are you sure you want to pay now?"
    public static let payPartially        = "Pay Partially"
    public static let payLaterBooking     = "Are you sure you want to pay later?"
    public static let deleteThread        = "Are you sure you want to delete chat?"
    public static let deleteCard          = "Are you sure you want to delete this card?"
    public static let deleteReportCard    = "Are you sure you want to delete this Report Card?"
    public static let createBookingTitle  = "You have successfully purchased this package."
    public static let createBookMessage   = "Payment for this package is done and your credit balance is adjusted accordingly. Please reserve a spot for this package once you're final with the dates."
    public static let resetPin            = "Once you reset the pin, you would get an email with new QR and pin for Check In-Out. Do you want to continue?"
    public static let noTipsAvailable     = "There are no Tips till now."
    public static let sendReminder        = "Are you sure you want to send reminder?"
    public static let startConversasion   = "Start your conversation."
    public static let noBookingAvailable  = "No bookings found."
 }

  public struct APIName {
    static let login                      = "users/signin"
    static let forgotPassword             = "users/forgotPassword"
    static let signUp                     = "/users/add"
    static let slider                     = "/advertise/allslider"
    static let sponsoredads               = "/sponsoredads/getall"
    static let allnews                    = "/homenews/allnews"
    static let alldirectories             = "/city/getall"
    static let directories                = "/category/getall"
    static let directoriesByCity          = "/directory/getall"
    static let getAllChannels             = "/newschannel/allnewschannel"
    static let allBloods                  = "/blood/getallgroupwithoutcity"
    static let allBloodWithType           = "/blood/getallcitywithtype"
    static let allBloodGroups             = "/blood/getall"
    static let allNews                    = "/newslink/getall"
    static let allAgency                  = "/agency/getall"
    static let newspaper                  = "/newspaper/getall"
    static let videoAd                    = "/videoad/getall"
    static let notifications              = "/notification/getall"
    static let pressNote                  = "/pressnote/add"
    static let allCity                    = "/city/getall"
    static let addBlood                   = "/blood/add"
    static let addDirectory               = "/directory/add_directory"
    static let addVideoAd                 = "/video/adddevice"
    static let addHistory                 = "/historicalknowledge/add"
  }

  public struct APIKeyName {
    static let lastUpdatedTime            = "updatedDate"
    static let apiName                    = "apiName"
    static let code                       = "code"
  }

  public struct UserDefaultsKeyName {
    static let deviceToken                = "deviceToken"
    static let selectedUserRole           = "selectedUserRole"
    static let apiCallToken               = "apiCallToken"
    static let oneTimeSyncData            = "oneTimeSyncData"
    static let serviceOffered             = "serviceOffered"
    static let qrPassImage                = "qrImage"
  }

  public struct APICallTimeKeyName {
    static let country                    = "country"
    static let state                      = "state"
    static let city                       = "city"
  }

 public struct LoginKeys {
    static let username                   = "userEmailid"
    static let password                   = "userPassword"
    static let isLogin                    = "isLogin"
    static let loginUser                  = "loginUser"
 }

 public struct DateFormatters {
    public static let appDateFormat        = "MM/dd/yyyy"
    public static let serverDateFormat     = "yyyy-MM-dd"
    public static let serverTimeFormat     = "HH:mm:ss"
    public static let appTimeFormat        = "h:mm a"
    public static let serverDateTimeFormat = "yyyy-MM-dd HH:mm:ss"
    public static let appDateTimeFormat    = "MM/dd/yyyy HH:mm:ss"
    public static let punchMasterDateFormat = "EEEE MMM d, yyyy"
 }

