//
//  UtilsCommon.swift
//

import Foundation
import  CoreLocation
import SystemConfiguration
import  UIKit
import MapKit

class Utils
{
    static func isConnectedToNetwork() -> Bool {
        
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
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
    }
    
    // Redirect to maps
    static func openMapForPlace(Lattitude : Double, Longitute : Double, Address : String = "") {
        
        let latitude: CLLocationDegrees = Lattitude
        let longitude: CLLocationDegrees = Longitute
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        
        //        let options = [
        //           MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving
        //        ]
        
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = Address
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    static func getRoundedPrice(_ price: Double) -> Double {
        // Beacuse 2.14 should go up to 2.19
        var roundedPrice = price + 0.01
        
        // Round to nearest tenth
        roundedPrice = round(roundedPrice * 10) / 10
        
        // Go to x.x9
        roundedPrice = roundedPrice - 0.01

        return roundedPrice
    }

    static func getRoundUpto9Price(_ price: Double) -> Double {
        
        
        let roundedPrice = String(format: "%.2f", price)
        
        print(Utils.replace(myString: roundedPrice, roundedPrice.count - 1, "9"))
        
        let roundUpto9Str = Utils.replace(myString: roundedPrice, roundedPrice.count - 1, "9")
        
        
        return Double(roundUpto9Str) ?? 0.0
    }
    
    static func uniqueFilename(withPrefix prefix: String? = nil) -> String {
        let uniqueString = ProcessInfo.processInfo.globallyUniqueString
        
        if prefix != nil {
            return "\(prefix!)-\(uniqueString)"
        }
        
        return uniqueString
    }
    
    static func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString)     // gets an array of characters
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
    
    static func getFormattedDollar(_ value: Double) -> String {
        return String(format: "$%.02f", value)
    }
    
    static func getFormattedPrice(_ value: Double) -> String {
        return String(format: "%.02f", value)
    }
    
    static func createAttributedString(stringArray: [String], attributedPart: Int, attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString? {
        let finalString = NSMutableAttributedString()
        for i in 0 ..< stringArray.count {
            var attributedString = NSMutableAttributedString(string: stringArray[i], attributes: nil)
            if i == attributedPart {
                attributedString = NSMutableAttributedString(string: attributedString.string, attributes: attributes)
                finalString.append(attributedString)
            } else {
                finalString.append(attributedString)
            }
        }
        return finalString
    }
    
    /**
     *  Method Name : - hexStringToUIColor
     *
     *  Decription : - Convert hexa color into UIColor
     *
     *  @author  -  Nikunj Kumbhani
     *  @date  - 25th July 2017
     *  @param1 - hex:String
     *  @return - UIColor
     */
    
//    static func hexStringToUIColor (hex:String) -> UIColor {
//        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
//
//        if (cString.hasPrefix("#")) {
//            let index = cString.index(cString.startIndex, offsetBy: 1)
//            cString = cString.substring(from: index)
//        }
//
//        if ((cString.count) != 6) {
//            return UIColor.gray
//        }
//
//        var rgbValue:UInt32 = 0
//        Scanner(string: cString).scanHexInt32(&rgbValue)
//
//        return UIColor(
//            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//            alpha: CGFloat(1.0)
//        )
//    }
    
    /**
     *  Method Name : - GetShortMonthDate
     *
     *  Decription : - Get three digit month date and year
     *
     *  @author  -  Nikunj Kumbhani
     *  @date  - 2nd August 2017
     *  @param1 - date:String
     *  @return - [String:String]
     */
    
    static func GetFormatedDOB(date_string:String,dateFormat:String)-> String{
        
        let dateFormatter_db = DateFormatter()
        
        dateFormatter_db.dateFormat = dateFormat
        
        let dateFormatter_eventDate = DateFormatter()
        
//        dateFormatter_eventDate.dateFormat = DATEFORMAT.DOB_DATE
        
        let date = dateFormatter_db.date(from: date_string)
        
        
        return dateFormatter_eventDate.string(from: date!)
        
    }
    
    // UTC to LocL Date
    static func UTCToLocal(date:Date) -> Date {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = DATEFORMAT.SERVER_DATE_TIME
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.string(from: date)
        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.dateFormat = DATEFORMAT.SERVER_DATE_TIME
        
        return dateFormatter.date(from: dt)!
    }
    
    
    static func GetOrderDate(date_string:String)-> String{
        
        let dateFormatter_db = DateFormatter()
//        dateFormatter_db.timeZone = TimeZone(identifier: timeZone)
        dateFormatter_db.dateFormat = Constants.DATEFORMAT.SERVER_DATE_TIME
        
        let dateFormatter_eventDate = DateFormatter()
        
        dateFormatter_eventDate.dateFormat = Constants.DATEFORMAT.ORDER_DATE
        
        let date = dateFormatter_db.date(from: date_string)
        
        return dateFormatter_eventDate.string(from: date!)
        
    }
    
    static func GetOrderStatusDate(date_string:String)-> String{
        
        let dateFormatter_db = DateFormatter()
//        dateFormatter_db.timeZone = TimeZone(identifier: timeZone)
        dateFormatter_db.dateFormat = Constants.DATEFORMAT.SERVER_DATE_TIME
        
        let dateFormatter_eventDate = DateFormatter()
        
        dateFormatter_eventDate.dateFormat = Constants.DATEFORMAT.ORDER_STATUS_DATE
        
        let date = dateFormatter_db.date(from: date_string)
        
        return dateFormatter_eventDate.string(from: date!)
        
    }
    
    static func GetProductHistoryDate(date_string:String)-> String{
        
        let dateFormatter_db = DateFormatter()
//        dateFormatter_db.timeZone = TimeZone(identifier: timeZone)
        dateFormatter_db.dateFormat = Constants.DATEFORMAT.SERVER_DATE_TIME
        
        let dateFormatter_eventDate = DateFormatter()
        
        dateFormatter_eventDate.dateFormat = Constants.DATEFORMAT.PRODUCT_HISTORY_DATE
        
        let date = dateFormatter_db.date(from: date_string)
        
        return dateFormatter_eventDate.string(from: date!)
        
    }
    
    static func GetIssueDate(date_string:String)-> String{
        
        let dateFormatter_db = DateFormatter()
//        dateFormatter_db.timeZone = TimeZone(identifier: timeZone)
        dateFormatter_db.dateFormat = Constants.DATEFORMAT.SERVER_DATE_TIME
        
        let dateFormatter_eventDate = DateFormatter()
        
        dateFormatter_eventDate.dateFormat = Constants.DATEFORMAT.ISSUE_DATE
        
        let date = dateFormatter_db.date(from: date_string)
        
        return dateFormatter_eventDate.string(from: date!)
        
    }
    
    static func GetMessageDateTime(date_string:String)-> String{
        
        let dateFormatter_db = DateFormatter()
//        dateFormatter_db.timeZone = TimeZone(identifier: timeZone)
        dateFormatter_db.dateFormat = Constants.DATEFORMAT.SERVER_DATE_TIME
        
        let dateFormatter_eventDate = DateFormatter()
        
        dateFormatter_eventDate.dateFormat = Constants.DATEFORMAT.MESSAGE_DATE_TIME
        
        let date = dateFormatter_db.date(from: date_string)
        
        return dateFormatter_eventDate.string(from: date!)
        
    }
    static func DateFromString(date_string:String,dateFormat:String)-> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let date = dateFormatter.date(from: date_string) //according to date format your date string
        return date! //Convert String to Date
    }
    
    static func jsonToString(_ json: AnyObject)->String{
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            
            let convertedString = String(data: data1, encoding: String.Encoding.utf8)?.replacingOccurrences(of: "\n", with: "") // the data will be converted to the string
            
            
            return convertedString!  // <-- here is ur string
            
        } catch let myJSONError {
            
            print(myJSONError)
            
        }
        
        return ""
    }
    
    static func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Roboto-Bold", size: 15)
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont as Any,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func resize(_ image: UIImage) -> UIImage {
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = 250.0
        let maxWidth: Float = 250.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.0
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!) ?? UIImage()
    }
    
    static func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    static func removeImagefrom(fileName: String) {
        
        let fileManager = FileManager.default
        
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
        
        if fileManager.fileExists(atPath: paths[0]){
            
            do {
                try fileManager.removeItem(at: documentsDirectory.appendingPathComponent(fileName))
                print("documentDirectory Delete SuccessFully")
            } catch let error as NSError {
                print(error.debugDescription)
            }
            
        }else{
            print("File Not Exist")
        }
    }
    
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func secondsToHoursMinutesSecondsStr (seconds : Int) -> String {
          let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(seconds: seconds);
//          var str = hours > 0 ? "\(hours) h" : ""
//          str = minutes > 0 ? str + " \(minutes) min" : str
//          str = seconds > 0 ? str + " \(seconds) sec" : str
        
        var str = hours > 0 ? "\(hours):" : ""
        str = minutes > 0 ? str + "\(minutes):" : str
        str = seconds > 0 ? str + "\(seconds)" : str
        
          return str
      }

    static func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
            return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    static func timeToMillis(hour: Int, minutes: Int, seconds: Int) -> Int{
        
        var total_millis = 0
        
        if hour > 0{
            let hourToMillis = Int(hour * 3600000)
            total_millis += hourToMillis
        }
        
        if minutes > 0{
            let minutesToMillis = Int(minutes * 60000)
            total_millis += minutesToMillis
        }
        
        if seconds > 0{
            let secondsToMillis = Int(seconds * 1000)
            total_millis += secondsToMillis
        }
        
        return total_millis
        
    }
    
    static func timeToSeconds(hour: Int, minutes: Int, seconds: Int) -> Int{
        
        var total_seconds = 0
        
        if hour > 0{
            let hourToSeconds = Int(hour * 3600)
            total_seconds += hourToSeconds
        }
        
        if minutes > 0{
            let minutesToSeconds = Int(minutes * 60)
            total_seconds += minutesToSeconds
        }
        
        if seconds > 0{
            total_seconds += seconds
        }
        
        return total_seconds
        
    }
    
    static func secToHMSString(time:TimeInterval) -> String {
        let hours = (Int(time) / 3600)
        let minutes = (Int(time) / 60) % 60
        let seconds = Int(time) % 60
//        return String(format:"%02i:%02i:%02d", hours, minutes, seconds)
        return String(format:"%02i:%02i:%02d", abs(hours), abs(minutes), abs(seconds))
    }
    
    static func secToMSString(time:TimeInterval) -> String {
        let minutes = (Int(time) / 60) % 60
        let seconds = Int(time) % 60
//        return String(format:"%02i:%02i", minutes, seconds)
        return String(format:"%02i:%02i", abs(minutes), abs(seconds))
    }
}
class Alerts {
    static func showActionsheet(viewController: UIViewController, title: String, message: String, actions: [(String, UIAlertAction.Style)], completion: @escaping (_ index: Int) -> Void) {
    let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    for (index, (title, style)) in actions.enumerated() {
        let alertAction = UIAlertAction(title: title, style: style) { (_) in
            completion(index)
        }
        if alertAction.style == .cancel{
            alertAction.setValue(UIColor.appColor(.AccentColor) ?? UIColor.blue, forKey: "titleTextColor")
        }else{
            alertAction.setValue(UIColor.red, forKey: "titleTextColor")
        }
        alertViewController.addAction(alertAction)
     }
     // iPad Support
     alertViewController.popoverPresentationController?.sourceView = viewController.view
     
     viewController.present(alertViewController, animated: true, completion: nil)
    }
}
class ImageConverter {

    func base64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: imageData)
    }

    func imageToBase64(_ image: UIImage) -> String? {
        return image.jpegData(compressionQuality: 1)?.base64EncodedString()
    }

}
