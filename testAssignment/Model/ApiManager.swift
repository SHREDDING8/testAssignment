//
//  ApiManager.swift
//  testAssignment
//
//  Created by SHREDDING on 22.03.2023.
//

import Foundation
import UIKit

class ApiManager{
    
    // MARK: - URLS
    
    private static let latestUrl = URL(string: "https://run.mocky.io/v3/cc0071a1-f06e-48fa-9e90-b1c2a61eaca7")!
    
    private static let flashSaleUrl = URL(string: "https://run.mocky.io/v3/a9ceeb6e-416d-4352-bde6-2203416576ac")!
    
    public static let searchUrl = URL(string: "https://run.mocky.io/v3/4c9cd822-9479-4509-803d-63197e5a9e19")
    
    public static let page2 = URL(string: "https://run.mocky.io/v3/f7f99d04-4971-45d5-92e0-70333383c239")
    
    // MARK: - list of items
    public static var latestItems:[Item]? = []
    
    public static var flashSaleItems:[Item]? = []
    
    public static var page2Items:[Item]? = []
    
    // MARK: - loadLatest
    static public func loadLatest(completion:@escaping (()->Void) ){
        self.latestItems = []
        let request = URLRequest(url: latestUrl)
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil, data != nil else{
                return
            }
            if let items = try? JSONDecoder().decode(Latest.self, from: data!).latest{
                for index in 0..<items.count{
                    self.loadPhoto(stringUrl: items[index].imageURL) { image in
                        let newItem = Item(category: items[index].category, name: items[index].name, price: items[index].price, images: [image], itemCategory: .latest)
                        latestItems?.append(newItem)
                        if index == items.count - 1 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) ) {
                                completion()
                            }
                        }
                    }
                }
            }
            
        }).resume()
    }
    
    // MARK: - loadFlashSale
    static public func loadFlashSale(completion:@escaping (()->Void)){
        self.flashSaleItems = []
        let request = URLRequest(url: flashSaleUrl)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil, data != nil else{
                return
                
            }
            
            if let items = try? JSONDecoder().decode(FlashSale.self, from: data!).flashSale{
                for index in 0..<items.count{
                    self.loadPhoto(stringUrl: items[index].imageURL) { image in
                        
                        let newItem = Item(category: items[index].category, name: items[index].name, price: items[index].price, images: [image], discount: items[index].discount, itemCategory: .flashSale)
                        flashSaleItems?.append(newItem)
                        
                        
                        if index == items.count - 1 {
                            completion()
                        }
                    }
                }
            }
        }).resume()
    }
    
    
    // MARK: - loadPhoto
    static public func loadPhoto(stringUrl:String, completion:@escaping ((UIImage)->Void) ){
        if let url = URL(string: stringUrl){
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else { return }
                
                if let httpResponse = response as? HTTPURLResponse{
                    if httpResponse.statusCode != 200{
                        
                    }else{
                        if data != nil{
                            let image = UIImage(data: data!) ?? UIImage(named: "no photo")
                            completion(image!)
                        }else{
                            let image = UIImage(named: "no photo")
                            completion(image!)
                        }
                    }
                }
            }.resume()
        }
    }
    
    
    // MARK: - loadSearch
    static public func loadSearch(inputWord:String,completion:@escaping (([String])->Void)){
        let request = URLRequest(url: self.searchUrl!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, data != nil else{ return }
            
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode != 200{
                    print("loadSearch ERROR:")
                }else{
                    if let words = try? JSONDecoder().decode(Search.self, from: data!).words{
                        var trueWords:[String] = []
                        
                        for word in words{
                            if word.localizedStandardContains(inputWord){
                                trueWords.append(word)
                            }
                        }
                        completion(trueWords)
                    }
                }
            }
            
        }.resume()
        
    }
    
    // MARK: - loadPage2
    static public func loadPage2(completion:@escaping (()->Void)){
        self.page2Items = []
        let request = URLRequest(url: self.page2!)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil, data != nil else{ return }
            
            if let item = try? JSONDecoder().decode(Page2.self, from: data!){
                var colors:[UIColor] = []
                var images:[UIImage] = []
                 
                for color in item.colors{
                    colors.append(UIColor(hex: color)!)
                }
                
                for index in 0..<item.imageUrls.count{
                    self.loadPhoto(stringUrl: item.imageUrls[index]) { image in
                        images.append(image)
                        
                        if index == item.imageUrls.count - 1 {
                            
                            let newItem = Item(name: item.name , description: item.description, rating: item.rating, numberOfReviews: item.numberOfReviews, price: item.price, colors: colors, images: images)
                            
                            self.page2Items?.append(newItem)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) ) {
                                completion()
                            }
                        }
                    }
                }
            }
        }).resume()
    }
}
