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
    }
}
