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
  var postNumber: Int
  var description: String
  var postingUserID: String
  var documentID: String
  var date: Date
  var image: UIImage!
  var documentUUID: String
  
  
  
  var dictionary: [String:Any] {
    return ["spot": spot, "rating": rating, "postNumber": postNumber, "description": description, "date": date, "postingUserID": postingUserID, "documentUUID": documentUUID]
  }
  
  init(spot: String, rating: Int, postNumber: Int, description: String, date: Date, postingUserID: String, documentID: String, image: UIImage, documentUUID: String) {
    self.spot = spot
    self.rating = rating
    self.postNumber = postNumber
    self.description = description
    self.postingUserID = postingUserID
    self.documentID = documentID
    self.date = date
    self.image = image
    self.documentUUID = documentUUID
  }
  
  convenience init() {
    //    let currentUserID = Auth.auth().currentUser?.email ?? "Unknown User"
    self.init(spot: "", rating: 0, postNumber: 0, description: "", date: Date(), postingUserID: "", documentID: "", image: UIImage(), documentUUID: "")
    
  }
  
  convenience init(dictionary: [String:Any]) {
    let spot = dictionary["spot"] as! String? ?? ""
    let rating = dictionary["rating"] as! Int? ?? 0
    let postNumber = dictionary["postNumber"] as! Int? ?? 0
    let postingUserID = dictionary["postingUserID"] as! String? ?? ""
    let firebaseDate = dictionary["date"] as! Timestamp? ?? Timestamp()
    let date = firebaseDate.dateValue()
    let description = dictionary["description"] as! String? ?? ""
    let documentUUID = dictionary["documentUUID"] as! String? ?? ""
    
    self.init(spot: spot, rating: rating, postNumber: postNumber, description: description, date: date, postingUserID: postingUserID, documentID: "", image: UIImage(), documentUUID: documentUUID)
  }
  
  func saveData(member: Member, completed: @escaping (Bool) -> ()) {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    guard let postingUserID = (Auth.auth().currentUser?.email) else {
      print("***Error: Could not save data because we don't have a valid postingUserID")
      return completed(false)
    }
    guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
      return completed(false)
    }
    documentUUID = UUID().uuidString
    self.postingUserID = postingUserID
    let dataToSave = self.dictionary
    let storageRef = storage.reference().child(member.documentID).child(self.documentUUID)
    let uploadTask = storageRef.putData(photoData)
    if self.documentID != "" {
      let reference = db.collection("spots").document(member.documentID).collection("posts").document(self.documentID)
      reference.setData(dataToSave) { error in
        if let error = error {
          print("***ERROR: Updating document \(self.documentID) in spot \(member.documentID) \(error.localizedDescription)")
          completed(false)
        } else {
          print("Document updated with the ref ID \(reference.documentID)")
          completed(true)
        }
      }
      uploadTask.observe(.success) { (snapshot) in
        let dataToSave = self.dictionary
        let reference = db.collection("spots").document(member.documentID).collection("photos").document(self.documentUUID)
        reference.setData(dataToSave) { error in
          if let error = error {
            print("***ERROR: Updating document \(self.documentUUID) \(error.localizedDescription)")
            completed(false)
          } else {
            print("Document updated with the ref ID \(reference.documentID)")
            completed(true)
          }
        }
      }
      
      uploadTask.observe(.failure) { (snapshot) in
        if let error = snapshot.error {
          print("ERROR WITH UPLOAD TASK")
        }
        return completed(false)
      }
    } else {
      var reference: DocumentReference? = nil
      reference = db.collection("spots").document(member.documentID).collection("posts").addDocument(data: dataToSave) { error in
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
  
  func savePhoto(member: Member, completed: @escaping (Bool) -> ()) {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    //convert photo.image to a data type so it can be saved by Firebase storage
    guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
      return completed(false)
    }
    documentUUID = UUID().uuidString //generates a Unique ID to use for the photo images name
    //create a reference to upload storage with the name we created
    let storageRef = storage.reference().child(member.documentID).child(self.documentUUID)
    let uploadTask = storageRef.putData(photoData)
    
    uploadTask.observe(.success) { (snapshot) in
      let dataToSave = self.dictionary
      let reference = db.collection("spots").document(member.documentID).collection("photos").document(self.documentUUID)
      reference.setData(dataToSave) { error in
        if let error = error {
          print("***ERROR: Updating document \(self.documentUUID) \(error.localizedDescription)")
          completed(false)
        } else {
          print("Document updated with the ref ID \(reference.documentID)")
          completed(true)
        }
      }
    }
    
    uploadTask.observe(.failure) { (snapshot) in
      if let error = snapshot.error {
        print("ERROR WITH UPLOAD TASK")
      }
      return completed(false)
    }
    
  }
  
}










