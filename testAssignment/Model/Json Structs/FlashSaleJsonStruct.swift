//
//  FlashSaleJsonStruct.swift
//  testAssignment
//
//  Created by SHREDDING on 22.03.2023.
//

import Foundation

// MARK: - FlashSale
struct FlashSale: Codable {
    let flashSale: [FlashSaleElement]

    enum CodingKeys: String, CodingKey {
        case flashSale = "flash_sale"
    }
}

// MARK: - FlashSaleElement
struct FlashSaleElement: Codable {
    let category, name: String
    let price: Double
    let discount: Int
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case category, name, price, discount
        case imageURL = "image_url"
    }
}
