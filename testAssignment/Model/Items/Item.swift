//
//  Item.swift
//  testAssignment
//
//  Created by SHREDDING on 22.03.2023.
//

import Foundation
import UIKit
enum ItemCategory:Int{
    case latest = 0
    case flashSale = 1
}

class Item{
    private var name: String
    private var description:String?
    private var category:String?
    private var price: Double
    private var images:[UIImage]
    private var itemCategory:ItemCategory?
    private var discount:Int?
    
    private var rating:Double?
    private var numberOfReviews:Int?
    private var colors:[UIColor]?
    
    
    // MARK: - Get funcs
    public func getcategory()->String{
        return self.category ?? ""
    }
    public func getName()->String{
        return self.name
    }
    public func getPrice()->String{
        return String(self.price).replacingOccurrences(of: ".", with: ",")
    }
    public func getNumberPrice()->Double{
        return self.price
    }
    public func getImage(index:Int)->UIImage{
        return self.images[index]
    }
    public func getDiscount()->String{
        return String(self.discount!)
    }
    
    public func getDescription()->String{
        return self.description!
    }
    
    public func getRating()->String{
        return String(self.rating!)
    }
    
    public func getNumberOfViews()->String{
        return String(self.numberOfReviews!)
    }
    public func getNumberOfImages()->Int{
        return self.images.count
    }
    public func getColors()->[UIColor]{
        return self.colors ?? []
    }
    
    // MARK: - init for Latest
    init(category: String, name: String, price: Int, images: [UIImage],itemCategory:ItemCategory) {
        self.category = category
        self.name = name
        self.price = Double(price)
        self.images = images
        self.itemCategory = itemCategory
    }
    
    
    // MARK: - init for flashSale
    init(category: String, name: String, price: Double, images: [UIImage],discount:Int, itemCategory:ItemCategory){
        self.category = category
        self.name = name
        self.price = price
        self.images = images
        self.itemCategory = itemCategory
        self.discount = discount
    }
    
    // MARK: - init for page2
    init(name: String, description: String, rating:Double, numberOfReviews:Int, price: Double, colors:[UIColor], images:[UIImage]){
        self.name = name
        self.description = description
        self.rating = rating
        self.numberOfReviews = numberOfReviews
        self.price = price
        self.colors = colors
        self.images = images
    }
}
