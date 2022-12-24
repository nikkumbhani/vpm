import Foundation
import UIKit
import Alamofire

class APIManager {
    
    class func headers() -> HTTPHeaders {
        
        var headers: HTTPHeaders = []
        if isUserLogin(){
            headers = [
                "Content-Type":  "application/json",
                "Authorization": "Bearer \(kUserDefults_(PARAMETERS.token)!)"
            ]
            
        }else{
            headers = [
                "Content-Type":  "application/json"
            ]
        }
        return headers
    }
}

class AAPWebService: NSObject {
    
    class open func callPostApi(api:String, parameters:[String:AnyObject]?,view_screen:UIViewController = UIViewController() , complition:@escaping (Data,AnyObject)->Void)
    {
        
        if InternetCheck() == false {
            DispatchQueue.main.async{
                _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
            }
            
            NKHelper().showAlertControllerWith(title: appName, message: msg_no_internet, onVc: view_screen, style: .alert, buttons: ["OK"], button_color: UIColor.appColor(.AccentColor) ?? UIColor.blue) { action, index in }
            return
        }
        
        print("POST URL : \(api)")
        print("PARAMETERS : ",parameters as Any)
        print("HEADER : ",APIManager.headers())
        
        AF.request(api, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: APIManager.headers())
            .responseData { response in
                
                do {
                    
                    let jsonDict = try JSONSerialization.jsonObject(with: (response.data as Data? ?? Data()), options: []) as? [String:AnyObject]
                    
                    if response.error != nil{
                        print(response.error as Any, terminator: "")
                    }
                    
                    if jsonDict == nil
                    {
                        let jsonArray = try JSONSerialization.jsonObject(with: (response.data as Data? ?? Data()), options: []) as? [AnyObject]
                        
                        if jsonArray != nil{
                            
                            let statusCode = response.response?.statusCode
                            
                            print("RESPONSE STATUS : \(statusCode!)")
                            print(jsonDict as Any, terminator: "")
                            
                            if statusCode == RESPONSE_STATUS.OK || statusCode == RESPONSE_STATUS.Created || statusCode == RESPONSE_STATUS.Accepted{
                                
                                complition(response.data!,jsonArray as AnyObject)
                                return
                            }else{
                                view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
                                DispatchQueue.main.async{
                                    _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
                                }
                                return
                            }
                        }else{
                            
                            view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
                            DispatchQueue.main.async{
                                _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
                            }
                            return
                            
                        }
                    }
                    
                    let statusCode = response.response?.statusCode
                    
                    print("RESPONSE STATUS : \(statusCode!)")
                    print(jsonDict as Any, terminator: "")
                    
                    if statusCode == RESPONSE_STATUS.OK || statusCode == RESPONSE_STATUS.Created || statusCode == RESPONSE_STATUS.Accepted{
                        
                        complition(response.data!,jsonDict as AnyObject)
                        
                    }else if statusCode != nil{
                        
                        if statusCode == RESPONSE_STATUS.INTERNAL_SERVER_ERROR{
                            var error_message = "Something went wrong. Please try again later"
                            if let result = jsonDict![PARAMETERS.MESSAGE] as? String{
                                error_message = result
                            }
                            view_screen.view.makeToast(error_message)
                        }else if statusCode == RESPONSE_STATUS.Authentication_failure{
                            var error_message = "INVALID SESSION OR SESSION EXPIRED"
                            if let result = jsonDict![PARAMETERS.MESSAGE] as? String{
                                error_message = result
                            }
                            
//                            if let Login_VC = storyboardMain.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
//                                appDel.is_session_expired = true
//                                UIWindow.key.rootViewController = Login_VC
//                                UIWindow.key.makeToast(error_message)
//                            }
                                                        view_screen.view.makeToast(error_message)
                        }
                        else{
                            var error_message = "Whoops, Something went wrong. Please, try after sometime."
                            if let result = jsonDict![PARAMETERS.MESSAGE] as? String{
                                error_message = result
                            }
                            view_screen.view.makeToast(error_message)
                        }
                        
                        DispatchQueue.main.async{
                            _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
                        }
                        return
                        
                    }else{
                        view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
                        DispatchQueue.main.async{
                            _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
                        }
                        return
                    }
                    
                } catch _ {
                    print("Exception!")
                    DispatchQueue.main.async{
                        _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
                    }
                }
            }
        
    }
    
    
//    class open func callPostApiWithBody(api:String, parameters:Any?,view_screen:UIViewController = UIViewController() , complition:@escaping (Data,AnyObject)->Void)
//    {
//
//        if InternetCheck() == false {
//            DispatchQueue.main.async{
//                _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//            }
//            NKHelper().showAlertControllerWith(title: appName, message: msg_no_internet, onVc: view_screen, style: .alert, buttons: ["OK"], button_color: UIColor.appColor(.AccentColor) ?? UIColor.blue) { action, index in }
//            return
//        }
//
//        print("POST URL : \(api)")
//        print("PARAMETERS : ",parameters as Any)
//        print("HEADER : ",APIManager.headers())
//
//
//
//        var request = URLRequest(url: URL(string: api)!)
//        request.httpMethod = "POST"
////        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.headers = APIManager.headers()
//        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters as Any)
//
//        AF.request(request)                               // Or `Alamofire.request(request)` in prior versions of Alamofire
//            .responseData { response in
//                do {
//
//                    let jsonDict = try JSONSerialization.jsonObject(with: (response.data as Data? ?? Data()), options: []) as? [String:AnyObject]
//
//                    if response.error != nil{
//                        print(response.error as Any, terminator: "")
//                    }
//
//                    if jsonDict == nil
//                    {
//                        let jsonArray = try JSONSerialization.jsonObject(with: (response.data as Data? ?? Data()), options: []) as? [AnyObject]
//
//                        if jsonArray != nil{
//
//                            let statusCode = response.response?.statusCode
//
//                            print("RESPONSE STATUS : \(statusCode!)")
//                            print(jsonDict as Any, terminator: "")
//
//                            if statusCode == RESPONSE_STATUS.OK || statusCode == RESPONSE_STATUS.Created || statusCode == RESPONSE_STATUS.Accepted{
//
//                                complition(response.data!,jsonArray as AnyObject)
//                                return
//                            }else{
//                                view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
//                                DispatchQueue.main.async{
//                                    _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                                }
//                                return
//                            }
//                        }else{
//
//                            view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
//                            DispatchQueue.main.async{
//                                _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                            }
//                            return
//
//                        }
//                    }
//
//                    let statusCode = response.response?.statusCode
//
//                    print("RESPONSE STATUS : \(statusCode!)")
//                    print(jsonDict as Any, terminator: "")
//
//                    if statusCode == RESPONSE_STATUS.OK || statusCode == RESPONSE_STATUS.Created || statusCode == RESPONSE_STATUS.Accepted{
//
//                        complition(response.data!,jsonDict as AnyObject)
//
//                    }else if statusCode != nil{
//
//                        if statusCode == RESPONSE_STATUS.INTERNAL_SERVER_ERROR{
//                            var error_message = "Something went wrong. Please try again later"
//                            if let result = jsonDict![PARAMETERS.result] as? String,result.lowercased() == "error"{
//                                error_message = jsonDict![PARAMETERS.DATA] as? String ?? "error"
//                            }
//                            view_screen.view.makeToast(error_message)
//                        }else if statusCode == RESPONSE_STATUS.Authentication_failure{
//                            var error_message = "INVALID SESSION OR SESSION EXPIRED"
//                            if let result = jsonDict![PARAMETERS.result] as? String,result.lowercased() == "error"{
//                                error_message = jsonDict![PARAMETERS.DATA] as? String ?? "error"
//                            }
//
////                            if let Login_VC = storyboardMain.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
////                                appDel.is_session_expired = true
////                                UIWindow.key.rootViewController = Login_VC
////                                UIWindow.key.makeToast(error_message)
////                            }
//                            //                            view_screen.view.makeToast(error_message)
//                        }
//                        else{
//                            var error_message = "Whoops, Something went wrong. Please, try after sometime."
//                            if let result = jsonDict![PARAMETERS.result] as? String,result.lowercased() == "error"{
//                                error_message = jsonDict![PARAMETERS.DATA] as? String ?? "error"
//                            }else if let result = jsonDict![PARAMETERS.DATA] as? String{
//                                error_message = result
//                            }
//                            view_screen.view.makeToast(error_message)
//                        }
//
//                        DispatchQueue.main.async{
//                            _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                        }
//                        return
//
//                    }else{
//                        view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
//                        DispatchQueue.main.async{
//                            _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                        }
//                        return
//                    }
//
//                } catch _ {
//
//                    print("Exception!")
//                    view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
//                    DispatchQueue.main.async{
//                        _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                    }
//                }
//        }
//
//
//    }
//
    class open func callGetApi(api:String,parameters:[String:AnyObject]? = nil,view_screen:UIViewController = UIViewController() , complition:@escaping (Data,AnyObject)->Void)
    {
        
        if InternetCheck() == false {
            DispatchQueue.main.async{
                _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
            }
            NKHelper().showAlertControllerWith(title: appName, message: msg_no_internet, onVc: view_screen, style: .alert, buttons: ["OK"], button_color: UIColor.appColor(.AccentColor) ?? UIColor.blue) { action, index in }
            return
        }
        
        print("POST URL : \(api)")
        print("PARAMETERS : ",parameters as Any)
        print("HEADER : ",APIManager.headers())
        
        AF.request(api, method: .get, parameters: parameters,headers: APIManager.headers())
            .responseData { response in
                
                do {
                    
                    let jsonDict = try JSONSerialization.jsonObject(with: (response.data as Data? ?? Data()), options: []) as? [String:AnyObject]
                    
                    if response.error != nil{
                        print(response.error as Any, terminator: "")
                    }
                    
                    if jsonDict == nil
                    {
                        let jsonArray = try JSONSerialization.jsonObject(with: (response.data as Data? ?? Data()), options: []) as? [AnyObject]
                        
                        if jsonArray != nil{
                            
                            let statusCode = response.response?.statusCode
                            
                            print("RESPONSE STATUS : \(statusCode!)")
                            print(jsonDict as Any, terminator: "")
                            
                            if statusCode == RESPONSE_STATUS.OK || statusCode == RESPONSE_STATUS.Created || statusCode == RESPONSE_STATUS.Accepted{
                                
                                complition(response.data!,jsonArray as AnyObject)
                                return
                            }else{
                                view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
                                DispatchQueue.main.async{
                                    _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
                                }
                                return
                            }
                        }else{
                            
                            view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
                            DispatchQueue.main.async{
                                _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
                            }
                            return
                            
                        }
                    }
                    
                    let statusCode = response.response?.statusCode
                    
                    print("RESPONSE STATUS : \(statusCode!)")
                    print(jsonDict as Any, terminator: "")
                    
                    if statusCode == RESPONSE_STATUS.OK || statusCode == RESPONSE_STATUS.Created || statusCode == RESPONSE_STATUS.Accepted{
                        
                        complition(response.data!,jsonDict as AnyObject)
                        
                    }else if statusCode != nil{
                        
                        if statusCode == RESPONSE_STATUS.INTERNAL_SERVER_ERROR{
                            var error_message = "Something went wrong. Please try again later"
                            if let result = jsonDict![PARAMETERS.MESSAGE] as? String{
                                error_message = result
                            }
                            view_screen.view.makeToast(error_message)
                        }else if statusCode == RESPONSE_STATUS.Authentication_failure{
                            var error_message = "INVALID SESSION OR SESSION EXPIRED"
                            if let result = jsonDict![PARAMETERS.MESSAGE] as? String{
                                error_message = result
                            }
                            
//                            if let Login_VC = storyboardMain.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
//                                appDel.is_session_expired = true
//                                UIWindow.key.rootViewController = Login_VC
//                                UIWindow.key.makeToast(error_message)
//                            }
                            view_screen.view.makeToast(error_message)
                        }
                        else{
                            var error_message = "Whoops, Something went wrong. Please, try after sometime."
                            if let result = jsonDict![PARAMETERS.MESSAGE] as? String{
                                error_message = result
                            }
                            view_screen.view.makeToast(error_message)
                        }
                        
                        DispatchQueue.main.async{
                            _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
                        }
                        return
                        
                    }else{
                        view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
                        DispatchQueue.main.async{
                            _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
                        }
                        return
                    }
                    
                } catch _ {
                    
                    print("Exception!")
                    view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
                    DispatchQueue.main.async{
                        _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
                    }
                }
            }
    }
    //Mark: API call with image upload
//    class open func callPostApiImage(api : String, view_screen:UIViewController = UIViewController(), parameters:[String:AnyObject]? = nil, images: [UIImage], imageParameterName: String, imageName: String, mime_type:String = "image/jpeg",complition:@escaping (Data,AnyObject)->Void) {
//
//
//        if InternetCheck() == false {
//            DispatchQueue.main.async{
//                _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//            }
//            NKHelper().showAlertControllerWith(title: appName, message: msg_no_internet, onVc: view_screen, style: .alert, buttons: ["OK"], button_color: UIColor.appColor(.AccentColor) ?? UIColor.blue) { action, index in }
//            return
//        }
//
//        print("POST URL : \(api)")
//        print("PARAMETERS : ",parameters as Any)
//
//        //        let api_url = URL + apiName
//        //
//        //        var headers = self.getAfterAuthHeaders()
//        //        if  URL == baseAuthURL {
//        //            headers = self.getBeforeAuthHeaders()
//        //        }
//        //
//        //        if parameters == nil {
//        //            print("API URL = \(api_url) headers = \(headers)")
//        //        }
//        //        else {
//        //            print("API URL = \(api_url) headers = \(headers) parameters = \(parameters!)")
//        //        }
//        //
//        //        if isShowHud {
//        ////            KRProgressHUD.show(withMessage: "Please wait")
//        //            KRProgressHUD.show()
//        //        }
//
//        //        let base64EncodedString = toBase64EncodedString(toJsonString(parameters: parameters!))
//
//        AF.upload(multipartFormData: { multipartFormData in
//            if images.count > 1 {
//                for index in 0...images.count - 1{
//                    if let imageData = images[index].jpegData(compressionQuality: 0.5) {
//
//                        if imageName != ""{
//                            multipartFormData.append(imageData, withName: imageParameterName, fileName: imageName, mimeType: mime_type)
//                        }else{
//                            multipartFormData.append(imageData, withName: imageParameterName, fileName:"image_\(ProcessInfo().globallyUniqueString).jpeg", mimeType: mime_type)
//
//                        }
//                    }
//                }
//            }
//            else {
//                if let imageData = images[0].jpegData(compressionQuality: 0.5) {
//                    if imageName != ""{
//
//                        multipartFormData.append(imageData, withName: imageParameterName, fileName: imageName, mimeType: mime_type)
//                    }else{
//                        multipartFormData.append(imageData, withName: imageParameterName, fileName: "image_\(ProcessInfo().globallyUniqueString).jpeg", mimeType: mime_type)
//                    }
//
//                }
//            }
//
//            if parameters != nil{
//                //Append Param
//                for (key, value) in parameters! {
//                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                }
//            }
//        }, to: api, method: .post, headers: APIManager.headers()).responseData(completionHandler: { data in
//            print("Upload finished: \(data)")
//        }).response { (response) in
//
//            switch response.result {
//            case .success(let result):
//                if result != nil{
//
//                    do {
//
//                        let jsonDict = try JSONSerialization.jsonObject(with: (response.data as Data? ?? Data()), options: []) as? [String:AnyObject]
//
//                        if response.error != nil{
//                            print(response.error as Any, terminator: "")
//                        }
//
//                        if jsonDict == nil
//                        {
//                            let jsonArray = try JSONSerialization.jsonObject(with: (response.data as Data? ?? Data()), options: []) as? [AnyObject]
//
//                            if jsonArray != nil{
//
//                                let statusCode = response.response?.statusCode
//
//                                print("RESPONSE STATUS : \(statusCode!)")
//                                print(jsonDict as Any, terminator: "")
//
//                                if statusCode == RESPONSE_STATUS.OK || statusCode == RESPONSE_STATUS.Created || statusCode == RESPONSE_STATUS.Accepted{
//
//                                    complition(response.data!,jsonArray as AnyObject)
//                                    return
//                                }else{
//                                    view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
//                                    DispatchQueue.main.async{
//                                        _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                                    }
//                                    return
//                                }
//                            }else{
//
//                                view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
//                                DispatchQueue.main.async{
//                                    _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                                }
//                                return
//
//                            }
//                        }
//
//                        let statusCode = response.response?.statusCode
//
//                        print("RESPONSE STATUS : \(statusCode!)")
//                        print(jsonDict as Any, terminator: "")
//
//                        if statusCode == RESPONSE_STATUS.OK || statusCode == RESPONSE_STATUS.Created || statusCode == RESPONSE_STATUS.Accepted{
//
//                            complition(response.data!,jsonDict as AnyObject)
//
//                        }else if statusCode != nil{
//
//                            if statusCode == RESPONSE_STATUS.INTERNAL_SERVER_ERROR{
//                                var error_message = "Something went wrong. Please try again later"
//                                if let result = jsonDict![PARAMETERS.result] as? String,result.lowercased() == "error"{
//                                    error_message = jsonDict![PARAMETERS.DATA] as? String ?? "error"
//                                }
//                                view_screen.view.makeToast(error_message)
//                            }else if statusCode == RESPONSE_STATUS.Authentication_failure{
//                                var error_message = "INVALID SESSION OR SESSION EXPIRED"
//                                if let result = jsonDict![PARAMETERS.result] as? String,result.lowercased() == "error"{
//                                    error_message = jsonDict![PARAMETERS.DATA] as? String ?? "error"
//                                }
//
////                                if let Login_VC = storyboardMain.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
////                                    appDel.is_session_expired = true
////                                    UIWindow.key.rootViewController = Login_VC
////                                    UIWindow.key.makeToast(error_message)
////                                }
//                                //                            view_screen.view.makeToast(error_message)
//                            }
//                            else{
//                                var error_message = "Whoops, Something went wrong. Please, try after sometime."
//                                if let result = jsonDict![PARAMETERS.result] as? String,result.lowercased() == "error"{
//                                    error_message = jsonDict![PARAMETERS.DATA] as? String ?? "error"
//                                }
//                                view_screen.view.makeToast(error_message)
//                            }
//
//                            DispatchQueue.main.async{
//                                _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                            }
//                            return
//
//                        }else{
//                            view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
//                            DispatchQueue.main.async{
//                                _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                            }
//                            return
//                        }
//
//                    } catch _ {
//
//                        print("Exception!")
//                        view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
//                        DispatchQueue.main.async{
//                            _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                        }
//                    }
//                }
//            case .failure(let encodingError):
//                print("Image Upload Exception! \(encodingError)")
//                DispatchQueue.main.async{
//                    _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                }
//            }
//        }
//    }
//
    
//    //Mark: API call with file upload
//    class open func callPostApiFile(api : String, view_screen:UIViewController = UIViewController(), parameters:[String:AnyObject]? = nil, file_urls: [URL], fileParameterName: String, fileName: String = "", mime_type:String = "application/pdf",complition:@escaping (Data,AnyObject)->Void) {
//
//
//        if InternetCheck() == false {
//            DispatchQueue.main.async{
//                _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//            }
//            NKHelper().showAlertControllerWith(title: appName, message: msg_no_internet, onVc: view_screen, style: .alert, buttons: ["OK"], button_color: UIColor.appColor(.AccentColor) ?? UIColor.blue) { action, index in }
//            return
//        }
//
//        print("POST URL : \(api)")
//        print("PARAMETERS : ",parameters as Any)
//
//        //        let api_url = URL + apiName
//        //
//        //        var headers = self.getAfterAuthHeaders()
//        //        if  URL == baseAuthURL {
//        //            headers = self.getBeforeAuthHeaders()
//        //        }
//        //
//        //        if parameters == nil {
//        //            print("API URL = \(api_url) headers = \(headers)")
//        //        }
//        //        else {
//        //            print("API URL = \(api_url) headers = \(headers) parameters = \(parameters!)")
//        //        }
//        //
//        //        if isShowHud {
//        ////            KRProgressHUD.show(withMessage: "Please wait")
//        //            KRProgressHUD.show()
//        //        }
//
//        //        let base64EncodedString = toBase64EncodedString(toJsonString(parameters: parameters!))
//
//
////        file_url?.lastPathComponent ?? "file_\(ProcessInfo().globallyUniqueString).pdf"
//
//        AF.upload(multipartFormData: { multipartFormData in
//            if file_urls.count > 1 {
//                for url in file_urls{
//                    do {
//                        let fileData = try Data(contentsOf: url)
//                        print(fileData)
//                        multipartFormData.append(fileData, withName: fileParameterName, fileName: url.lastPathComponent, mimeType: mime_type)
//                    }
//                    catch {
//                        print("Error \(error)")
//                    }
//                }
//            }
//            else {
//                //                let fileData = try Data(contentsOf: file_urls.first!)
//
//                do {
//                    let fileData = try Data(contentsOf: file_urls.first!)
//                    print(fileData)
//                    multipartFormData.append(fileData, withName: fileParameterName, fileName: file_urls.first?.lastPathComponent ?? "file_\(ProcessInfo().globallyUniqueString).pdf", mimeType: mime_type)
//                }
//                catch {
//                    print("Error \(error)")
//                }
//            }
////            }
//
//
//
////            if file_urls.count > 1 {
////                for url in 0...file_urls.count - 1{
////
//////                    do {
////                    if let fileData = Data(contentsOf: url){
////                        print(fileData)
////                        multipartFormData.append(fileData, withName: fileParameterName, fileName: fileName, mimeType: mime_type)
////                    }
//////                    }
//////                    catch {
//////                        print("Error \(error)")
//////                    }
////
////                    //                    if let imageData = images[index].jpegData(compressionQuality: 0.6) {
////                    //                        multipartFormData.append(imageData, withName: "\(imageParameterName)[\(index)]", fileName: "\(imageName)\(index + 1).png", mimeType: "image/png")
////                    //                    }
////                }
////            }else{
//////                let fileData = Data(contentsOf: file_urls.first)
////                if let fileData = try Data(contentsOf: file_urls.first!){
////                    multipartFormData.append(fileData, withName: fileParameterName, fileName: fileName, mimeType: mime_type)
////                }
////            }
////
//
//            if parameters != nil{
//                //Append Param
//                for (key, value) in parameters! {
//                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                }
//            }
//        }, to: api, method: .post, headers: APIManager.headers()).responseData(completionHandler: { data in
//            print("Upload finished: \(data)")
//        }).response { (response) in
//
//            switch response.result {
//            case .success(let result):
//                if result != nil{
//
//                    do {
//
//                        let jsonDict = try JSONSerialization.jsonObject(with: (response.data as Data? ?? Data()), options: []) as? [String:AnyObject]
//
//                        if response.error != nil{
//                            print(response.error as Any, terminator: "")
//                        }
//
//                        if jsonDict == nil
//                        {
//                            let jsonArray = try JSONSerialization.jsonObject(with: (response.data as Data? ?? Data()), options: []) as? [AnyObject]
//
//                            if jsonArray != nil{
//
//                                let statusCode = response.response?.statusCode
//
//                                print("RESPONSE STATUS : \(statusCode!)")
//                                print(jsonDict as Any, terminator: "")
//
//                                if statusCode == RESPONSE_STATUS.OK || statusCode == RESPONSE_STATUS.Created || statusCode == RESPONSE_STATUS.Accepted{
//
//                                    complition(response.data!,jsonArray as AnyObject)
//                                    return
//                                }else{
//                                    view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
//                                    DispatchQueue.main.async{
//                                        _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                                    }
//                                    return
//                                }
//                            }else{
//
//                                view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
//                                DispatchQueue.main.async{
//                                    _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                                }
//                                return
//
//                            }
//                        }
//
//                        let statusCode = response.response?.statusCode
//
//                        print("RESPONSE STATUS : \(statusCode!)")
//                        print(jsonDict as Any, terminator: "")
//
//                        if statusCode == RESPONSE_STATUS.OK || statusCode == RESPONSE_STATUS.Created || statusCode == RESPONSE_STATUS.Accepted{
//
//                            complition(response.data!,jsonDict as AnyObject)
//
//                        }else if statusCode != nil{
//
//                            if statusCode == RESPONSE_STATUS.INTERNAL_SERVER_ERROR{
//                                var error_message = "Something went wrong. Please try again later"
//                                if let result = jsonDict![PARAMETERS.result] as? String,result.lowercased() == "error"{
//                                    error_message = jsonDict![PARAMETERS.DATA] as? String ?? "error"
//                                }
//                                view_screen.view.makeToast(error_message)
//                            }else if statusCode == RESPONSE_STATUS.Authentication_failure{
//                                var error_message = "INVALID SESSION OR SESSION EXPIRED"
//                                if let result = jsonDict![PARAMETERS.result] as? String,result.lowercased() == "error"{
//                                    error_message = jsonDict![PARAMETERS.DATA] as? String ?? "error"
//                                }
//
////                                if let Login_VC = storyboardMain.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
////                                    appDel.is_session_expired = true
////                                    UIWindow.key.rootViewController = Login_VC
////                                    UIWindow.key.makeToast(error_message)
////                                }
//                                //                            view_screen.view.makeToast(error_message)
//                            }
//                            else{
//                                var error_message = "Whoops, Something went wrong. Please, try after sometime."
//                                if let result = jsonDict![PARAMETERS.result] as? String,result.lowercased() == "error"{
//                                    error_message = jsonDict![PARAMETERS.DATA] as? String ?? "error"
//                                }
//                                view_screen.view.makeToast(error_message)
//                            }
//
//                            DispatchQueue.main.async{
//                                _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                            }
//                            return
//
//                        }else{
//                            view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
//                            DispatchQueue.main.async{
//                                _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                            }
//                            return
//                        }
//
//                    } catch _ {
//
//                        print("Exception!")
//                        view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
//                        DispatchQueue.main.async{
//                            _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                        }
//                    }
//                }
//            case .failure(let encodingError):
//                print("Image Upload Exception! \(encodingError)")
//                DispatchQueue.main.async{
//                    _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                }
//            }
//        }
//    }
//    //Mark: API call with multipartFormData
//    class open func callPostApiMultipartFormData(api:String, parameters:[String:AnyObject]?,view_screen:UIViewController = UIViewController() , complition:@escaping (Data,AnyObject)->Void) {
//
//
//        if InternetCheck() == false {
//            DispatchQueue.main.async{
//                _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//            }
//            NKHelper().showAlertControllerWith(title: appName, message: msg_no_internet, onVc: view_screen, style: .alert, buttons: ["OK"], button_color: UIColor.appColor(.AccentColor) ?? UIColor.blue) { action, index in }
//            return
//        }
//
//        print("POST URL : \(api)")
//        print("PARAMETERS : ",parameters as Any)
//        print("HEADER : ",APIManager.headers())
//
//        AF.upload(multipartFormData: { multipartFormData in
//            //Append Param
//            for (key, value) in parameters! {
//                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//            }
//        }, to: api, method: .post).responseData(completionHandler: { data in
//            print("Upload finished: \(data)")
//        }).response { (response) in
//
//            switch response.result {
//            case .success(let result):
//                if let getdata = result{
//
//                    do {
//
//                        let jsonDict = try JSONSerialization.jsonObject(with: getdata, options: []) as? [String:AnyObject]
//
//                        if response.error != nil{
//                            print(response.error as Any, terminator: "")
//                        }
//
//                        if jsonDict == nil
//                        {
//                            view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
//
//                            return
//                        }
//
//                        let statusCode = response.response?.statusCode
//
//                        print("RESPONSE STATUS : \(statusCode!)")
//                        print(jsonDict as Any, terminator: "")
//
//                        if statusCode == RESPONSE_STATUS.OK{
//
//                            complition(response.data!,jsonDict as AnyObject)
//
//                        }else if statusCode != nil{
//
//                            if statusCode == RESPONSE_STATUS.INTERNAL_SERVER_ERROR{
//                                view_screen.view.makeToast("Internal server error. Please, try after sometime.")
//                            }else{
//                                var error_message = "Whoops, Something went wrong. Please, try after sometime."
//                                if let message = jsonDict![PARAMETERS.MESSAGE] as? String{
//                                    error_message = message
//                                }
//                                view_screen.view.makeToast(error_message)
//                            }
//
//                            DispatchQueue.main.async{
//                                _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                            }
//                            return
//
//                        }else if let message = jsonDict!["Message"] as? String{
//                            view_screen.view.makeToast(message)
//                            DispatchQueue.main.async{
//                                _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                            }
//                            return
//                        }else{
//                            view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
//                            DispatchQueue.main.async{
//                                _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                            }
//                            return
//                        }
//
//                    } catch _ {
//
//                        print("Exception!")
//                        view_screen.view.makeToast("Whoops, Something went wrong. Please, try after sometime.")
//                        DispatchQueue.main.async{
//                            _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                        }
//                    }
//                }
//            case .failure(let encodingError):
//                print("Image Upload Exception! \(encodingError)")
//                DispatchQueue.main.async{
//                    _ = MBProgressHUD.hideAllHUDsForView(view: view_screen.view, animated: true)
//                }
//            }
//        }
//    }
//
//
    
    
    //    class open func callPostApiImage(api:String, parameters:[String:AnyObject]?,image:UIImage,Name:String, mime_type:String = "image/jpg",File_name : String = "image.jpg",complition:@escaping (AnyObject)->Void){
    //
    //        // Encode Data
    //
    //        let base64EncodedString = toBase64EncodedString(toJsonString(parameters: parameters!))
    //
    //        //let File_name = "image_" + String(arc4random()) + ".jpg"
    //        //        connection_timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(PoorConnection), userInfo: nil, repeats: false)
    //
    //        AF.upload(multipartFormData: { (multipartFormData) in
    //
    //            //            if let Compression_Ratio = kUserDefults_(KEYSPROJECT.COMPRESSION_RATIO) as? String{
    //            //                print(CGFloat((Compression_Ratio as NSString).floatValue))
    //            //                 multipartFormData.append(UIImageJPEGRepresentation(image, CGFloat((Compression_Ratio as NSString).floatValue))!, withName: Name, fileName: File_name, mimeType: mime_type)
    //            //            }else{
    //            multipartFormData.append(image.jpegData(compressionQuality: 0.1)!, withName: Name, fileName: File_name, mimeType: mime_type)
    //            //            }
    //
    //            multipartFormData.append(base64EncodedString.data(using: String.Encoding.utf8)!, withName: PARAMETERS.JSON_DATA)
    //
    //        }, to:api){ (result) in
    //
    //            switch result {
    //
    //            case .success(let upload, _, _):
    //
    //                upload.uploadProgress(closure: { (progress) in
    //
    //                    //                    print(progress)
    //
    //                })
    //
    //                upload.responseJSON { response in
    //
    //                    print(response.result)
    //
    //                    do {
    //
    //                        let jsonDict = try JSONSerialization.jsonObject(with: (response.data as Data?)!, options: []) as? [String:AnyObject]
    //
    //                        if response.error != nil{
    //                            print(response.error as Any, terminator: "")
    //                        }
    //
    //                        if jsonDict == nil
    //                        {
    //                            appDelegate.window?.makeToast("Whoops, Something went wrong. Please, try after sometime.")
    //                            return
    //                        }
    //
    //                        print(jsonDict as Any, terminator: "")
    //
    //                        if let status = jsonDict![PARAMETERS.STATUS] as? String,status.lowercased() == "ok"{
    //
    //                            complition(jsonDict as AnyObject)
    //
    //                        }else if let status = jsonDict![PARAMETERS.STATUS] as? String,status.lowercased() == "fail"{
    //
    //                            if let message = jsonDict![PARAMETERS.MESSAGE] as? String{
    //                                appDelegate.window?.makeToast(message)
    //                            }
    //                            return
    //
    //                        }else if let message = jsonDict!["Message"] as? String{
    //                            appDelegate.window?.makeToast(message)
    //                            _ = MBProgressHUD.hideAllHUDsForView(view: appDelegate.window!, animated: true)
    //                            return
    //                        }else{
    //                            appDelegate.window?.makeToast("Whoops, Something went wrong. Please, try after sometime.")
    //                            _ = MBProgressHUD.hideAllHUDsForView(view: appDelegate.window!, animated: true)
    //                            return
    //                        }
    //
    //                    } catch _ {
    //
    //                        print("Exception!")
    //                        appDelegate.window?.makeToast("Whoops, JSON could not be in the correct format")
    //
    //                        _ = MBProgressHUD.hideAllHUDsForView(view: appDelegate.window!, animated: true)
    //                    }
    //                }
    //
    //            case .failure(let encodingError):
    //
    //                print("",encodingError.localizedDescription)
    //                break
    //
    //            }
    //
    //        }
    //    }
    
    @objc class open func PoorConnection(){
        print("Poor Comnnection")
    }
}

public func toJsonString(parameters:[String:AnyObject]) -> String
{
    var jsonData: NSData?
    do {
        jsonData = try JSONSerialization.data(withJSONObject: parameters, options:JSONSerialization.WritingOptions(rawValue: 0)) as NSData?
    } catch{
        print(error.localizedDescription)
        jsonData = nil
    }
    
    let jsonString = NSString(data: jsonData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
    
    return jsonString
}

public func toBase64EncodedString(_ jsonString : String) -> String
{
    let utf8str = jsonString.data(using: .utf8)
    
    let base64Encoded = utf8str?.base64EncodedString(options: [])
    
    return base64Encoded!
}
