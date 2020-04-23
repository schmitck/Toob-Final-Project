//
//  roundTo.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/22/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import Foundation
extension Double {
  func roundTo(places: Int) -> Double {
    let tenToPower = pow(10.0, Double((places >= 0 ? places : 0)))
    let roundedValue = (self * tenToPower).rounded() / tenToPower
    return roundedValue
  }
}
