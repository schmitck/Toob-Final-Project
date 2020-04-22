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
  
  override func viewDidLoad() {
        super.viewDidLoad()
    postsTableView.dataSource = self
    postsTableView.delegate = self
    
    }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    posts.loadData(member: member) {
      self.posts.postsArray.reverse()
      self.postsTableView.reloadData()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let navigationController = segue.destination as! UINavigationController
    let destination = navigationController.viewControllers.first as! AddNewSpotViewController
    destination.member = member
    if let selectedIndexPath = postsTableView.indexPathForSelectedRow {
      postsTableView.deselectRow(at: selectedIndexPath, animated: true)
    }
  }
  
  func dateFormat(date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    let dateString = dateFormatter.string(from: date)
    return dateString
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
    return 250
  }
  
}
