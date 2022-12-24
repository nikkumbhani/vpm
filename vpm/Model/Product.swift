//
//  Product.swift
//  vpm
//
//  Created by Nik Kumbhani on 24/12/22.
//

import Foundation

import Foundation

// MARK: - ProductElement
class Product: Codable {
    var productID: Int?
    var productName: String?
    var discountPercentage: Double?
    var denominationType, recipientCurrencyCode: String?
    var logoUrls: [String]?
    var brand: Brand?
    var country: Country?
    var redeemInstruction: RedeemInstruction?
    
    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case productName, discountPercentage, denominationType, recipientCurrencyCode, logoUrls, brand, country, redeemInstruction
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        productID = try? values.decode(Int.self, forKey: .productID)
        productName = try? values.decode(String.self, forKey: .productName)
        discountPercentage = try? values.decode(Double.self, forKey: .discountPercentage)
        denominationType = try? values.decode(String.self, forKey: .denominationType)
        recipientCurrencyCode = try? values.decode(String.self, forKey: .recipientCurrencyCode)
        logoUrls = try? values.decode([String].self, forKey: .logoUrls)
        brand = try? values.decode(Brand.self, forKey: .brand)
        country = try? values.decode(Country.self, forKey: .country)
        redeemInstruction = try? values.decode(RedeemInstruction.self, forKey: .redeemInstruction)
    }
    
    init(productID: Int?, productName: String?, discountPercentage: Double?, denominationType: String?, recipientCurrencyCode: String?, logoUrls: [String]?, brand: Brand?, country: Country?, redeemInstruction: RedeemInstruction?) {
        self.productID = productID
        self.productName = productName
        self.discountPercentage = discountPercentage
        self.denominationType = denominationType
        self.recipientCurrencyCode = recipientCurrencyCode
        self.logoUrls = logoUrls
        self.brand = brand
        self.country = country
        self.redeemInstruction = redeemInstruction
    }
}

// MARK: - Brand
class Brand: Codable {
    var brandID: Int?
    var brandName: String?
    
    enum CodingKeys: String, CodingKey {
        case brandID = "brandId"
        case brandName
    }
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        brandID = try? values.decode(Int.self, forKey: .brandID)
        brandName = try? values.decode(String.self, forKey: .brandName)
    }
    
    init(brandID: Int?, brandName: String?) {
        self.brandID = brandID
        self.brandName = brandName
    }
    
    
}

// MARK: - Country
class Country: Codable {
    var isoName, name: String?
    var flagURL: String?
    
    enum CodingKeys: String, CodingKey {
        case isoName, name
        case flagURL = "flagUrl"
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isoName = try? values.decode(String.self, forKey: .isoName)
        name = try? values.decode(String.self, forKey: .name)
        flagURL = try? values.decode(String.self, forKey: .flagURL)
    }
    
    init(isoName: String?, name: String?, flagURL: String?) {
        self.isoName = isoName
        self.name = name
        self.flagURL = flagURL
    }
}

// MARK: - RedeemInstruction
struct RedeemInstruction: Codable {
    var concise, verbose: String?
    
    init(concise: String?, verbose: String?) {
        self.concise = concise
        self.verbose = verbose
    }
}
