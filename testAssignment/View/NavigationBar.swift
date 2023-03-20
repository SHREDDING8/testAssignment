//
//  NavigationBar.swift
//  testAssignment
//
//  Created by SHREDDING on 20.03.2023.
//

import UIKit

@IBDesignable class NavigationBar: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var image: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    
    private func commonInit() {
            let bundle = Bundle(for: NavigationBar.self)
            bundle.loadNibNamed("NavigationBar", owner: self, options: nil)
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        image.layer.masksToBounds = true
        image.layer.cornerRadius = image.frame.height / 2
        }
}
