//
//  Wave.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/20/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

class Post {
  var spot: String
  var rating: Int
  var description: String
  var postingUserID: String
  var documentID: String
  var date: Date
  

  
  var dictionary: [String:Any] {
    return ["spot": spot, "rating": rating, "description": description, "postingUserID": postingUserID]
  }
  
  init(spot: String, rating: Int, description: String, date: Date, postingUserID: String, documentID: String) {
    self.spot = spot
    self.rating = rating
    self.postingUserID = postingUserID
    self.documentID = documentID
    self.date = date
    self.description = description
  }
  
  convenience init() {
    self.init(spot: "", rating: 0, description: "", date: Date(), postingUserID: "", documentID: "")
  }
  
  convenience init(dictionary: [String:Any]) {
    let spot = dictionary["spot"] as! String? ?? ""
    let rating = dictionary["rating"] as! Int? ?? 0
    let postingUserID = dictionary["postingUserID"] as! String? ?? ""
    let firebaseDate = dictionary["date"] as! Timestamp? ?? Timestamp()
    let date = firebaseDate.dateValue()
    let description = dictionary["description"] as! String? ?? ""
    
    self.init(spot: spot, rating: rating, description: description, date: date, postingUserID: postingUserID, documentID: "")
  }
  
  func saveData(completed: @escaping (Bool) -> ()) {
    let db = Firestore.firestore()
    //grab the userID
    guard let postingUserID = (Auth.auth().currentUser?.uid) else {
      print("***Error: Could not save data because we don't have a valid postingUserID")
      return completed(false)
    }
    //updating any value that we would not have had
    self.postingUserID = postingUserID
    //Create the dictionary representing what we want to save
    let dataToSave = self.dictionary
    //check to see if we have saved a record, we will have a documentID
    if self.documentID != "" {
      //this is where we want to work
      let reference = db.collection("posts").document(self.documentID)
      reference.setData(dataToSave) { error in
        if let error = error {
          print("***ERROR: Updating document \(self.documentID) \(error.localizedDescription)")
          completed(false)
        } else {
          print("Document updated with the ref ID \(reference.documentID)")
          completed(true)
        }
      }
    } else {
      var reference: DocumentReference? = nil
      reference = db.collection("posts").addDocument(data: dataToSave) { error in
        if let error = error {
          print("***ERROR: Updating document \(self.documentID) \(error.localizedDescription)")
          completed(false)
        } else {
          print("Document updated with the ref ID \(reference?.documentID ?? "Unknown")")
          completed(true)
        }
      }
    }
  }
  
}

