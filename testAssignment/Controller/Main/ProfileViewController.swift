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
    
    @IBOutlet weak var uploadButton: UIView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var loadPage: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.configureName()        }
        
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
                print(error)
                self.name.text = ""
            }else{
                self.name.text = firstName! + " "
            }
        })
        
        user.getUserLastNameFromDatabase { error, lastName in
            if error != nil{
                print(error)
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
