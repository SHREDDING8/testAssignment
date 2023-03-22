//
//  SceneDelegate.swift
//  testAssignment
//
//  Created by SHREDDING on 15.03.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var isUser = false
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
//                guard let windowScene = (scene as? UIWindowScene) else { return }
//                self.window = UIWindow(windowScene: windowScene )
//                self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuUITabBarController")
//                self.window?.makeKeyAndVisible()
        
        
        Auth.auth().addStateDidChangeListener { [self] auth, user in
            
            if user == nil{
                self.isUser = false
                showSignInPage()
            }
            else{
                self.isUser = true
                showSignInPage()
            }
            
            guard let _ = (scene as? UIWindowScene) else { return }
        }
        
        func showSignInPage(){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .coverVertical
            if !AppDelegate.user.getIsLogin(){
                self.window?.rootViewController?.present(vc, animated: true)
            }
            if isUser && !AppDelegate.user.getIsLogin(){
                vc.goToMainPage()
            }
        }
                
        func sceneDidEnterBackground(_ scene: UIScene) {
            // Called as the scene transitions from the foreground to the background.
            // Use this method to save data, release shared resources, and store enough scene-specific state information
            // to restore the scene back to its current state.
            
            // Save changes in the application's managed object context when the application transitions to the background.
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        }
        
        
    }
    
}
