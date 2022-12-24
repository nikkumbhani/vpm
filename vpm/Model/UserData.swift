//
//  UserData.swift
//  vpm
//
//  Created by Nik Kumbhani on 24/12/22.
//

import Foundation

// MARK: - UserData
struct UserData: Codable {
    let name, email, password: String?
    
    init(name: String?, email: String?, password: String?) {
        self.name = name
        self.email = email
        self.password = password
    }
}
