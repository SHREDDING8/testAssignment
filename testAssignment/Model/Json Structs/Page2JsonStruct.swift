//
//  Page2JsonStruct.swift
//  testAssignment
//
//  Created by SHREDDING on 28.03.2023.
//

import Foundation

// MARK: - Page2
struct Page2: Codable {
    let name, description: String
    let rating: Double
    let numberOfReviews: Int
    let price: Double
    let colors: [String]
    let imageUrls: [String]

    enum CodingKeys: String, CodingKey {
        case name, description, rating
        case numberOfReviews = "number_of_reviews"
        case price, colors
        case imageUrls = "image_urls"
    }
}
