//
//  ViewController.swift
//  vpm
//
//  Created by Nik Kumbhani on 24/12/22.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if isUserLogin(){
                if let NavBar = self.storyboard?.instantiateViewController(withIdentifier: "NavBar"){
                    NavBar.modalPresentationStyle = .overCurrentContext
                    self.present(NavBar, animated: true, completion: nil)
                }
            }else{
                
                if let Login_VC = self.storyboard?.instantiateViewController(withIdentifier: "RootNav"){
                    let tr = CATransition()
                    tr.duration = 0.4
                    tr.type = CATransitionType.moveIn // use "MoveIn" here
                    tr.subtype = CATransitionSubtype.fromTop
                    self.view.window!.layer.add(tr, forKey: kCATransition)
                    Login_VC.modalPresentationStyle = .overCurrentContext
                    self.present(Login_VC, animated: false)
                    
                }
//                if let Login_VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
//                    let tr = CATransition()
//                    tr.duration = 0.4
//                    tr.type = CATransitionType.moveIn // use "MoveIn" here
//                    tr.subtype = CATransitionSubtype.fromTop
//                    self.view.window!.layer.add(tr, forKey: kCATransition)
//                    Login_VC.modalPresentationStyle = .overCurrentContext
//                    self.present(Login_VC, animated: false)
//
//                }
            }
         }
    }
}
