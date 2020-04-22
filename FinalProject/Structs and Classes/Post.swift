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
import FirebaseUI

class Post {
  var spot: String
  var rating: Int
  var description: String
  var postingUserID: String
  var documentID: String
  var date: Date
  
  
  
  var dictionary: [String:Any] {
    return ["spot": spot, "rating": rating, "description": description, "date": date, "postingUserID": postingUserID]
  }
  
  init(spot: String, rating: Int, description: String, date: Date, postingUserID: String, documentID: String) {
    self.spot = spot
    self.rating = rating
    self.description = description
    self.postingUserID = postingUserID
    self.documentID = documentID
    self.date = date
  }
  
  convenience init() {
    let currentUserID = Auth.auth().currentUser?.email ?? "Unknown User"
    self.init(spot: "", rating: 0, description: "", date: Date(), postingUserID: currentUserID, documentID: "")
    
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
  
  func saveData(member: Member, completed: @escaping (Bool) -> ()) {
      let db = Firestore.firestore()
      //Create the dictionary representing what we want to save
      let dataToSave = self.dictionary
      //check to see if we have saved a record, we will have a documentID
      if self.documentID != "" {
        //this is where we want to work
       let reference = db.collection("members").document(member.documentID).collection("posts").document(self.documentID)
        reference.setData(dataToSave) { error in
          if let error = error {
            print("***ERROR: Updating document \(self.documentID) in spot \(member.documentID) \(error.localizedDescription)")
            completed(false)
          } else {
            print("Document updated with the ref ID \(reference.documentID)")
            completed(true)
          }
        }
      } else {
        var reference: DocumentReference? = nil
       reference = db.collection("members").document(member.documentID).collection("posts").addDocument(data: dataToSave) { error in
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
  
//
//  func savePhoto(completed: @escaping (Bool) -> ()) {
//    let db = Firestore.firestore()
//    let storage = Storage.storage()
//    //grab the userID
//    guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
//      print("***Error: Could not save photo because we don't have a valid photoData")
//      return completed(false)
//    }
//    documentUUID = UUID().uuidString
//    let storageRef = storage.reference().child(self.documentUUID)
//    let uploadTask = storageRef.putData(photoData)
//
//    uploadTask.observe(.success) { snapshot in
//      let dataToSave = self.dictionary
//      //check to see if we have saved a record, we will have a documentID
//      //this is where we want to work
//      let reference = db.collection("photos").document(self.documentUUID)
//      reference.setData(dataToSave) { error in
//        if let error = error {
//          print("***ERROR: Updating document \(self.documentID) \(error.localizedDescription)")
//          completed(false)
//        } else {
//          print("Document updated with the ref ID \(reference.documentID)")
//          completed(true)
//        }
//
//        uploadTask.observe(.failure) { (snapshot) in
//          if let error = snapshot.error {
//            print("Error with photo: Could not upload image with UUID: \(self.documentUUID) and error \(error.localizedDescription)")
//            return completed(false)
//
//          }
//        }
//
//      }
//
//    }
  }
  
  
  







