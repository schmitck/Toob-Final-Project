//
//  Spot.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/20/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import Foundation
import CoreLocation

class Spot {
  var spot: String
  var coordinate: CLLocationCoordinate2D
  
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
  
  init(spot: String, coordinate: CLLocationCoordinate2D) {
    self.spot = spot
    self.coordinate = coordinate
  }
  
  convenience init() {
    self.init(spot: "", coordinate: CLLocationCoordinate2D())
  }
  
  convenience init(dictionary: [String:Any]) {
    let spot = dictionary["spot"] as! String? ?? ""
    let longitude = dictionary["longitude"] as! Double? ?? 0.0
    let latitude = dictionary["latitude"] as! Double? ?? 0.0
    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    
    self.init(spot: spot, coordinate: coordinate)
  }
  
}
