//
//  UserDataModel.swift
//  vpm
//
//  Created by Nik Kumbhani on 24/12/22.
//

import UIKit

class UserDataModel : Codable {
    
    static var loginUserData : LoginUserData? {
        get {
            let defaults = UserDefaults.standard
            guard let userData = defaults.object(forKey: "loginUserData") as? Data else {
                return nil
            }
            let decoder = JSONDecoder()
            guard let loginUser = try? decoder.decode(LoginUserData.self, from: userData) else {
                return nil
            }
            return loginUser
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "loginUserData")
                defaults.synchronize()
            }
        }
    }
    
    static var allUsers : [UserData]? {
        get {
            let defaults = UserDefaults.standard
            guard let userData = defaults.object(forKey: "allUsers") as? Data else {
                return nil
            }
            let decoder = JSONDecoder()
            guard let userData = try? decoder.decode([UserData].self, from: userData) else {
                return nil
            }
            return userData
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "allUsers")
                defaults.synchronize()
            }
        }
    }
}
