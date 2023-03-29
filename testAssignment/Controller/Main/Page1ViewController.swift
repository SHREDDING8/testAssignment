//
//  Page1ViewController.swift
//  testAssignment
//
//  Created by SHREDDING on 20.03.2023.
//

import UIKit

class Page1ViewController: UIViewController,UIGestureRecognizerDelegate {
    
    override var preferredStatusBarStyle:UIStatusBarStyle{
        return .darkContent
    }
    
        
    // MARK: - Variables
    
    let categories = ["Phones","Headphones","Games","Cars","Furniture","Kids"]
    let brands = ["Nike","Puma","Mersedes","iPhone"]
    
    var timeStartEditing:Date?
    
    var searchWords:[String] = []
    
    var dropDownMenuHeightConstaint:NSLayoutConstraint!
    
    @IBOutlet weak var navigationBar: NavigationBar!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var dropDownMenu: UITableView!
    
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
    
    
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        registerNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.image.image = AppDelegate.user.getProfilephoto()
        self.latestCollectionView.reloadData()
        self.flashSaleCollectionView.reloadData()
    }
    
    // MARK: - configuration (configureViews)
    
    fileprivate func configureViews(){
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setCornerRadius(views: [searchField], cornerRadius: 15.0)
        setPlaceholder(textFields: [searchField], placeholders: ["What are you looking for?"])
        
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
        
        searchField.delegate = self
        dropDownMenu.layer.masksToBounds = true
        dropDownMenu.layer.cornerRadius = 10
        dropDownMenu.translatesAutoresizingMaskIntoConstraints = false
        
        dropDownMenuHeightConstaint = NSLayoutConstraint(item: dropDownMenu!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        
        dropDownMenuHeightConstaint.isActive = true

    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let navVc = navigationController {
          return navVc.viewControllers.count > 1
        }
        return false
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
    
    // MARK: - registerNib
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
    
    
     // MARK: - Navigation
     
    fileprivate func goToPage2(){
        let Page2ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Page2ViewController")
        self.navigationController?.pushViewController(Page2ViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension Page1ViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    // MARK: - numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoryCollectionView{
            return 6
        }else if collectionView == self.latestCollectionView{
            return ApiManager.latestItems?.count ?? 0
        } else if collectionView == self.flashSaleCollectionView{
            return ApiManager.flashSaleItems!.count
        }else if collectionView == self.brandsCollectionView{
            return 4
        }
        return 0
    }
    
    // MARK: - cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.categoryCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell
            cell?.categoryTitle.text = categories[indexPath.row]
            cell?.caterogyImage.image = UIImage(named: categories[indexPath.row])
            return cell ?? UICollectionViewCell()
            
        }else if (collectionView == self.latestCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestCollectionViewCell", for: indexPath) as? LatestCollectionViewCell
            
            cell?.name.text = ApiManager.latestItems![indexPath.row].getName()
            cell?.category.text = ApiManager.latestItems![indexPath.row].getcategory()
            cell?.price.text = "$ " + ApiManager.latestItems![indexPath.row].getPrice()
            cell?.image.image = ApiManager.latestItems![indexPath.row].getImage(index: 0)

            
            return cell!
            
        } else if collectionView == self.flashSaleCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlashScaleCollectionViewCell", for: indexPath) as? FlashScaleCollectionViewCell
            
            cell?.name.text = ApiManager.flashSaleItems![indexPath.row].getName()
            cell?.category.text = ApiManager.flashSaleItems![indexPath.row].getcategory()
            cell?.price.text = "$ " + ApiManager.flashSaleItems![indexPath.row].getPrice()
            cell?.image.image = ApiManager.flashSaleItems![indexPath.row].getImage(index: 0)
            cell?.discount.text = ApiManager.flashSaleItems![indexPath.row].getDiscount() + "% off"
            
            return cell!
        }else if collectionView == self.brandsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCollectionViewCell", for: indexPath) as? BrandsCollectionViewCell
            cell?.image.image = UIImage(named: brands[indexPath.row])
            cell?.name.text = brands[indexPath.row]
            return cell!
        }
        
        return UICollectionViewCell()
    }
    
    // MARK: - didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToPage2()
    }
}


// MARK: - Search Delegate
extension Page1ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        UIView.transition(with: self.dropDownMenu, duration: 0.3) {
            self.dropDownMenuHeightConstaint.constant = 0
            self.view.layoutIfNeeded()
        }
        
        return true
    }
    
    // MARK: - shouldChangeCharactersIn
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.timeStartEditing = .now
        
        UIView.transition(with: self.dropDownMenu, duration: 0.3) {
            self.dropDownMenuHeightConstaint.constant = 0
            self.view.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [self] in
            var now = Date()
            now = .now
            if Double(now.timeIntervalSince(timeStartEditing!)) > 1.0{
                
                ApiManager.loadSearch(inputWord: textField.text ?? "") { words in
                    DispatchQueue.main.async {
                        if words.count > 0{
                            self.searchWords = words
                            
                            self.dropDownMenu.reloadData()
                            
                            let height = words.count > 6 ? 200 : CGFloat(45 * words.count)
                            
                            UIView.transition(with: self.dropDownMenu, duration: 0.3) {
                                self.dropDownMenuHeightConstaint.constant = height
                                self.view.layoutIfNeeded()
                            }
                        }
                    }
                }
            }
        }
        
        return true
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - tableView

extension Page1ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchWords.count
    }
    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var conf = cell.defaultContentConfiguration()
        conf.text = searchWords[indexPath.row]
        conf.textProperties.color = .black
        cell.contentConfiguration = conf
        cell.backgroundColor = .clear
        return cell
    }
}
