//
//  CategoryCollectionViewCell.swift
//  testAssignment
//
//  Created by SHREDDING on 20.03.2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var caterogyImage: UIImageView!
    
    @IBOutlet weak var categoryTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        self.caterogyImage.image = nil
        self.categoryTitle.text = nil
    }

}
