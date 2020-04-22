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
  
  var members: Members!
  var choosenSpot: Member!
  var searchActive: Bool = false
  var filtererdData: [String] = []
  var data: [String] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    members = Members()
    
    searchSpotsTableView.dataSource = self
    searchSpotsTableView.delegate = self
    searchBar.delegate = self
    
    for member in members.memberArray {
      data.append(member.place)
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    members.loadData {
      self.searchSpotsTableView.reloadData()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let selectedIndexPath = searchSpotsTableView.indexPathForSelectedRow!
    choosenSpot = members.memberArray[selectedIndexPath.row]
//    if choosenSpot.isSelected == true {
//      shouldPerformSegue(withIdentifier: "AddNewSpot") {
//      return false
//      }
//      print("Already chosen!")
//      showAlert(title: "Already Chosen!", message: "Choose a different!")
//    }
    
  }
  
  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(alertAction)
    present(alertController, animated: true, completion: nil)
  }
  
}

extension NewSpotViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchActive == true {
      return filtererdData.count
    } else {
    return members.memberArray.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = searchSpotsTableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
    if members.memberArray[indexPath.row].isSelected == true {
      cell.isUserInteractionEnabled = false
      cell.detailTextLabel?.text = "Selected"
      cell.textLabel?.textColor = .white
      cell.detailTextLabel?.textColor = .white
      cell.backgroundColor = .gray
    } else {
      cell.detailTextLabel?.text = ""
    }
    
    if searchActive == true {
      cell.textLabel?.text = filtererdData[indexPath.row]
    } else {
      cell.textLabel?.text = members.memberArray[indexPath.row].place
    }
    return cell
  }
  
  
}

extension NewSpotViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if data.isEmpty == true {
      for member in members.memberArray {
        data.append(member.place)
        print(data)
      }
    }
    filtererdData = data.filter({$0.prefix(searchText.count) ==  searchText})
    searchActive = true
    searchSpotsTableView.reloadData()
  }
  
}
