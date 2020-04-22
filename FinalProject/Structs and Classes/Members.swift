//
//  Users.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/21/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.


import Foundation
import Firebase
class Members {
var memberArray = [Member]()
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
      self.memberArray = []
      //there are querySnapshot documnets
      for document in querySnapshot!.documents {
        //loads a dictionary up
        let member = Member(dictionary: document.data())
        member.documentID = document.documentID
        self.memberArray.append(member)
      }
      completed()
    }
  }
}
