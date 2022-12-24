
import Foundation
import UIKit
import SystemConfiguration

let topBarHeight : CGFloat = IS_IPAD ? 84 : 64
let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad

let appDel = UIApplication.shared.delegate as! AppDelegate
let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate

let SCREEN_WIDTH  = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let IS_IPHONE_4   = UIScreen.main.bounds.size.height == 480
let IS_IPHONE_5   = UIScreen.main.bounds.size.height == 568
let IS_IPHONE_6   = UIScreen.main.bounds.size.height == 667
let IS_IPHONE_6P  = UIScreen.main.bounds.size.height == 736

func DLautomatic( _ size : CGFloat) -> CGFloat {
    return size*SCREEN_WIDTH / 320
}

func DLautomatic_H( _ size : CGFloat) -> CGFloat {
    return size*SCREEN_HEIGHT / 568
}

func kUserDefults(_ value : AnyObject, key : String ){
    let defults = UserDefaults.standard
    defults.setValue(value, forKey: key)
    defults.synchronize()
}

func kUserDefultsRemove( key : String ){
    let defults = UserDefaults.standard
    defults.removeObject(forKey: key)
    defults.synchronize()
}

func kUserDefults_( _ key : String) -> AnyObject? {
    let defults = UserDefaults.standard
    return defults.value(forKey: key) as AnyObject?
}

func resetDefaults() {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
        defaults.removeObject(forKey: key)
    }
}

func isUserLogin() -> Bool {
    
    if kUserDefults_(PARAMETERS.token) == nil {
        return false
    }
    return true
}

func InternetCheck () -> Bool {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return (isReachable && !needsConnection)
    
}

struct WebServices
{
    //Base URL for access api
    //Live
    static let BASE_URL = ""
 
    static let login = "https://auth.reloadly.com/oauth/token"
    static let get_products = "https://giftcards-sandbox.reloadly.com/countries/ae/products"
}

//Parameter Used in webservice
struct PARAMETERS
{
   
    static let UDID_STRING = UIDevice.current.identifierForVendor!.uuidString
    static let INR_CURRENCY = "Rs."
    static let STATUS = "status"
    static let ERROR = "error"
    static let DATA = "data"
    static let MESSAGE = "message"
    static let token = "token"
    static let devicetoken = "devicetoken"
    
    static let client_id = "client_id"
    static let client_secret = "client_secret"
    static let grant_type = "grant_type"
    static let audience = "audience"
}

struct RESPONSE_STATUS {
    
    //Received Proper data, Allow user to access application.
    static let OK = 200
    
    
    //Received Proper data, Allow user to access application.
    static let Created = 201
    
    //Received Proper data, Allow user to access application.
    static let Accepted = 202
    
    //Session Expired.
    static let Authentication_failure = 401
    
    //Don’t allow user to use application. Display error message and redirect to LOGIN screen.
    static let CONFLICT = 400
    
    //Allowed user to access some of the URLs. All other URLs are blocked. Manage redirect to specific screen programmatically for this response code.
    static let UNAUTH = 404
    
    //Don’t allow user to access this content, Display error message.
    static let FORBIDDEN = 403
    
    //Don’t allow user to access this content, Display error message and redirect to HOME screen in the application.
    static let INTERNAL_SERVER_ERROR = 500
    
}

struct Constants
{
    struct NSUSERDEFAULTS
    {
        static let defaults = UserDefaults.standard
    }
    
    struct DATEFORMAT
    {
        static let SERVER_DATE_TIME = "yyyy-MM-dd HH:mm:ss"
        
        static let MILITRY_TIME = "HH:mm"
        
        static let CURRENT_TIME = "hh:mm a"
        
        static let CURRENT_TIME_12_HOUR = "hh:mm:ss a"
        
        static let HH_MM_SS = "HH:mm:ss"
        
        static let NOTIFICATION_TIME = "h:mm aaa"
        
        static let ONLY_TIME = "HH:mm"
        
        static let CHAT_DATETIME = "dd MMM''yy HH:mm"
        
        static let BIRTH_DATE = "dd/MM/YYYY"
        
        static let SHORTMONTH = "MMM"
        
        static let EVENT_DATE_TIME = "dd/MM/yyyy HH:mm:ss"
        
        static let ISSUE_DATE = "MMM dd, yyyy"
        
        static let YEAR = "year"
        
        static let MONTH = "month"
        
        static let DAY = "day"
        
        static let FULLMONTH = "fullmonth"
        
//        static let ORDER_DATE = "MMM d, yyyy h:mm a"
        
        static let ORDER_DATE = "EEE MM/dd/yyyy @ h:mm a"
        
        static let MESSAGE_DATE_TIME = "MMM dd, yyyy h:mm a"
        
        static let ORDER_STATUS_DATE = "EEE MM/dd/yyyy"
        
        static let LOGIN_DATE = "h:mm a, MM-dd-yyy"
        
        static let DELIVERY_DATE = "MM-dd-yyyy"
        
        static let PRODUCT_HISTORY_DATE = "MM/dd/yyyy"
        
        static let SALE_DATE = "yyyy-MM-dd"
    }
        
    struct COLORS
    {
        static let APP_COLOR = "#004279"
        static let APP_COLOR_LIGHT = "#005DA2"
    }
    
}

enum AssetsColor: String {
    case AccentColor
}

let img_placeholder = UIImage.init(named: "vpm_logo")

let appName = "VPM"
let msg_no_internet = "No internet connection."
let msg_username = "Please enter username"
let msg_user_register = "User registerd successfully"
let msg_email = "Please enter valid email"
let msg_password = "Please enter password"
let msg_email_exist = "The user exists with this same email try with different email or you can login"
let msg_email_not_exist = "The user not exists with this email you need to sign up first"
let msg_invalid = "Invalid email or password"

// Alarm Message
//let msg_timer_alarm  = "Timer going to finish please reset"
//let msg_Fuel_burn_alarm  = "Fuel burn going to finish please reset"
//let msg_Fuel_tank_alarm  = "Fuel burn going to finish please reset"
