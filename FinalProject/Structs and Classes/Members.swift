//
//  Users.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/21/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.


import Foundation
import Firebase
import FirebaseUI
import FirebaseCoreDiagnostics

class Members {
  var memberArray = [Member]()
  var db: Firestore
  
  init() {
    db = Firestore.firestore()
  }
  
  func loadData(completed: @escaping () -> ()) {
    //add snapshot listener
    let storage = Storage.storage()
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
        print(member.coverPhotoUUID)
        member.documentID = document.documentID
        self.memberArray.append(member)
        
        if member.coverPhotoUUID != "" {
          print("😮😮😮😮GOT A UUID \(member.coverPhotoUUID)")
          var loadAttempts = 0
          let storageRef = storage.reference().child(member.documentID)
          print(member.documentID)
          let photoRef = storageRef.child(member.coverPhotoUUID)
          print(member.coverPhotoUUID)
          photoRef.getData(maxSize: 25 * 1025 * 1025) { (data, error) in
            if let error = error {
              print("Error: an error occured while reading in the photo data \(photoRef) \(error.localizedDescription)")
              loadAttempts += 1
              if loadAttempts >= (querySnapshot!.count) {
                return completed()
              }
            } else {
              let image = UIImage(data: data!)
              member.image = image!
              loadAttempts += 1
              if loadAttempts >= (querySnapshot!.count) {
                return completed()
              }
            }
          }
        }
      }
      completed()
    }
  }
}
