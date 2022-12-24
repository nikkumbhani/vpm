//
//  LoginVC.swift
//  vpm
//
//  Created by Nik Kumbhani on 24/12/22.
//

import UIKit
import LocalAuthentication

class LoginVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var txtUserEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var stackVw: UIStackView!

    var allExistingUsers = [UserData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        allExistingUsers = UserDataModel.allUsers ?? []
    }
    
    // MARK: - API CALL Login
    func loginApiCall(){

        let parameters = [PARAMETERS.client_id: "5IlYhQTzSZL3Ax8TtSmMpnEEdCishQEJ",
                          PARAMETERS.client_secret: "rrBf89OkVL-3CX6HtuHnMct9I6sgTe-xtX9XV2dOkDRdIj7ECRBik4RHBCDmh4H",
                          PARAMETERS.grant_type: "client_credentials",
                          PARAMETERS.audience: "https://giftcards-sandbox.reloadly.com"]

        DispatchQueue.main.async{
            _ = MBProgressHUD.showHUDAddedTo(view: self.view, animated: true)
        }

        AAPWebService.callPostApi(api: WebServices.login, parameters: parameters as [String:AnyObject], view_screen: self) { [self] (data,dict) in

            print(dict)

            DispatchQueue.main.async{
                _ = MBProgressHUD.hideHUDForView(view: self.view, animated: true)
            }

            do {
                
                let loginUserData = try JSONDecoder().decode(LoginUserData.self, from: data)
            
                UserDataModel.loginUserData = loginUserData

                if loginUserData.accessToken != ""{
                    kUserDefults(loginUserData.accessToken as AnyObject, key: PARAMETERS.token)
                    
                    if let NavBar = self.storyboard?.instantiateViewController(withIdentifier: "NavBar"){
                        NavBar.modalPresentationStyle = .overCurrentContext
                        self.present(NavBar, animated: true, completion: nil)
                    }
                }

            }catch{
                self.view.makeToast("Error in JSON parsing")
            }
            
            DispatchQueue.main.async{
                _ = MBProgressHUD.hideHUDForView(view: self.view, animated: true)
            }
        }
    }
    
    // MARK: - Action
    @IBAction func btnLoginAction(_ sender: Any) {
        self.view.endEditing(true)

        if !txtUserEmail.text!.isValidEmail(){
            self.view.makeToast(msg_email)
            return
        }
        
        if txtPassword.text!.isEmptyText(){
            self.view.makeToast(msg_password)
            return
        }
        
        ValidateUser()
    }
    
    func ValidateUser(){
        
        let loginUser = allExistingUsers.first { user in
            return user.email?.lowercased() == txtUserEmail.text!
        }
        
        if loginUser != nil{
            if loginUser?.email == txtUserEmail.text! && loginUser?.password == txtPassword.text!{
                loginApiCall()
            }else{
                self.view.makeToast(msg_invalid)
                return
            }
        }else{
            self.view.makeToast(msg_email_not_exist)
            return
        }
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        
        if let SignUp_VC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC{
            self.navigationController?.pushViewController(SignUp_VC, animated: true)
        }
    }
}
