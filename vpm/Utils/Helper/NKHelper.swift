//
//  NKHelper.swift
//

import Foundation
import UIKit
import AudioToolbox
import CoreLocation
private var _shareinstance : NKHelper? = nil

class NKHelper: NSObject,UIAlertViewDelegate,URLSessionDelegate,UIActionSheetDelegate {
    
    
    internal var latitude:String?
    internal var logitude:String?
    
    
    
    class func shareinstance()-> NKHelper {
        
        if _shareinstance == nil {
            _shareinstance = NKHelper()
        }
        return _shareinstance!
    }
    
    func NKPlaceholderImage(image:UIImage?, imageView:UIImageView?,imgUrl:String,compate:@escaping (UIImage?) -> Void){
        
        if image != nil && imageView != nil {
            imageView!.image = image!
        }
        
        var urlcatch = imgUrl.replacingOccurrences(of: "/", with: "#")
        let documentpath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        urlcatch = documentpath + "/" + "\(urlcatch)"
        
        let image = UIImage(contentsOfFile:urlcatch)
        if image != nil && imageView != nil
        {
            imageView!.image = image!
            compate(image)
            
        }else{
            
            if let url = URL(string: imgUrl){
                
                DispatchQueue.global(qos: .background).async {
                    () -> Void in
                    let imgdata = NSData(contentsOf: url)
                    DispatchQueue.main.async {
                        () -> Void in
                        imgdata?.write(toFile: urlcatch, atomically: true)
                        let image = UIImage(contentsOfFile:urlcatch)
                        compate(image)
                        if image != nil  {
                            if imageView != nil  {
                                imageView!.image = image!
                            }
                        }
                    }
                }
            }
        }
    }
    
    class func ShowAlertError(message:String,view_screen:UIViewController = UIViewController()){
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in }))
        DispatchQueue.main.async {
            view_screen.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertControllerWith(title:String, message:String?, onVc:UIViewController , style: UIAlertController.Style = .alert, buttons:[String], button_color:UIColor = .blue, completion:((Bool,Int)->Void)?) -> Void {

            let alertController = UIAlertController.init(title: title, message: message, preferredStyle: style)
            for (index,title) in buttons.enumerated() {
                let action = UIAlertAction.init(title: title, style: UIAlertAction.Style.default) { (action) in
                    completion?(true,index)
                }
                action.setValue(button_color, forKey: "titleTextColor")
                alertController.addAction(action)
            }
        DispatchQueue.main.async {
            onVc.present(alertController, animated: true, completion: nil)
        }
    }
    
 }

class Locator: NSObject, CLLocationManagerDelegate {
    enum Result <T> {
        case Success(T)
        case Failure(Error)
    }
    
    static let shared: Locator = Locator()
    
    typealias Callback = (Result <Locator>) -> Void
    
    var requests: Array <Callback> = Array <Callback>()
    
    var location: CLLocation? { return sharedLocationManager.location  }
    
    lazy var sharedLocationManager: CLLocationManager = {
        let newLocationmanager = CLLocationManager()
        newLocationmanager.delegate = self
        // ...
        return newLocationmanager
    }()
    
    // MARK: - Authorization
    
    class func authorize() { shared.authorize() }
    func authorize() { sharedLocationManager.requestWhenInUseAuthorization() }
    
    // MARK: - Helpers
    
    func locate(callback: @escaping Callback) {
        self.requests.append(callback)
        sharedLocationManager.startUpdatingLocation()
    }
    
    func reset() {
        self.requests = Array <Callback>()
        sharedLocationManager.stopUpdatingLocation()
    }
    
    // MARK: - Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        for request in self.requests { request(.Failure(error)) }
        self.reset()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: Array <CLLocation>) {
        for request in self.requests { request(.Success(self)) }
        self.reset()
    }
}
