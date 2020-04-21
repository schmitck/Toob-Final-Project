//
//  ProfilePageViewController.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/20/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import UIKit
import Firebase

class ProfilePageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
  
}

//extension ViewController: FUIAuthDelegate {
//  func application(_ app: UIApplication, open url: URL,
//                   options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//    let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
//    if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
//      return true
//    }
//    // other URL handling goes here.
//    return false
//  }
//
//  func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
//    // handle user and error as necessary
//    if let user = user {
//      homeTableView.isHidden = false
//      print("😁 We signed in with user \(user.email ?? "Unknown Email")")
//    }
//  }
//
//  func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
//    let loginViewController = FUIAuthPickerViewController(authUI: authUI)
//    loginViewController.view.backgroundColor = UIColor.white
//    //setting up the login image
//    let marginInsets: CGFloat = 16
//    let imageHeight: CGFloat = 225
//    let imageY = self.view.center.y - imageHeight
//    let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageY)
//    let logoImageView = UIImageView(frame: logoFrame)
//    logoImageView.image = UIImage(named: "logo")
//    logoImageView.contentMode = .scaleAspectFit
//    loginViewController.view.addSubview(logoImageView)
//    return loginViewController
//  }
//
//}
