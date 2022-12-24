//
//  ProductDataModel.swift
//  vpm
//
//  Created by Nik Kumbhani on 24/12/22.
//

import Foundation

class ProductDataModel : Codable {

    static var allProducts : [Product]? {
        get {
            let defaults = UserDefaults.standard
            guard let userData = defaults.object(forKey: "allProducts") as? Data else {
                return nil
            }
            let decoder = JSONDecoder()
            guard let productData = try? decoder.decode([Product].self, from: userData) else {
                return nil
            }
            return productData
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "allProducts")
                defaults.synchronize()
            }
        }
    }
}
