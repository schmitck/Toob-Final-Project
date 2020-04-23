//
//  Photos.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/22/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//


import Foundation
import Firebase
class Photos {
  var photoArray: [Photo] = []
  var db: Firestore!
  
  init() {
    db = Firestore.firestore()
  }
}

