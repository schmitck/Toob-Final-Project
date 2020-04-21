//
//  UIView+addBorder.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/20/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  func addBorder(width: CGFloat, radius: CGFloat, color: UIColor) {
    self.layer.borderWidth = width
    self.layer.borderColor = color.cgColor
    self.layer.cornerRadius = radius
  }
  
  func noBorder() {
    self.layer.borderWidth = 0.0
  }
  
}
