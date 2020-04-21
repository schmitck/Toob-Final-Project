//
//  Posts.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/20/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import Foundation
import Firebase

class Posts {
  var postsArray: [Post] = []
  var db: Firestore
  
  init() {
    db = Firestore.firestore()
  }
  
  func loadData(completed: @escaping () -> ()) {
      //add snapshot listener
      db.collection("posts").addSnapshotListener { (querySnapshot, error) in
        //if we get any changes in spots the listner is going to go off
        guard error == nil else {
          print("***ERROR: adding the snapshot listerner \(error?.localizedDescription)")
          return completed()
        }
        //clear out spotArray, which is everything in our tableView, so there will be no duplicates
        self.postsArray = []
        //there are querySnapshot documnets
        for document in querySnapshot!.documents {
          //loads a dictionary up
          let post = Post(dictionary: document.data())
  //        spot.documentID = document.documentID
          self.postsArray.append(post)
        }
        completed()
      }
    }
}
