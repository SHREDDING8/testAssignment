//
//  Page1ViewController.swift
//  testAssignment
//
//  Created by SHREDDING on 20.03.2023.
//

import UIKit

class Page1ViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: NavigationBar!
    
    let searchGlobalView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        return view
    }()
    
    let searchImageView:UIImageView = {
        let view = UIImageView(frame: CGRect(x: -20, y: -7, width: 15, height: 15))
        view.image =  UIImage(systemName: "magnifyingglass")
        view.contentMode = .scaleAspectFill
        return view
        
    }()
    
    @IBOutlet weak var searchField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.image.image = AppDelegate.user.getProfilephoto()
    }
    
    
    // MARK: - configuration
    
    public func configureViews(){
        setCornerRadius(views: [searchField], cornerRadius: 15.0)
        setPlaceholder(textFields: [searchField], placeholders: ["What are you loocking for?"])
        
        searchGlobalView.addSubview(searchImageView)
        searchField.rightView = searchGlobalView
        
        searchField.rightView?.tintColor = .darkGray
        searchField.rightViewMode = .always
        searchField.layer.borderColor = UIColor.darkGray.cgColor
        searchField.layer.borderWidth = 1
        
    }
    
    fileprivate func setCornerRadius(views:[UIView],cornerRadius:Double){
        for view in views{
            view.layer.masksToBounds = true
            view.layer.cornerRadius = CGFloat(cornerRadius)
        }
    }
    
    fileprivate func setPlaceholder(textFields:[UITextField],placeholders:[String]){
        let placeHolderAttrubites = NSAttributedString(
            string: "placeholder", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Placeholder")!])
        for index in 0..<textFields.count{
            textFields[index].attributedPlaceholder = placeHolderAttrubites
            textFields[index].placeholder = placeholders[index]
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
