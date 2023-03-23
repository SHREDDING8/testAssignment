//
//  FlashScaleCollectionViewCell.swift
//  testAssignment
//
//  Created by SHREDDING on 20.03.2023.
//

import UIKit

class FlashScaleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var discountView: UIView!
    
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var favourite: UIImageView!
    
    @IBOutlet weak var plus: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        categoryView.layer.masksToBounds = true
        discountView.layer.masksToBounds = true
        
        categoryView.layer.cornerRadius = categoryView.frame.height / 2 - 1
        discountView.layer.cornerRadius = discountView.frame.height / 2 - 1
        
        self.image.layer.masksToBounds = true
        self.image.layer.cornerRadius = 30
        
        self.name.layer.masksToBounds = false
        self.price.layer.masksToBounds = false
        
        self.name.layer.shadowColor = UIColor.black.cgColor
        self.price.layer.shadowColor = UIColor.black.cgColor
        
        self.name.layer.shadowRadius = 3.0
        self.name.layer.shadowOpacity = 1.0
        self.name.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.price.layer.shadowRadius = 3.0
        self.price.layer.shadowOpacity = 1.0
        self.price.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }

}
