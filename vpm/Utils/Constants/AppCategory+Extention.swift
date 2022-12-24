//
//  Category+Extention.swift
//

import Foundation
import UIKit
import UniformTypeIdentifiers

public extension UIView {
    class func fromNib(_ nibNameOrNil:String) ->  UIView {
        return  Bundle.main.loadNibNamed(nibNameOrNil, owner: nil, options: nil)!.first as! UIView
    }
    
}

extension UIView{
    
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.isHidden = true
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func stopBlinkTab() {
        layer.removeAllAnimations()
        self.alpha = 1.0
        self.tintColor = UIColor.white.withAlphaComponent(0.5)
    }

    func moveInTransition(_ duration:CFTimeInterval) {
            let animation = CATransition()
            animation.timingFunction = CAMediaTimingFunction(name:
                CAMediaTimingFunctionName.easeInEaseOut)
            animation.type = CATransitionType.moveIn
            animation.duration = duration
            layer.add(animation, forKey: CATransitionType.moveIn.rawValue)
        }
    
    func GradientColor(color: [UIColor]) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = color.map { $0.cgColor }
        //gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        //gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.locations = [0.0, 1.0]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    
    
    
    //    func addGradientWithColor(color: [UIColor]) {
    //        let gradient = CAGradientLayer()
    //        gradient.frame = self.bounds
    //        gradient.colors = color.map { $0.cgColor }
    //        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
    //        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
    //        gradient.locations = [0.5,0.35]
    //        self.layer.insertSublayer(gradient, at: 0)
    //    }
    
    func ClearColorShaddow(_ alpha:Float){
        
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = (self.frame.size.height)/2
        self.layer.shadowPath = CGPath(rect: CGRect(x: 0,y: 0, width: self.frame.width,height: self.frame.height), transform: nil)
        self.layer.shadowOpacity = alpha
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
        
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    @IBInspectable var Corneredius:CGFloat{
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var BorderWidth:CGFloat{
        
        get{
            return layer.borderWidth
        }
        set{
            self.layer.borderWidth = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var BorderColor:UIColor{
        
        get{
            return self.BorderColor
        }
        set{
            self.layer.borderColor = newValue.cgColor
            
        }
    }
    @IBInspectable var RoundDynamic:Bool{
        
        get{
            return false
        }
        set{
            if newValue == true {
                
                self.perform(#selector(UIView.AfterDelay), with: nil, afterDelay: 0.0)
            }
            
        }
        
    }
    
    @objc func AfterDelay(){
        
        let  Height =  self.frame.size.height
        self.layer.cornerRadius = Height/2;
        self.layer.masksToBounds = true;
        
        
    }
    
    @IBInspectable var Round:Bool{
        get{
            return false
        }
        set{
            if newValue == true {
                self.layer.cornerRadius = self.frame.size.height/2;
                self.layer.masksToBounds = true;
            }
            
        }
    }
    
    //    @IBInspectable var Shadow:Bool{
    //        get{
    //            return false
    //        }
    //        set{
    //            if newValue == true {
    //                self.layer.masksToBounds = false
    //                self.layer.shadowColor = UIColor.gray.cgColor
    //                self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    //                self.layer.shadowOpacity = 0.4;
    //
    //            }
    //
    //        }
    //
    //    }
    
    @IBInspectable var dropShadow: Bool {
        set{
            if newValue {
                layer.shadowColor = UIColor.darkGray.cgColor
                layer.shadowOpacity = 0.5
                layer.shadowRadius = 5.0
                layer.shadowOffset = CGSize.zero
                layer.masksToBounds = false
                
                
//                layer.shadowOffset = CGSize(width: 2, height: 2)
                
                
            } else {
                layer.shadowColor = UIColor.clear.cgColor
                layer.shadowOpacity = 0
                layer.shadowRadius = 0
                layer.shadowOffset = CGSize.zero
            }
        }
        get {
            return layer.shadowOpacity > 0
        }
    }
    
    @IBInspectable var ViewdropShadow: Bool {
        set{
            if newValue {
                layer.shadowColor = UIColor.gray.cgColor
                layer.shadowOpacity = 0.5
                layer.shadowRadius = 1.5
                layer.shadowOffset = CGSize.zero
                layer.masksToBounds = false
            } else {
                layer.shadowColor = UIColor.clear.cgColor
                layer.shadowOpacity = 0
                layer.shadowRadius = 0
                layer.shadowOffset = CGSize.zero
            }
        }
        get {
            return layer.shadowOpacity > 0
        }
    }
    
    //    @IBInspectable var clipsToBounds:Bool{
    //        get{
    //            return false
    //        }
    //        set{
    //            if newValue == true {
    //
    //                self.clipsToBounds = true
    //            }else{
    //                self.clipsToBounds = false
    //            }
    //
    //        }
    //
    //    }
    
    
    func roundMake() {
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = true;
    }
    
    func addInputViewDatePicker(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 80))
        //        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .time
        //        self.inputView = datePicker
        
        
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.addSubview(datePicker)
        //        self.inputAccessoryView = toolBar
    }
    
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
    
    func addBottomLine(color: UIColor, height: CGFloat) {

       let bottomView = UIView(frame: CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: height))
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.autoresizingMask = .flexibleWidth
        bottomView.backgroundColor = color
        self.addSubview(bottomView)
     }
}

extension UILabel{
    
    @IBInspectable var FontAutomatic:Bool{
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let  height = (self.frame.size.height*SCREEN_HEIGHT)/568;
                self.font = UIFont(name:self.font.fontName, size:(height*self.font.pointSize)/self.frame.size.height )
            }
        }
    }
    
    func addTrailing(image: UIImage, text:String) {
            let attachment = NSTextAttachment()
            attachment.image = image
            attachment.bounds = CGRect(x: 0, y: -3, width: 10, height: 15)
            let attachmentString = NSAttributedString(attachment: attachment)
            let string = NSMutableAttributedString(string: text, attributes: [:])

            string.append(attachmentString)
            self.attributedText = string
        }
        
        func addLeading(image: UIImage, text:String) {
            let attachment = NSTextAttachment()
            attachment.image = image
//            attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 15)
            let attachmentString = NSAttributedString(attachment: attachment)
            let mutableAttributedString = NSMutableAttributedString()
            mutableAttributedString.append(attachmentString)
            
            let string = NSMutableAttributedString(string: text, attributes: [:])
            mutableAttributedString.append(string)
            self.attributedText = mutableAttributedString
        }
}
extension UITextView {
    
    func setHTMLFromString(text: String) {
        let modifiedFont = NSString(format:"<span style=\"font-family: \(self.font!.fontName); font-size: \(self.font!.pointSize)\">%@</span>" as NSString, text)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = attrStr
    }
    
    @IBInspectable var FontAutomatic:Bool{
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let  height = (self.frame.size.height*SCREEN_HEIGHT)/568;
                self.font = UIFont(name:self.font!.fontName, size:(height*self.font!.pointSize)/self.frame.size.height )
            }
            
        }
        
    }
    
    @IBInspectable var Pedding:Bool{
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.frame.height))
                self.addSubview(paddingView)
            }
            
        }
        
    }
    
    
    
}
extension UITextField{
    
    @IBInspectable var FontAutomatic:Bool{
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let  height = (self.frame.size.height*SCREEN_HEIGHT)/568;
                self.font = UIFont(name:self.font!.fontName, size:(height*self.font!.pointSize)/self.frame.size.height )
            }
            
        }
        
    }
    
    func setBottomBorder(_ color:UIColor, width:CGFloat) {
        
        var view = self.viewWithTag(2525)
        if view == nil {
            
            view = UIView(frame:CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height))
            view?.backgroundColor = color
            view?.tag = 2525
            self .addSubview(view!)
        }
    }
    
    
    @IBInspectable var Pedding:Bool{
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.frame.height))
                self.leftView = paddingView
                self.leftViewMode = UITextField.ViewMode.always                }
            
        }
        
    }
    
    
    func leftButton(imageName:String) {
        
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.height, height:  self.frame.size.height)
        self.leftView = btn;
        self.leftViewMode = .always
        // return btn
        
    }
    
    func rightButton(imageName:String) {
        
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.frame = CGRect.init(x:  (SCREEN_WIDTH - self.frame.size.height), y: 0, width: self.frame.size.height, height:  self.frame.size.height)
        self.rightView = btn;
        self.rightViewMode = .always
        // return btn
        
    }
    
    func leftpedding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
    }
    
}
extension UIButton{
    
    @IBInspectable var FontAutomatic:Bool{
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let  height = (self.frame.size.height*SCREEN_HEIGHT)/568;
                self.titleLabel!.font = UIFont(name:self.titleLabel!.font!.fontName, size:(height*self.titleLabel!.font!.pointSize)/self.frame.size.height )!
            }
            
        }
        
    }
    
}
extension String{
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    func applyPatternOnNumbers(pattern:String = "###-###-####", replacmentCharacter:Character = "#") -> String {
        
//            "+# (###) ###-####" With Country Code
            var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
            for index in 0 ..< pattern.count {
                guard index < pureNumber.count else { return pureNumber }
                let stringIndex = String.Index(encodedOffset: index)
                let patternCharacter = pattern[stringIndex]
                guard patternCharacter != replacmentCharacter else { continue }
                pureNumber.insert(patternCharacter, at: stringIndex)
            }
            return pureNumber
        }
    
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    func isValidName() -> Bool {
        
        if self.count > 0 {
            return true
        }
        return false
        
        
    }
    
    func isValidPassWord() -> Bool {
        
        let passwordRegEx = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z])(?=.*[0-9]).{8,}$")
        return passwordRegEx.evaluate(with: self)
        
    }
    
    func isValidFullname() -> Bool {
        
        let emailRegEx = "^[A-Za-z]+(?:\\s[A-Za-z]+)"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
        
    }
    func isValidZipcode() -> Bool {
        
        if self.count == 5 || self.count == 6 {
            return true
        }
        return false
        
    }
    
    func isValidMobile() -> Bool {
        
        if self.count == 10 {
            return true
        }
        return false
        
    }
    
    func isValidConversationMessage() -> Bool {
        
        if self.count < 500 {
            return true
        }
        return false
        
    }
    
    func isValidDescription() -> Bool {
        
        if self.count > 5 && self.count < 6000 {
            return true
        }
        return false
        
    }
    
    func isEmptyText() -> Bool {
        
        let string = self.trimmingCharacters(in: NSCharacterSet.whitespaces)
        return string.isEmpty
    }
    
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    func isValidUrl() -> Bool {
        guard let url = URL(string: self), UIApplication.shared.canOpenURL(url) else { return false }
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: self)
    }
}
extension UIScrollView{
    
    func AumaticScroller() {
        
        var contentRect = CGRect.zero
        for view in self.subviews{
            contentRect = contentRect.union(view.frame);
        }
        
        self.contentSize = contentRect.size;
    }
    
    //    func AumaticScrollerFaxible() {
    //
    //        var contentRect = CGRect.zero
    //        for view in self.subviews{
    //            contentRect = contentRect.union(view.frame);
    //        }
    //
    //        self.contentSize = CGSize(width: contentRect.width, height: contentRect.height + automatic(60))
    //    }
    
    
}
extension UIImage{
    
    func resizeImage(_ newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}


// To convert HTML string to Normal string.
extension String {
    
    // formatting text for currency textField
        func currencyFormatting() -> String {
            if let value = Double(self) {
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.locale = Locale(identifier: "en_US")
                formatter.maximumFractionDigits = 2
                formatter.minimumFractionDigits = 2
                if let str = formatter.string(for: value) {
                    return str
                }
            }
            return ""
        }
    
    func simpleText(str:String) -> String {
        
        let result1 = str.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        
        return result1.replacingOccurrences(of: "&nbsp;", with: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func htmlAttributedString() -> NSAttributedString? {
        
        guard let font = UIFont(name:"Poppins-Regular",size:14) else {
            return htmlToAttributedString
        }
        
        let htmlTemplate = """
            <html>
                <head>
                    <style>
                        body {
                            background-color : rgb(230, 230, 230);
                            font-family      : '\(font.fontName)';
                            text-decoration  : none;
                            font-size: 14px;
                            color: #888888;
                        }
                    </style>
                </head>
                <body>
                    \(self)
                </body>
            </html>
            """
        
        guard let data = htmlTemplate.data(using: .utf8) else {
            return nil
        }
        
        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ) else {
            return nil
        }
        
        return attributedString
    }
}

extension UIApplication {
    var statusBarUIView: UIView? {

            if #available(iOS 13.0, *) {
                let tag = 3848245

                let keyWindow: UIWindow? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

                if let statusBar = keyWindow?.viewWithTag(tag) {
                    return statusBar
                } else {
                    let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
                    let statusBarView = UIView(frame: height)
                    statusBarView.tag = tag
                    statusBarView.layer.zPosition = 999999

                    keyWindow?.addSubview(statusBarView)
                    return statusBarView
                }

            } else {

                if responds(to: Selector(("statusBar"))) {
                    return value(forKey: "statusBar") as? UIView
                }
            }
            return nil
          }
}

extension Date {
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self as Date) == self.compare(date2 as Date)
    }
    
    func getHours(currentTime:Int64?,previousTime:Int64?) -> Int64{
        
        return (((currentTime! - previousTime!) / 1000) / 3600)
    }
    
    func getMinuts(currentTime:Int64?,previousTime:Int64?) -> Int64{
        
        return (((currentTime! - previousTime!) / 1000) / 60)
    }
    
    func getSeconds(currentTime:Int64?,previousTime:Int64?) -> Int64{
        
        return (((currentTime! - previousTime!) / 1000))
    }
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        let locale = Locale(identifier: "en_US_POSIX")
        formatter.locale = locale
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func currentUTCTimeZoneDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        //        formatter.amSymbol = ""
        //        formatter.pmSymbol = ""
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    func second(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func nanosecond(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    static func today() -> Date {
          return Date()
      }

      func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next,
                   weekday,
                   considerToday: considerToday)
      }

      func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
                   weekday,
                   considerToday: considerToday)
      }

      func get(_ direction: SearchDirection,
               _ weekDay: Weekday,
               considerToday consider: Bool = false) -> Date {

        let dayName = weekDay.rawValue

        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

        let calendar = Calendar(identifier: .gregorian)

        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
          return self
        }

        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex

        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)

        return date!
      }
    
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
      }

      enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
      }

      enum SearchDirection {
        case next
        case previous

        var calendarSearchDirection: Calendar.SearchDirection {
          switch self {
          case .next:
            return .forward
          case .previous:
            return .backward
          }
        }
      }
}

extension TimeInterval {
    var hourMinuteSecondMS: String {
        String(format:"%d:%02d:%02d.%03d", hour, minute, second, millisecond)
    }
    var minuteSecondMS: String {
        String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}

extension UIColor {
    
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") { cString.removeFirst() }
        
        if cString.count != 6 {
            self.init("ff0000") // return red color for wrong hex input
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    
    static func appColor(_ name: AssetsColor) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
    
}

extension UIWindow {
    static var key: UIWindow! {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}


@IBDesignable class TriangleGradientView: UIView {
    @IBInspectable var topColor: UIColor = UIColor.lightGray {
        didSet {
            setGradient()
        }
    }
    @IBInspectable var bottomColor: UIColor = UIColor.white {
        didSet {
            setGradient()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradient()
    }
    
    private func setGradient() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
        (layer as! CAGradientLayer).startPoint = CGPoint(x: 1.0, y: 0.0)
        (layer as! CAGradientLayer).endPoint = CGPoint(x: 0.0, y: 1.0)
        (layer as! CAGradientLayer).locations = [0.5,0.35]
    }
}
class BadgeButton: UIButton {
    
    var badgeLabel = UILabel()
    
    var badge: String? {
        didSet {
            addbadgetobutton(badge: badge)
        }
    }
    
    public var badgeBackgroundColor = UIColor.white {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }
    
    public var badgeTextColor = UIColor.black {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }
    
    public var badgeFont = UIFont.systemFont(ofSize: 10.0) {
        didSet {
            badgeLabel.font = badgeFont
        }
    }
    
    public var badgeEdgeInsets: UIEdgeInsets? {
        didSet {
            addbadgetobutton(badge: badge)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addbadgetobutton(badge: nil)
    }
    
    func addbadgetobutton(badge: String?) {
        badgeLabel.text = badge
        badgeLabel.textColor = badgeTextColor
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.font = badgeFont
        badgeLabel.sizeToFit()
        badgeLabel.textAlignment = .center
        let badgeSize = badgeLabel.frame.size
        
        let height = max(18, Double(badgeSize.height) + 5.0)
        let width = max(height, Double(badgeSize.width) + 10.0)
        
        var vertical: Double?, horizontal: Double?
        if let badgeInset = self.badgeEdgeInsets {
            vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
            horizontal = Double(badgeInset.left) - Double(badgeInset.right)
            
            let x = (Double(bounds.size.width) - 10 + horizontal!)
            let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
            badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        } else {
            let x = self.frame.width - CGFloat((width / 2.0))
            let y = CGFloat(-(height / 2.0))
            badgeLabel.frame = CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height))
        }
        
        badgeLabel.layer.cornerRadius = badgeLabel.frame.height/2
        badgeLabel.layer.masksToBounds = true
        addSubview(badgeLabel)
        badgeLabel.isHidden = badge != nil ? false : true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addbadgetobutton(badge: nil)
        fatalError("init(coder:) is not implemented")
    }
}
class TriangleView: UIView {
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.close()
        
        UIColor.red.withAlphaComponent(0.5).setFill()
        path.fill()
    }
    
}
extension UINavigationController {
    func hideHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = true
        }
    }
    func restoreHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = false
        }
    }
    func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        for subview in view.subviews {
            if let imageView = self.findHairlineImageViewUnder(subview) {
                return imageView
            }
        }
        return nil
    }
}
extension UIViewController {
    func hideNavigationBar(animated: Bool){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    func showNavigationBar(animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setCartCount(count: Int = 0){
        if let tabItems = self.tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[3]
            if count > 0{
                tabItem.badgeValue = "\(count)"
            }else{
                tabItem.badgeValue = nil
            }
        }
    }
}
extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}
extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}
extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.clear.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}
extension Bundle {
    public var appName: String { getInfo("CFBundleName")  }
    public var displayName: String {getInfo("CFBundleDisplayName")}
    public var language: String {getInfo("CFBundleDevelopmentRegion")}
    public var identifier: String {getInfo("CFBundleIdentifier")}
    public var copyright: String {getInfo("NSHumanReadableCopyright").replacingOccurrences(of: "\\\\n", with: "\n") }
    
    public var appBuild: String { getInfo("CFBundleVersion") }
    public var appVersionLong: String { getInfo("CFBundleShortVersionString") }
    //public var appVersionShort: String { getInfo("CFBundleShortVersion") }
    
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}
private var handle: UInt8 = 0

extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
            if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
                return b as? CAShapeLayer
            } else {
                return nil
            }
        }

        func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
            guard let view = self.value(forKey: "view") as? UIView else { return }

            badgeLayer?.removeFromSuperlayer()

            // Initialize Badge
            let badge = CAShapeLayer()
            let radius = CGFloat(9)
            let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
            badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: UIColor.clear, filled: filled)
            view.layer.addSublayer(badge)

            // Initialiaze Badge's label
            let label = CATextLayer()
            label.string = "\(number)"
            label.alignmentMode = CATextLayerAlignmentMode.center
            label.fontSize = 12
            label.frame = CGRect(origin: CGPoint(x: location.x - 6, y: offset.y), size: CGSize(width: 20, height: 16))
            label.foregroundColor = filled ? UIColor.clear.cgColor : color.cgColor
            label.backgroundColor = UIColor.clear.cgColor
            label.contentsScale = UIScreen.main.scale
            badge.addSublayer(label)

            // Save Badge as UIBarButtonItem property
            objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        func updateBadge(number: Int) {
            if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
                text.string = "\(number)"
            }
        }

        func removeBadge() {
            badgeLayer?.removeFromSuperlayer()
        }
}
extension UIFont {
    
    public enum RobotoType: String {
        case Regular = "Regular"
        case Medium = "Medium"
        case Light = "Light"
        case Bold = "Bold"
    }
    
    static func Roboto(_ type: RobotoType = .Regular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        if type == .Regular{
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }else if type == .Medium{
            return UIFont.systemFont(ofSize: size, weight: .medium)
        }else if type == .Light{
            return UIFont.systemFont(ofSize: size, weight: .light)
        }else if type == .Bold{
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }else{
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
    }
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
}
//extension URL {
//    public func mimeType() -> String {
//        if let mimeType = UTType(filenameExtension: self.pathExtension)?.preferredMIMEType {
//            return mimeType
//        }
//        else {
//            return "application/octet-stream"
//        }
//    }
//}
