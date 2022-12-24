//
//  SignUpVC.swift
//  vpm
//
//  Created by Nik Kumbhani on 24/12/22.
//

import UIKit

import UIKit
import LocalAuthentication

class SignUpVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtUserEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var stackVw: UIStackView!
    
    var objUserData: UserData?
    var allExistingUsers = [UserData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allExistingUsers = UserDataModel.allUsers ?? []
    }
     
    // MARK: - Action Login
    @IBAction func btnLoginAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Action SignUp
    @IBAction func btnSignUpAction(_ sender: Any) {
        self.view.endEditing(true)

        if txtUserName.text!.isEmptyText(){
            self.view.makeToast(msg_username)
            return
        }
        
        if !txtUserEmail.text!.isValidEmail(){
            self.view.makeToast(msg_email)
            return
        }
        
        if txtPassword.text!.isEmptyText(){
            self.view.makeToast(msg_password)
            return
        }

        // Sign Up user
        let isUserExist = allExistingUsers.first { user in
            return user.email?.lowercased() == txtUserEmail.text!
        }
        
        if isUserExist != nil{
            self.view.makeToast(msg_email_exist)
            return
        }else{
            allExistingUsers.insert(UserData(name: txtUserName.text!, email: txtUserEmail.text!, password: txtPassword.text!), at: 0)
            UserDataModel.allUsers = allExistingUsers
            
            self.view.makeToast(msg_user_register)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
