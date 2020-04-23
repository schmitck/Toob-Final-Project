//
//  Photo.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/21/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import Foundation
import Firebase

class Photo {
  var image: UIImage!
  var description: String!
  var postedBy: String
  var date: Date
  var documentUUID: String
  
  var dictionary: [String:Any] {
    return ["description": description, "postedBy": postedBy, "date": date]
  }

  init(image: UIImage, description: String, postedBy: String, date: Date, documentUUID: String) {
    self.image = image
    self.description = description
    self.postedBy = postedBy
    self.date = date
    self.documentUUID = documentUUID
  }

  convenience init() {
    let postedBy = Auth.auth().currentUser?.email ?? "Unknown User"
    self.init(image: UIImage(), description: "", postedBy: postedBy, date: Date(), documentUUID: "")
  }

  func saveData(member: Member, completed: @escaping (Bool) -> ()) {
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
