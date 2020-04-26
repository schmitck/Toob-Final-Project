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
import Firebase

class ViewController: UIViewController {
  
  @IBOutlet weak var searchButton: UIBarButtonItem!
  @IBOutlet weak var homeTableView: UITableView!
  
  @IBOutlet weak var editButton: UIBarButtonItem!
  
  
  var members = Members()
  var selectedMembers: Members!
  var member: Member!
  var authUI: FUIAuth!
  var averageRating: Double = 0
  var locationManager: CLLocationManager!
  var currentLocation: CLLocation!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let logo = UIImage(named: "tooblogo")
    let imageView = UIImageView(image: logo)
    imageView.contentMode = .scaleAspectFit
    self.navigationItem.titleView = imageView
    editButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Courier New", size: 20)!], for: .normal)
    searchButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Courier New", size: 20)!], for: .normal)
    authUI = FUIAuth.defaultAuthUI()
    authUI.delegate = self
    selectedMembers = Members()
    homeTableView.dataSource = self
    homeTableView.delegate = self
    if self.selectedMembers.memberArray.isEmpty {
      self.homeTableView.isHidden = true
    }
    self.homeTableView.reloadData()
    getLocation()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    members.loadData {
      self.selectedMembers = Members()
      for member in self.members.memberArray {
        if member.isSelected == true {
          //          print("🗣🗣🗣\(member.place) has beens selected because \(member.isSelected) reads true")
          if member.averageRating.isNaN == true {
            member.averageRating = 0
          }
          self.selectedMembers.memberArray.append(member)
        }
      }
      if self.selectedMembers.memberArray.isEmpty {
        self.homeTableView.isHidden = true
      } else {
        self.homeTableView.isHidden = false
      }
      self.homeTableView.reloadData()
    }
    print("viewWill")
    getLocation()
    homeTableView.reloadData()
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    signIn()
    print("viewDidAppear")
    if self.selectedMembers.memberArray.isEmpty {
      self.homeTableView.isHidden = true
    }
    self.homeTableView.reloadData()
    
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SpotDetail" {
      let destination = segue.destination as! SpotDetailController
      let selectedIndexPath = homeTableView.indexPathForSelectedRow!
      print("Selected Row: \(selectedIndexPath.row)")
      destination.title = selectedMembers.memberArray[selectedIndexPath.row].place + "."
      destination.member = selectedMembers.memberArray[selectedIndexPath.row]
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
      if self.selectedMembers.memberArray.isEmpty {
        self.homeTableView.isHidden = true
      } 
      homeTableView.reloadData()
    } else {
      if self.selectedMembers.memberArray.isEmpty {
        self.homeTableView.isHidden = true
      } else {
        homeTableView.isHidden = false
      }
    }
    homeTableView.reloadData()
  }
  
  @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
    if segue.identifier == "unwindFromAddNewSpot" {
      
      let source = segue.source as! NewSpotViewController
      let newMember = source.choosenSpot!
      if newMember.averageRating.isNaN {
        newMember.averageRating =  0.0
      }
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
    if currentLocation != nil {
      var distanceString = ""
      let location = selectedMembers.memberArray[indexPath.row].location
      let distanceInMeters = currentLocation.distance(from: location)
      distanceString = "\((distanceInMeters * 0.00062137).roundTo(places: 1)) Miles Away."
      cell.distanceLabel.text = distanceString
    } else {
      cell.distanceLabel.text = "\(selectedMembers.memberArray[indexPath.row].latitude), \(selectedMembers.memberArray[indexPath.row].longitude)"
    }
    cell.spotLabel.text = selectedMembers.memberArray[indexPath.row].place
    cell.ratingLabel.text = "\(selectedMembers.memberArray[indexPath.row].averageRating.roundTo(places: 2))"
    if selectedMembers.memberArray[indexPath.row].coverPhotoUUID != "" {
      let post = Posts()
      post.loadData(member: selectedMembers.memberArray[indexPath.row]) {
        print("getting image")
        cell.homePageImage.image = post.postsArray.first?.image
        cell.homePageImage?.roundBorder(cornerRadius: 20, width: 0, color: .init(genericGrayGamma2_2Gray: 1, alpha: 1))
        cell.homePageImage.contentMode = .scaleAspectFill
      }
    } else {
      cell.homePageImage.image = UIImage(named: "nophotos")
      cell.homePageImage?.roundBorder(cornerRadius: 20, width: 0, color: .init(genericGrayGamma2_2Gray: 1, alpha: 1))
      cell.homePageImage.contentMode = .scaleAspectFit
    }
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

extension ViewController: CLLocationManagerDelegate {
  
  func getLocation() {
    locationManager = CLLocationManager()
    locationManager.delegate = self
  }
  
  func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .authorizedAlways, .authorizedWhenInUse:
      locationManager.requestLocation()
    case .denied:
      showAlertToPrivacySettings(title: "User has not authorized location services", message: "It may be that parental controls are restricting location use in the app")
    default:
      break
    }
  }
  
  func showAlertToPrivacySettings(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
      print("Something went wrong with the URLString")
      return
    }
    
    let settingsAction = UIAlertAction(title: "Settings", style: .default) { value in
      UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(settingsAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true, completion: nil)
    
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    handleLocationAuthorizationStatus(status: status)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    currentLocation = locations.last
    print("CURRENT LOCATION IS \(currentLocation.coordinate.longitude), \(currentLocation.coordinate.latitude)")
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to get user location")
  }
  
}
