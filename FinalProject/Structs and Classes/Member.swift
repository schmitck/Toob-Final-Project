//
//  User.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/21/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import FirebaseUI


class Member {
  var place: String
  var coordinate: CLLocationCoordinate2D
  var isSelected: Bool
  var averageRating: Double
  var postingUserID: String
  var documentID: String
  var coverPhotoUUID: String
  var image: UIImage!
  
  var longitude: CLLocationDegrees {
    return coordinate.longitude
  }
  
  var latitude: CLLocationDegrees {
    return coordinate.latitude
  }
  
  var location: CLLocation {
    return CLLocation(latitude: latitude, longitude: longitude)
  }
  
  
  var dictionary: [String:Any] {
    return ["place": place, "longitude": longitude, "latitude": latitude, "isSelected": isSelected, "averageRating": averageRating, "postingUserID": postingUserID,
            "coverPhotoUUID": coverPhotoUUID]
  }
  
  init(place: String, coordinate: CLLocationCoordinate2D, isSelected: Bool, averageRating: Double, postingUserID: String, documentID: String, coverPhotoUUID: String, image: UIImage) {
    self.place = place
    self.coordinate = coordinate
    self.isSelected = isSelected
    self.averageRating = averageRating
    self.postingUserID = postingUserID
    self.documentID = documentID
    self.coverPhotoUUID = coverPhotoUUID
    self.image = image
  }
  
  convenience init() {
    self.init(place: "", coordinate: CLLocationCoordinate2D(), isSelected: false, averageRating: 0.0, postingUserID: "", documentID: "", coverPhotoUUID: "", image: UIImage())
  }
  
  convenience init(dictionary: [String:Any]) {
    let place = dictionary["place"] as! String? ?? ""
    let longitude = dictionary["longitude"] as! Double? ?? 0.0
    let latitude = dictionary["latitude"] as! Double? ?? 0.0
    let isSelected = dictionary["isSelected"] as! Bool? ?? false
    let averageRating = dictionary["averageRating"] as! Double? ?? 0.0
    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    let postingUserID = dictionary["postingUserID"] as! String? ?? ""
    let coverPhotoUUID = dictionary["coverPhotoUUID"] as! String? ?? ""
    
    self.init(place: place, coordinate: coordinate, isSelected:isSelected, averageRating: averageRating, postingUserID: postingUserID, documentID: "", coverPhotoUUID: coverPhotoUUID, image: UIImage())
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
      let reference = db.collection("spots").document(self.documentID)
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
      reference = db.collection("spots").addDocument(data: dataToSave) { error in
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
