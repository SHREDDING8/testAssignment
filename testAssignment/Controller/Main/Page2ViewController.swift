//
//  Page2ViewController.swift
//  testAssignment
//
//  Created by SHREDDING on 26.03.2023.
//

import UIKit

class Page2ViewController: UIViewController {
    
    // MARK: - my Variables
    
    private var selectedIndexPhoto = 0
    private var selectedIndexColor:Int?
    
    // MARK: - Outlets

    @IBOutlet weak var collectionViewBigPhoto: UICollectionView!
    
    @IBOutlet weak var collectionViewSmallPhoto: UICollectionView!
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    
    @IBOutlet weak var addToCartGlobalView: UIView!
    
    @IBOutlet weak var dopAddToCartGlobalView: UIView!
    
    @IBOutlet weak var minusButton: UIView!
    
    @IBOutlet weak var plusButton: UIView!
    
    @IBOutlet weak var addToCartButton: UIView!
    
    
    
    @IBOutlet weak var backButton: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var numberOfViewsLabel: UILabel!
    
    @IBOutlet weak var numberOfItems: UILabel!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    
    @IBOutlet weak var loadPage: UIView!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()

    }
    override func viewWillAppear(_ animated: Bool) {
        ApiManager.loadPage2 {
            let item:Item = ApiManager.page2Items![0]
            self.nameLabel.text = item.getName()
            self.descriptionLabel.text = item.getDescription()
            self.priceLabel.text = "$ " +  item.getPrice()
            self.ratingLabel.text = item.getRating()
            self.numberOfViewsLabel.text = "(\(item.getNumberOfViews()) reviews)"
            self.collectionViewBigPhoto.reloadData()
            self.collectionViewSmallPhoto.reloadData()
            self.colorCollectionView.reloadData()
            
            UIView.transition(with: self.loadPage, duration: 1,options: .transitionCrossDissolve) {
                    self.loadPage.layer.opacity = 0
                }
                self.loadPage.isHidden = true
                self.activityView.stopAnimating()
        }
    }
    
    
    // MARK: - Configuration
    fileprivate func configureViews(){
        
        self.addToCartGlobalView.layer.masksToBounds = true
        self.addToCartGlobalView.layer.cornerRadius = (self.tabBarController?.tabBar.layer.cornerRadius)!
        
        self.dopAddToCartGlobalView.layer.masksToBounds = true
        self.dopAddToCartGlobalView.layer.cornerRadius = (self.tabBarController?.tabBar.layer.cornerRadius)!
        
        self.minusButton.layer.masksToBounds = true
        self.plusButton.layer.masksToBounds = true
        self.addToCartButton.layer.masksToBounds = true
        
        self.minusButton.layer.cornerRadius = self.minusButton.frame.height / 2 - 3
        self.plusButton.layer.cornerRadius = self.plusButton.frame.height / 2 - 3
        self.addToCartButton.layer.cornerRadius = self.addToCartButton.frame.height / 2 - 7
        
        self.collectionViewSmallPhoto.layer.masksToBounds = false
        self.colorCollectionView.layer.masksToBounds = false
        
        
        self.backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        self.plusButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusItem)))
        self.minusButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(minusItem)))
    }
    
    // MARK: - Actions (goBack)
    
    @objc fileprivate func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - plusItem
    @objc fileprivate func plusItem(){
        self.numberOfItems.text = String(Int(self.numberOfItems.text!)! + 1)
        if ApiManager.page2Items?.count == 0{
            return
        }
        self.totalPrice.text = "$ \(String(Double(self.numberOfItems.text!)! * ApiManager.page2Items![0].getNumberPrice()))"
    }
    
    // MARK: - minusItem
    @objc fileprivate func minusItem(){
        if Int(self.numberOfItems.text!) != 0{
            self.numberOfItems.text = String(Int(self.numberOfItems.text!)! - 1)
            if ApiManager.page2Items?.count == 0{
                return
            }
            self.totalPrice.text = "$ \(String(Double(self.numberOfItems.text!)! * ApiManager.page2Items![0].getNumberPrice()))"
        }
    }
}


// MARK: - CollectionDelegate
extension Page2ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    // MARK: - numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ApiManager.page2Items?.count ?? 0 > 0{
            if collectionView.restorationIdentifier == "ColorCollectionView"{
                return ApiManager.page2Items?[0].getColors().count ?? 0
            }
            return ApiManager.page2Items?[0].getNumberOfImages() ?? 0
        }
        
        return 0
       
    }
    
    // MARK: - cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.restorationIdentifier == "CollectionViewBigPhoto"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BigPhotoCell", for: indexPath)
            
            (cell.viewWithTag(1) as! UIImageView).image = ApiManager.page2Items![0].getImage(index: indexPath.row)
            
            return cell
        }else if collectionView.restorationIdentifier == "CollectionViewSmallPhoto"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmallPhotoCell", for: indexPath)
            
            (cell.viewWithTag(2) as! UIImageView).image = ApiManager.page2Items![0].getImage(index: indexPath.row)
            
            if indexPath.row == selectedIndexPhoto{
                cell.layer.masksToBounds = false
                cell.clipsToBounds = false
                
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowRadius = 5.0
                cell.layer.shadowOffset = CGSize(width: 0, height: 5)
                cell.layer.shadowOpacity = 0.0
                
                UIView.animate(withDuration: 0.3) {
                    cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    cell.layer.shadowOpacity = 0.6
                }
                
            }else{
                    cell.layer.shadowOpacity = 0.0
            }
            
            return cell
        } else if collectionView.restorationIdentifier == "ColorCollectionView"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
            
            cell.clipsToBounds = true
            cell.layer.masksToBounds = true
            
            cell.layer.cornerRadius = 10
            
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.gray.cgColor
            
            let colorView = (cell.viewWithTag(3)!)
            colorView.backgroundColor = ApiManager.page2Items![0].getColors()[indexPath.row]
            
            
            if indexPath.row == selectedIndexColor{

                UIView.animate(withDuration: 0.3) {
                    cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }
            }
            return cell
        }
        
        return UICollectionViewCell()
        
        
    }
    // MARK: - collectionViewLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.restorationIdentifier == "CollectionViewBigPhoto"{
            return CGSize(width: self.collectionViewBigPhoto.frame.width, height: self.collectionViewBigPhoto.frame.height)
        } else if collectionView.restorationIdentifier == "CollectionViewSmallPhoto"{
            
            return CGSize(width: 90, height: self.collectionViewSmallPhoto.frame.height / 2 + 10)
                        
        } else if collectionView.restorationIdentifier == "ColorCollectionView"{
            return CGSize(width: 50, height: self.colorCollectionView.frame.height)
        }
        return CGSize.zero
    }
    
    // MARK: - minimumLineSpacingForSectionAt
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.restorationIdentifier == "CollectionViewBigPhoto"{
            return 0
        }else if collectionView.restorationIdentifier == "CollectionViewSmallPhoto" {
            return 10
        }else if collectionView.restorationIdentifier == "ColorCollectionView"{
            return 15
        }
        
        return 0
    }
    
    // MARK: - scrollViewDidEndDecelerating
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.restorationIdentifier == "CollectionViewBigPhoto"{
            let pageWidth = scrollView.frame.size.width
            let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
            let oldSelectedIndexPhoto = self.selectedIndexPhoto
        self.selectedIndexPhoto = page
            if self.selectedIndexPhoto != oldSelectedIndexPhoto{
                self.collectionViewSmallPhoto.reloadData()
            }
        }
            
        }
    
    // MARK: - didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.restorationIdentifier == "CollectionViewSmallPhoto"{
            self.collectionViewBigPhoto.scrollToItem(at: indexPath, at: .centeredHorizontally , animated: true)
            let oldSelectedIndexPhoto = self.selectedIndexPhoto
            self.selectedIndexPhoto = indexPath.row
            if self.selectedIndexPhoto != oldSelectedIndexPhoto{
                self.collectionViewSmallPhoto.reloadData()
            }
        } else if collectionView.restorationIdentifier == "ColorCollectionView"{
            selectedIndexColor = selectedIndexColor != indexPath.row ? indexPath.row : nil
            self.colorCollectionView.reloadData()
        }
    }
    
    // MARK: - insetForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.restorationIdentifier == "CollectionViewSmallPhoto"{
            
            let totalCellWidth = 90 * 3
            let totalSpacingWidth = 10 * (3 - 1)
            
            let leftInset = (self.collectionViewSmallPhoto.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        } else {
            return UIEdgeInsets()
        }
    }

}
