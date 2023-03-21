//
//  LatestCollectionViewCell.swift
//  testAssignment
//
//  Created by SHREDDING on 20.03.2023.
//

import UIKit

class LatestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var categoryView: UIView!
    
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var plus: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryView.layer.masksToBounds = true
        categoryView.layer.cornerRadius = categoryView.frame.height / 2 - 1
        self.image.layer.masksToBounds = true
        self.image.layer.cornerRadius = 15
    }

}
