//
//  UIImageView+roundedImages.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/21/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
  
  func roundedImage() {
    self.layer.cornerRadius = self.frame.size.width / 2
    self.clipsToBounds = true
  }
  
  func roundBorder(cornerRadius: CGFloat, width: CGFloat, color: CGColor) {
    self.layer.cornerRadius = cornerRadius
    self.clipsToBounds = true
    self.layer.borderColor = color
    self.layer.borderWidth = width
  }
  
}
