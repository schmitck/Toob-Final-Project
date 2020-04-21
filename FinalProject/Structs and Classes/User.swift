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

class Member {
  var place: String
  var coordinate: CLLocationCoordinate2D
  var postingUserID: String
  var documentID: String
  
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
    return ["place": place, "longitude": longitude, "latitude": latitude, "postingUserID": postingUserID]
  }
  
  init(place: String, coordinate: CLLocationCoordinate2D, postingUserID: String, documentID: String) {
    self.place = place
    self.coordinate = coordinate
    self.postingUserID = postingUserID
    self.documentID = documentID
  }
  
  convenience init() {
    self.init(place: "", coordinate: CLLocationCoordinate2D(), postingUserID: "", documentID: "")
  }
  
  convenience init(dictionary: [String:Any]) {
    let place = dictionary["place"] as! String? ?? ""
    let longitude = dictionary["longitude"] as! Double? ?? 0.0
    let latitude = dictionary["latitude"] as! Double? ?? 0.0
    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    let postingUserID = dictionary["postingUserID"] as! String? ?? ""
    
    self.init(place: place, coordinate: coordinate, postingUserID: postingUserID, documentID: "")
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
      let reference = db.collection("members").document(self.documentID)
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
      reference = db.collection("members").addDocument(data: dataToSave) { error in
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