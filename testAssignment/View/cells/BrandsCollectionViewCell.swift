//
//  BrandsCollectionViewCell.swift
//  testAssignment
//
//  Created by SHREDDING on 21.03.2023.
//

import UIKit

class BrandsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
        
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.image.image = nil
        self.name.text = nil
        self.image.layer.masksToBounds = true
        self.image.layer.cornerRadius = 15
        
        self.name.layer.masksToBounds = false
        self.name.layer.shadowColor = UIColor.black.cgColor
        
        self.name.layer.shadowRadius = 3.0
    
        self.name.layer.shadowOpacity = 1.0
        self.name.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
