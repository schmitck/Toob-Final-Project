//
//  SpotDetailController.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/20/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class SpotDetailController: UIViewController {
  
  @IBOutlet weak var postsTableView: UITableView!
  
  let posts = Posts()
  var member: Member!
  var totalRatingsCount: Double = 0
  var averageRating: Double = 0
  @IBOutlet weak var favoritesButton: UIBarButtonItem!
  
  @IBOutlet weak var addSpotButton: UIBarButtonItem!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Courier New", size: 20)!]
    favoritesButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Courier New", size: 20)!], for: .normal)
    addSpotButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Courier New", size: 20)!], for: .normal)
    postsTableView.dataSource = self
    postsTableView.delegate = self
    member.coverPhotoUUID = posts.postsArray.first?.documentUUID ?? ""
    posts.loadData(member: member) {
      self.posts.postsArray.sort(by: {$0.postNumber > $1.postNumber})
      if self.posts.postsArray.count == 0 {
        self.postsTableView.isHidden = true
      }
      self.postsTableView.reloadData()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    for post in posts.postsArray {
      print(post.rating)
      totalRatingsCount = totalRatingsCount + Double(post.rating)
    }
    averageRating = totalRatingsCount/Double(posts.postsArray.count)
    member.coverPhotoUUID = posts.postsArray.first?.documentUUID ?? ""
    member.averageRating = averageRating
    member.saveData { (success) in
      if success {
        print("")
      }
    }
    
    if self.posts.postsArray.count == 0 {
      self.postsTableView.isHidden = true
    }
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let navigationController = segue.destination as? UINavigationController {
      let destination = navigationController.viewControllers.first as! AddNewSpotViewController
      destination.member = member
      destination.postNumber = posts.postsArray.first?.postNumber ?? 0
      if let selectedIndexPath = postsTableView.indexPathForSelectedRow {
        destination.postNumber = posts.postsArray[selectedIndexPath.row].postNumber
        postsTableView.deselectRow(at: selectedIndexPath, animated: true)
      }
    }
    
  }
  
  
  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(alertAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func dateFormat(date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    let dateString = dateFormatter.string(from: date)
    return dateString
  }
  
  @IBAction func unwindFromAddNewSpot(segue: UIStoryboardSegue) {
    
    let source = segue.source as! AddNewSpotViewController
    let newPost = source.post!
    newPost.description = source.newSpotTextView.text
    newPost.postNumber = source.postNumber + 1
    newPost.documentUUID = source.post.documentUUID
    newPost.image = source.takenOrChosenImage.image
    newPost.postingUserID = Auth.auth().currentUser?.email ?? "Unknown Email"
    newPost.saveData(member: source.member) { (success) in
      if success {
        print("")
      } else {
        print("Error: Couldn't leave this view controller because the data was not saved.")
      }
    }
    posts.postsArray.append(newPost)
    
    //update the average rating
    totalRatingsCount = 0
    for post in posts.postsArray {
      print(post.rating)
      totalRatingsCount = totalRatingsCount + Double(post.rating)
    }
    averageRating = totalRatingsCount/Double(posts.postsArray.count)
    member.coverPhotoUUID = source.post.documentUUID
    member.averageRating = averageRating
    member.saveData { (success) in
      if success {
      }
    }
    posts.loadData(member: member) {
      self.posts.postsArray.sort(by: {$0.postNumber > $1.postNumber})
      self.postsTableView.reloadData()
    }
    self.postsTableView.reloadData()
  }
  
  
  @IBAction func backButtonPressed(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
}

extension SpotDetailController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.postsArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = postsTableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as! SpotDetailCell
    cell.ratingLabel.text = "\(posts.postsArray[indexPath.row].rating)"
    cell.descriptionLabel.text = posts.postsArray[indexPath.row].description
    cell.dateLabel.text = dateFormat(date: posts.postsArray[indexPath.row].date, format: "MMM d, yyyy")
    cell.timeLabel.text = dateFormat(date: posts.postsArray[indexPath.row].date, format: "h:mm a")
    cell.postedImage.image = posts.postsArray[indexPath.row].image
    cell.postedImage?.roundBorder(cornerRadius: 30, width: 0, color: .init(genericGrayGamma2_2Gray: 1, alpha: 1))
    cell.descriptionLabel.sizeToFit()
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 300
  }
  
}
