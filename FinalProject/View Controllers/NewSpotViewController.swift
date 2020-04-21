//
//  NewSpotViewController.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/21/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class NewSpotViewController: UIViewController {
  
  @IBOutlet weak var searchSpotsTableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var spots: Spots!
  var selectedSpot: Spot!
  var searchActive: Bool = false
  var filtererdData: [String] = []
  var data: [String] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    spots = Spots()
    searchSpotsTableView.dataSource = self
    searchSpotsTableView.delegate = self
    searchBar.delegate = self
    
    for spot in spots.spotArray {
      data.append(spot.spot)
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    spots.loadData {
      self.searchSpotsTableView.reloadData()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let selectedIndexPath = searchSpotsTableView.indexPathForSelectedRow!
    selectedSpot = spots.spotArray[selectedIndexPath.row]
  }
  
  
}

extension NewSpotViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchActive == true {
      return filtererdData.count
    } else {
    return spots.spotArray.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = searchSpotsTableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
    if searchActive == true {
      cell.textLabel?.text = filtererdData[indexPath.row]
    } else {
    cell.textLabel?.text = spots.spotArray[indexPath.row].spot
    }
    return cell
  }
  
  
}

extension NewSpotViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if data.isEmpty == true {
      for spot in spots.spotArray {
        data.append(spot.spot)
        print(data)
      }
    }
    filtererdData = data.filter({$0.prefix(searchText.count) ==  searchText})
    searchActive = true
    searchSpotsTableView.reloadData()
  }
  
}
