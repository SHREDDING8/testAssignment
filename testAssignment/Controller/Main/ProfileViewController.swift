//
//  MainViewController.swift
//  testAssignment
//
//  Created by SHREDDING on 18.03.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class ProfileViewController: UIViewController {
    let user = User()
    
    
    // MARK: - variables
    
    let imagesTableView = ["restore","help","logOut"]
    let labelTableview = ["Trade store","Payment method","Balance","Trade hostory","Restore Purchase","Help","Log out"]
    
    
    // MARK: - outlets
    @IBOutlet weak var tableViewProfile: UITableView!
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var uploadButton: UIView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var loadPage: UIView!
    
    @IBOutlet weak var changePhotoButton: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let imagePicker:UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.configureName()
        }
        
        configureViews()
        configureTableView()
        configureButtonUpload()
        
        // Do any additional setup after loading the view.
    }
    
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    
    // MARK: - Configuration
    fileprivate func configureViews(){
        imagePicker.delegate = self
        
        self.changePhotoButton.isUserInteractionEnabled = true
        self.profilePhoto.isUserInteractionEnabled = true
        let gestureChangePhoto = UITapGestureRecognizer(target: self, action: #selector(tapChangePhoto))
        changePhotoButton.addGestureRecognizer(gestureChangePhoto)
        self.profilePhoto.addGestureRecognizer(gestureChangePhoto)
        
        setCornerRadius(views: [profilePhoto], cornerRadius: 30.0)
        
    
    }
    
    fileprivate func configureTableView(){
        tableViewProfile.showsVerticalScrollIndicator = false
    }
    fileprivate func configureButtonUpload(){
        uploadButton.layer.masksToBounds = true
        uploadButton.layer.cornerRadius = 15
    }
    
    
    
    fileprivate func configureName(){
        user.getUserFirstNameFromDatabase(completion: { error, firstName in
            if error != nil{
                self.name.text = ""
            }else{
                self.name.text = firstName! + " "
            }
        })
        
        user.getUserLastNameFromDatabase { error, lastName in
            if error != nil{
                self.name.text! += ""
            }else{
                self.name.text! += lastName!
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            UIView.transition(with: self.loadPage, duration: 0.3,options: .transitionCrossDissolve) {
                self.loadPage.layer.opacity = 0
                
            }
            self.loadPage.isHidden = true
            
        }
    }
    
    fileprivate func setCornerRadius(views:[UIView],cornerRadius:Double){
        for view in views{
            view.layer.masksToBounds = true
            view.layer.cornerRadius = CGFloat(cornerRadius)
        }
    }
    
    // MARK: - Actions
    
   @objc fileprivate func tapChangePhoto(){
       let alert = UIAlertController(title: "Change photo", message: "Select how you want to upload photo", preferredStyle: .actionSheet)
       let actionLibary = UIAlertAction(title: "Library", style: .default) { [self] _ in
           imagePicker.sourceType = .photoLibrary
           self.present(imagePicker, animated: true)
       }
       let actionCamera = UIAlertAction(title: "Camera", style: .default) { [self] _ in
           imagePicker.sourceType = .camera
           self.present(imagePicker, animated: true)
           
       }
       let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
       alert.addAction(actionLibary)
       alert.addAction(actionCamera)
       alert.addAction(actionCancel)
       self.present(alert, animated: true)
    }
    
    
    // MARK: - tableView Delegate
}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")
        
        switch indexPath.row{
        case 2:
            (cell?.viewWithTag(3) as! UIImageView).isHidden = true
            (cell?.viewWithTag(4) as! UILabel).isHidden = false
        case 4:
            (cell?.viewWithTag(1) as! UIImageView).image = UIImage(named: imagesTableView[0])
        case 5:
            (cell?.viewWithTag(1) as! UIImageView).image = UIImage(named: imagesTableView[1])
            (cell?.viewWithTag(3) as! UIImageView).isHidden = true
        case 6:
            (cell?.viewWithTag(1) as! UIImageView).image = UIImage(named: imagesTableView[2])
            (cell?.viewWithTag(3) as! UIImageView).isHidden = true
        default:
            break
        }
        (cell?.viewWithTag(2) as! UILabel).text = labelTableview[indexPath.row]
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row{
        case 6:
            signOut()
        default:
            break
        }
    }
}

// MARK: - UiImagePicker Delegate
extension ProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            self.profilePhoto.image = image
        }
        self.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
