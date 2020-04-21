//
//  ViewController.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/20/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleSignIn
import FirebaseUI

class ViewController: UIViewController {
  
  @IBOutlet weak var homeTableView: UITableView!
  var members: Members!
  var authUI: FUIAuth!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    authUI = FUIAuth.defaultAuthUI()
    authUI.delegate = self
    members = Members()
    homeTableView.dataSource = self
    homeTableView.delegate = self
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    members.loadData {
      self.homeTableView.reloadData()
    }
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    signIn()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destination = segue.destination as! SpotDetailController
      let selectedIndexPath = homeTableView.indexPathForSelectedRow
    destination.title = members.memberArray[selectedIndexPath!.row].place
  }
  
  
  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(alertAction)
    present(alertController, animated: true, completion: nil)
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
    } else {
      homeTableView.isHidden = false
    }
  }
  
  @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
    let source = segue.source as! NewSpotViewController
    let newIndexPath = IndexPath(row: members.memberArray.count, section: 0)
    let newMember = Member(place: source.selectedSpot!.spot, coordinate: source.selectedSpot!.coordinate, postingUserID: "", documentID: "")
    newMember.saveData { (success) in
      if success {
        print("Success saving data!")
      } else {
        print("Failure to save newMember")
      }
    }
      members.memberArray.append(newMember)
       
       homeTableView.insertRows(at: [newIndexPath], with: .bottom)
       homeTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
  }
  
  
  @IBAction func signOutPressed(_ sender: UIButton) {
    do {
      try authUI!.signOut()
      print("‼️Sign out Worked")
      homeTableView.isHidden = true
      signIn()
    } catch {
      print("Error! Couldn't sign out.")
    }
  }
  
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return members.memberArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomePageCell", for: indexPath) as! HomePageTableViewCell
    cell.spotLabel.text = members.memberArray[indexPath.row].place
    cell.distanceLabel.text = "\(members.memberArray[indexPath.row].latitude), \(members.memberArray[indexPath.row].longitude)"
    cell.homePageImage?.roundBorder(cornerRadius: 20, width: 0, color: .init(genericGrayGamma2_2Gray: 1, alpha: 1))
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
  
}

extension ViewController: FUIAuthDelegate {
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
      homeTableView.isHidden = false
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
