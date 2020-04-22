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
  
  @IBOutlet weak var searchButton: UIBarButtonItem!
  @IBOutlet weak var homeTableView: UITableView!
  var members: Members!
  var selectedMembers: Members!
  var member: Member!
  var spot: Spot!
  var spots: Spots!
  var authUI: FUIAuth!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    authUI = FUIAuth.defaultAuthUI()
    authUI.delegate = self
    members = Members()
    spots = Spots()
    selectedMembers = Members()
    homeTableView.dataSource = self
    homeTableView.delegate = self
    spot = Spot(spot: "", coordinate: CLLocationCoordinate2D(), documentID: "")
    print("viewdid")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    members.loadData {
      self.selectedMembers = Members()
      for member in self.members.memberArray {
        if member.isSelected == true {
          print("🗣🗣🗣\(member.place) has beens selected because \(member.isSelected) reads true")
          self.selectedMembers.memberArray.append(member)
        }
      }
      self.homeTableView.reloadData()
    }
    print("viewWill")
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    signIn()
    print("viewDidAppear")
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SpotDetail" {
      let destination = segue.destination as! SpotDetailController
      let selectedIndexPath = homeTableView.indexPathForSelectedRow
      destination.title = selectedMembers.memberArray[selectedIndexPath!.row].place
      destination.member = selectedMembers.memberArray[selectedIndexPath!.row]
      homeTableView.deselectRow(at: selectedIndexPath!, animated: true)
    }
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
    let newMember = source.choosenSpot!
    print(newMember.isSelected)
    newMember.isSelected = true
    print(newMember.isSelected)
    selectedMembers = Members()
    newMember.saveData { (success) in
      if success {
        print("😁Updated value")
      } else {
        print("No update")
      }
    }
    self.homeTableView.reloadData()
  }
  
  @IBAction func signOutPressed(_ sender: UIButton) {
    //TODO: MAYBE TRY TO PRESENT A SEGUE TO THE HOMEPAGE FIRST AND THEN MAKE THE DO TRY THINGY EXECUTE FROM AN UNWIND FROM DETAIL?
    do {
      try authUI!.signOut()
      print("‼️Sign out Worked")
      homeTableView.isHidden = true
      signIn()
    } catch {
      print("Error! Couldn't sign out.")
    }
  }
  
  @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
    if homeTableView.isEditing {
      homeTableView.setEditing(false, animated: true)
      sender.title = "Edit"
      searchButton.isEnabled = true
    } else {
      homeTableView.setEditing(true, animated: true)
      sender.title = "Done"
      searchButton.isEnabled = false
    }
  }
  
  
  
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedMembers.memberArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomePageCell", for: indexPath) as! HomePageTableViewCell
    cell.spotLabel.text = selectedMembers.memberArray[indexPath.row].place
    cell.distanceLabel.text = "\(selectedMembers.memberArray[indexPath.row].latitude), \(selectedMembers.memberArray[indexPath.row].longitude)"
    cell.homePageImage?.roundBorder(cornerRadius: 20, width: 0, color: .init(genericGrayGamma2_2Gray: 1, alpha: 1))
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      selectedMembers.memberArray[indexPath.row].isSelected = false
      selectedMembers.memberArray[indexPath.row].saveData { (success) in
        if success {
          print("‼️Successfuly updated the data")
        } else {
          print("‼️back to the drawing board")
        }
      }
    }
    selectedMembers.memberArray.remove(at: indexPath.row)
    homeTableView.deleteRows(at: [indexPath], with: .fade)
    selectedMembers = Members()
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let itemToMove = selectedMembers.memberArray[sourceIndexPath.row]
    selectedMembers.memberArray.remove(at: sourceIndexPath.row)
    selectedMembers.memberArray.insert(itemToMove, at: destinationIndexPath.row)
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
