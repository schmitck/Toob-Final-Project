//
//  SpotDetailController.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/20/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import UIKit

class SpotDetailController: UIViewController {

  @IBOutlet weak var spotTableView: UITableView!
  
  let posts = Posts()
  var postSpot = ""
  
  override func viewDidLoad() {
        super.viewDidLoad()
    spotTableView.dataSource = self
    spotTableView.delegate = self
    postSpot = self.title ?? ""
    
    }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    posts.loadData {
      self.spotTableView.reloadData()
    }
  }
  
  
}

extension SpotDetailController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.postsArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = spotTableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as! SpotDetailCell
    cell.ratingLabel.text = "\(posts.postsArray[indexPath.row].rating)"
    cell.descriptionLabel.text = posts.postsArray[indexPath.row].description
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 250
  }
  
}
