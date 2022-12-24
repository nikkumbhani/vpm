//
//  LoginUserData.swift
//  vpm
//
//  Created by Nik Kumbhani on 24/12/22.
//

import Foundation

// MARK: - LoginUserData
class LoginUserData: Codable {
    var accessToken, scope: String?
    var expiresIn: Int?
    var tokenType: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }

    init(accessToken: String?, scope: String?, expiresIn: Int?, tokenType: String?) {
        self.accessToken = accessToken
        self.scope = scope
        self.expiresIn = expiresIn
        self.tokenType = tokenType
    }
//    init(from decoder: Decoder) throws
//        {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//            accessToken = try? values.decode(String.self, forKey: .accessToken)
//            scope = try? values.decode(String.self, forKey: .scope)
//            expiresIn = try? values.decode(Int.self, forKey: .expiresIn)
//            tokenType = try? values.decode(String.self, forKey: .tokenType)
//    }
}
