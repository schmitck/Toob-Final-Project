////
////  Photo.swift
////  FinalProject
////
////  Created by Cooper Schmitz on 4/21/20.
////  Copyright © 2020 Cooper Schmitz. All rights reserved.
////
//
//import Foundation
//import Firebase
//
//class Photo {
//  var image: UIImage!
//  var description: String!
//  var postedBy: String
//  var date: Date
//  var documentUUID: String
//
//  init(image: UIImage, description: String, postedBy: String, date: Date, documentUUID: String) {
//    self.image = image
//    self.description = description
//    self.postedBy = postedBy
//    self.date = date
//    self.documentUUID = documentUUID
//  }
//
//  convenience init() {
//    let postedBy = Auth.auth().currentUser?.email ?? "Unknown User"
//    self.init(image: UIImage(), description: "", postedBy: postedBy, date: Date(), documentUUID: "")
//  }
//
//  func saveData(completed: @escaping (Bool) -> ()) {
//    let db = Firestore.firestore()
//    let storage = Storage.storage()
//    //convert photo.image to a data type so it can be saved by Firebase storage
//    guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
//
//    }
//
//
//     //grab the userID
//     guard let postingUserID = (Auth.auth().currentUser?.uid) else {
//       print("***Error: Could not save data because we don't have a valid postingUserID")
//       return completed(false)
//     }
//    documentUUID = UUID().uuidString //generates a Unique ID to use for the photo images name
//    //create a reference to upload storage with the name we created
//    let storageRef = storage.reference().child("photos").child(self.documentUUID)
//
//
//
//
//
//     //updating any value that we would not have had
//     self.postingUserID = postingUserID
//     //Create the dictionary representing what we want to save
//     let dataToSave = self.dictionary
//     //check to see if we have saved a record, we will have a documentID
//       //this is where we want to work
//       let reference = db.collection("posts").document(self.documentID)
//       reference.setData(dataToSave) { error in
//         if let error = error {
//           print("***ERROR: Updating document \(self.documentID) \(error.localizedDescription)")
//           completed(false)
//         } else {
//           print("Document updated with the ref ID \(reference.documentID)")
//           completed(true)
//         }
//       }
//   }
//
//}
