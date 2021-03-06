//
//  ProfilePageViewController.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/20/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class ProfilePageViewController: UIViewController {
  
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var userLocationLabel: UILabel!
  var posts = Posts()
  var member = Member()
  var userPosts: [Posts] = []
  var userPost: [Post] = []
  var members = Members()
  var authUI: FUIAuth!
  override func viewDidLoad() {
    super.viewDidLoad()
    authUI = FUIAuth.defaultAuthUI()
    authUI.delegate = self
    members.loadData {
    }
    
    for members in members.memberArray {
      print(members.place)
    }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    var num = 0
    if num == 0 {
      members.loadData {
        print("loaded members data")
        num += 1
        if num == 1 {
          for members in self.members.memberArray {
            repeat {
              self.posts.loadData(member: members) {
                print("saved post")
                print(self.posts.postsArray.count)
                self.userPosts.append(self.posts)
                print(self.userPosts.count)
              }
            } while self.posts.postsArray == nil
            print(self.userPosts.count)
            self.member = self.members.memberArray[0]
            
            self.posts.loadData(member: self.member) {
              print("Completed")
            }
          }
        }
      }
    }
    
  }
  
  
  func signIn() {
    let providers: [FUIAuthProvider] = [
      FUIGoogleAuth(), FUIEmailAuth(),
    ]
    
    if authUI.auth?.currentUser == nil {
      self.authUI.providers = providers
      let loginViewController = authUI.authViewController()
      loginViewController.modalPresentationStyle = .fullScreen
      present(loginViewController, animated: true, completion: nil)
    }
  }
  
  @IBAction func signOutButtonPressed(_ sender: UIButton) {
    do {
      try authUI!.signOut()
      print("‼️Sign out Worked")
      tabBarController?.selectedIndex = 0
      signIn()
    } catch {
      print("Error! Couldn't sign out.")
    }
    
  }
  
  @IBAction func reloadPhotosButtonPressed(_ sender: UIButton) {
    for post in self.posts.postsArray {
      print(post.postingUserID)
    }
  }
  
  
  
}


extension ProfilePageViewController: FUIAuthDelegate {
  func application(_ app: UIApplication, open url: URL,
                   options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
    if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
      return true
    }
    // other URL handling goes here.
    return false
  }
  
  func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
    // handle user and error as necessary
    if let user = user {
      print("😁 We signed in with user \(user.email ?? "Unknown Email")")
    }
  }
  
  func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
    let loginViewController = FUIAuthPickerViewController(authUI: authUI)
    loginViewController.view.backgroundColor = UIColor.white
    //setting up the login image
    let marginInsets: CGFloat = 16
    let imageHeight: CGFloat = 225
    let imageY = self.view.center.y - imageHeight
    let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageY)
    let logoImageView = UIImageView(frame: logoFrame)
    logoImageView.image = UIImage(named: "logo")
    logoImageView.contentMode = .scaleAspectFit
    loginViewController.view.addSubview(logoImageView)
    return loginViewController
  }
  
}
