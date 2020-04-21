//
//  Spots.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/21/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import Foundation
import Firebase
class Spots {
var spotArray = [Spot]()
var db: Firestore
  
  init() {
    db = Firestore.firestore()
  }
  
  func loadData(completed: @escaping () -> ()) {
    //add snapshot listener
    db.collection("spots").addSnapshotListener { (querySnapshot, error) in
      //if we get any changes in spots the listner is going to go off
      guard error == nil else {
        print("***ERROR: adding the snapshot listerner \(error?.localizedDescription)")
        return completed()
      }
      //clear out spotArray, which is everything in our tableView, so there will be no duplicates
      self.spotArray = []
      //there are querySnapshot documnets
      for document in querySnapshot!.documents {
        //loads a dictionary up
        let spot = Spot(dictionary: document.data())
//        spot.documentID = document.documentID
        self.spotArray.append(spot)
      }
      completed()
    }
  }
}
