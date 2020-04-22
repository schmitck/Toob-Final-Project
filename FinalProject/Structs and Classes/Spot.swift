//
//  Spot.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/20/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

class Spot {
  var spot: String
  var coordinate: CLLocationCoordinate2D
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
    return ["spot": spot, "longitude": longitude, "latitude": latitude]
  }
  
  init(spot: String, coordinate: CLLocationCoordinate2D, documentID: String) {
    self.spot = spot
    self.coordinate = coordinate
    self.documentID = documentID
  }
  
  convenience init() {
    self.init(spot: "", coordinate: CLLocationCoordinate2D(), documentID: "")
  }
  
  convenience init(dictionary: [String:Any]) {
    let spot = dictionary["spot"] as! String? ?? ""
    let longitude = dictionary["longitude"] as! Double? ?? 0.0
    let latitude = dictionary["latitude"] as! Double? ?? 0.0
    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    
    self.init(spot: spot, coordinate: coordinate, documentID: "")
  }
  
  
   func saveData(member: Member, completed: @escaping (Bool) -> ()) {
       let db = Firestore.firestore()
       //Create the dictionary representing what we want to save
       let dataToSave = self.dictionary
       //check to see if we have saved a record, we will have a documentID
       if self.documentID != "" {
         //this is where we want to work
        let reference = db.collection("members").document(member.documentID).collection("spots").document(self.documentID)
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
        reference = db.collection("members").document(member.documentID).collection("spots").addDocument(data: dataToSave) { error in
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
