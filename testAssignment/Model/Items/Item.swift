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
    private var category:String
    private var price: Double
    private var images:[UIImage]
    private var itemCategory:ItemCategory
    private var discount:Int?
    
    private var rating:Double?
    private var numberOfReviews:Int?
    private var colors:[UIColor]?
    
    
    public func getcategory()->String{
        return self.category
    }
    public func getName()->String{
        return self.name
    }
    public func getPrice()->String{
        return String(self.price).replacingOccurrences(of: ".", with: ",")
    }
    public func getImage(index:Int)->UIImage{
        return self.images[index]
    }
    public func getDiscount()->String{
        return String(self.discount!)
    }
    
    init(category: String, name: String, price: Int, images: [UIImage],itemCategory:ItemCategory) {
        self.category = category
        self.name = name
        self.price = Double(price)
        self.images = images
        self.itemCategory = itemCategory
    }
    
    init(category: String, name: String, price: Double, images: [UIImage],discount:Int, itemCategory:ItemCategory){
        self.category = category
        self.name = name
        self.price = price
        self.images = images
        self.itemCategory = itemCategory
        self.discount = discount
    }
}
