//
//  Posts.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/20/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import Foundation
import Firebase
import FirebaseUI
import FirebaseInstallations

class Posts {
  var postsArray: [Post] = []
  var photoArray: [Post] = []
  var db: Firestore
  
  init() {
    db = Firestore.firestore()
  }
  
  func loadData(member: Member, completed: @escaping () -> ()) {
    guard member.documentID != "" else {
      return
    }
    let storage = Storage.storage()
    //add snapshot listener
    db.collection("spots").document(member.documentID).collection("posts").addSnapshotListener { (querySnapshot, error) in
      //if we get any changes in spots the listner is going to go off
      guard error == nil else {
        print("***ERROR: adding the snapshot listerner \(error?.localizedDescription)")
        return completed()
      }
      //clear out spotArray, which is everything in our tableView, so there will be no duplicates
      self.postsArray = []
      var loadAttempts = 0
      let storageRef = storage.reference().child(member.documentID)
      //there are querySnapshot documnets
      for document in querySnapshot!.documents {
        //loads a dictioKKnary up
        let post = Post(dictionary: document.data())
        post.documentID = document.documentID
        self.postsArray.append(post)
        
        let photoRef = storageRef.child(post.documentUUID)
        photoRef.getData(maxSize: 25 * 1025 * 1025) { (data, error) in
          if let error = error {
            print("Error: an error occured while reading in the photo data \(photoRef) \(error.localizedDescription)")
            loadAttempts += 1
            if loadAttempts >= (querySnapshot!.count) {
              return completed()
            }
          } else {
            let image = UIImage(data: data!)
            post.image = image!
            loadAttempts += 1
            if loadAttempts >= (querySnapshot!.count) {
              return completed()
            }
          }
        }
        
      }
    }
  }
  
  
  func loadPhoto(member: Member, completed: @escaping () -> ()) {
    guard member.documentID != "" else {
      return
    }
    //add snapshot listener
    let storage = Storage.storage()
    db.collection("spots").document(member.documentID).collection("photos").addSnapshotListener { (querySnapshot, error) in
      //if we get any changes in spots the listner is going to go off
      guard error == nil else {
        print("***ERROR: adding the snapshot listerner \(error?.localizedDescription)")
        return completed()
      }
      //clear out spotArray, which is everything in our tableView, so there will be no duplicates
      self.photoArray = []
      var loadAttempts = 0
      let storageRef = storage.reference().child(member.documentID)
      
      //there are querySnapshot documnets
      for document in querySnapshot!.documents {
        //loads a dictioKKnary up
        let photo = Post(dictionary: document.data())
        photo.documentUUID = document.documentID
        self.photoArray.append(photo)
        //loading firebase storage photos
        let photoRef = storageRef.child(photo.documentUUID)
        photoRef.getData(maxSize: 25 * 1025 * 1025) { data, error in
          if let error = error {
            print("Error: An error occurred while reading data from file ref: \(photoRef) \(error.localizedDescription)")
            loadAttempts += 1
            if loadAttempts >= (querySnapshot!.count) {
              return completed()
            }
          } else {
            let image = UIImage(data: data!)
            photo.image = image!
            loadAttempts += 1
            if loadAttempts >= (querySnapshot!.count) {
              return completed()
            }
            
          }
          
        }
      }
    }
  }
}
