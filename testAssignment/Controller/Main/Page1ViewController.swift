//
//  Page1ViewController.swift
//  testAssignment
//
//  Created by SHREDDING on 20.03.2023.
//

import UIKit

class Page1ViewController: UIViewController {
    
    // MARK: - Variables
    
    let categories = ["Phones","Headphones","Games","Cars","Furniture","Kids"]
    let brands = ["Nike","Puma","Mersedes","iPhone"]
    
    @IBOutlet weak var navigationBar: NavigationBar!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    
    @IBOutlet weak var latestCollectionView: UICollectionView!
    
    
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    
    @IBOutlet weak var flashSaleCollectionView: UICollectionView!
    
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
        registerNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.image.image = AppDelegate.user.getProfilephoto()
    }
    
    
    // MARK: - configuration
    
    fileprivate func configureViews(){
        setCornerRadius(views: [searchField], cornerRadius: 15.0)
        setPlaceholder(textFields: [searchField], placeholders: ["What are you loocking for?"])
        
        searchGlobalView.addSubview(searchImageView)
        searchField.rightView = searchGlobalView
        
        searchField.rightView?.tintColor = .darkGray
        searchField.rightViewMode = .always
        searchField.layer.borderColor = UIColor.darkGray.cgColor
        searchField.layer.borderWidth = 1
        
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
        self.latestCollectionView.delegate = self
        self.latestCollectionView.dataSource = self
        self.flashSaleCollectionView.delegate = self
        self.flashSaleCollectionView.dataSource = self
        self.brandsCollectionView.delegate = self
        self.brandsCollectionView.dataSource = self
        
    }
    
    fileprivate func registerNib(){
        let nibCategory = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        self.categoryCollectionView.register(nibCategory, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        let nibLatest = UINib(nibName: "LatestCollectionViewCell", bundle: nil)
        self.latestCollectionView.register(nibLatest, forCellWithReuseIdentifier: "LatestCollectionViewCell")
        
        let nibFlashSale = UINib(nibName: "FlashScaleCollectionViewCell", bundle: nil)
        self.flashSaleCollectionView.register(nibFlashSale, forCellWithReuseIdentifier: "FlashScaleCollectionViewCell")
        
        let nibBranbs = UINib(nibName: "BrandsCollectionViewCell", bundle: nil)
        self.brandsCollectionView.register(nibBranbs, forCellWithReuseIdentifier: "BrandsCollectionViewCell")
        
        
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
extension Page1ViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoryCollectionView{
            return 6
        }else if collectionView == self.latestCollectionView{
            return 6
        } else if collectionView == self.flashSaleCollectionView{
            return 6
        }else if collectionView == self.brandsCollectionView{
            return 4
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.categoryCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell
            cell?.categoryTitle.text = categories[indexPath.row]
            cell?.caterogyImage.image = UIImage(named: categories[indexPath.row])
            return cell ?? UICollectionViewCell()
        }else if (collectionView == self.latestCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestCollectionViewCell", for: indexPath) as? LatestCollectionViewCell
            return cell ?? UICollectionViewCell()
        } else if collectionView == self.flashSaleCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlashScaleCollectionViewCell", for: indexPath) as? FlashScaleCollectionViewCell
            return cell ?? UICollectionViewCell()
        }else if collectionView == self.brandsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCollectionViewCell", for: indexPath) as? BrandsCollectionViewCell
            
            cell?.image.image = UIImage(named: brands[indexPath.row])
            cell?.name.text = brands[indexPath.row]
            return cell ?? UICollectionViewCell()
        }
        
        
        return UICollectionViewCell()
    }
}
