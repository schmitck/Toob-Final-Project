//
//  SpotDetailController.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/20/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import UIKit

//private let dateFormatter: DateFormatter = {
//    //just created a DATEFORMATTER
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "EEEE"
//    return dateFormatter
//}()
//
//private let hourlyFormatter: DateFormatter = {
//    //just created a DATEFORMATTER
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "h aaaa"
//    return dateFormatter
//}()


class SpotDetailController: UIViewController {
  
  @IBOutlet weak var postsTableView: UITableView!
  
  let posts = Posts()
  var member: Member!
  var totalRatingsCount: Double = 0
  var averageRating: Double = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    postsTableView.dataSource = self
    postsTableView.delegate = self
    posts.loadData(member: member) {
      print("viewdidload")
      self.posts.postsArray.sort(by: {$0.postNumber > $1.postNumber})
      self.postsTableView.reloadData()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("viewwillappear")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    for post in posts.postsArray {
      print(post.rating)
      totalRatingsCount = totalRatingsCount + Double(post.rating)
    }
    averageRating = totalRatingsCount/Double(posts.postsArray.count)
    print("This is the total ratings! \(totalRatingsCount) and this is the average \(averageRating) from \(posts.postsArray.count) posts!")
    
    member.averageRating = averageRating
    member.saveData { (success) in
      if success {
        print("saved the average rating! VIEWDIDAPPEAR")
      }
    }
    print("viewDidAppear")
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
    newPost.saveData(member: source.member) { (success) in
        if success {
              print("")
            } else {
              print("Error: Couldn't leave this view controller because the data was not saved.")
            }
    }
    posts.postsArray.append(newPost)
    totalRatingsCount = 0
    for post in posts.postsArray {
      print(post.rating)
      totalRatingsCount = totalRatingsCount + Double(post.rating)
    }
    averageRating = totalRatingsCount/Double(posts.postsArray.count)
    print("This is the total ratings! \(totalRatingsCount) and this is the average \(averageRating) from \(posts.postsArray.count) posts!")
    
    member.averageRating = averageRating
    member.saveData { (success) in
      if success {
        print("saved the average rating! VIEWDIDAPPEAR")
      }
    }
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
    cell.postedImage?.roundBorder(cornerRadius: 30, width: 0, color: .init(genericGrayGamma2_2Gray: 1, alpha: 1))
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 320
  }
  
}
