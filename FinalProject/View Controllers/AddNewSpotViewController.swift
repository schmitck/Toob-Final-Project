//
//  AddNewSpotViewController.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/20/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import UIKit
import Foundation

class AddNewSpotViewController: UIViewController {

  @IBOutlet weak var takenOrChosenImage: UIImageView!
  @IBOutlet weak var newSpotTextView: UITextView!
  @IBOutlet weak var ratingPickerView: UIPickerView!
  
  @IBOutlet weak var ratingLabel: UILabel!
  var rating = [1,2,3,4,5,6,7,8,9,10]
  var post: Post!
  override func viewDidLoad() {
        super.viewDidLoad()

    newSpotTextView.addBorder(width: 0.5, radius: 5, color: .gray)
    
    if post == nil {
      post = Post()
    }
    ratingPickerView.delegate = self
    ratingPickerView.dataSource = self
    
    
    }
    
  func leaveViewController() {
      dismiss(animated: true, completion: nil)
  }
  
  @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    post.description = newSpotTextView.text
    post.saveData { (success) in
      if success {
        self.leaveViewController()
      } else {
        print("Error: Couldn't leave this view controller because the data was not saved.")
      }
    }
  }
  
  @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    leaveViewController()
  }
  
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddNewSpotViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return rating.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    post.rating = rating[row]
    return "\(rating[row])"
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    ratingLabel.text = "\(rating[row])"
  }
}
