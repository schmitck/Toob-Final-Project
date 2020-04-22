//
//  AddNewSpotViewController.swift
//  FinalProject
//
//  Created by Cooper Schmitz on 4/20/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import UIKit
import Foundation
import Contacts

class AddNewSpotViewController: UIViewController {

  @IBOutlet weak var takenOrChosenImage: UIImageView!
  @IBOutlet weak var newSpotTextView: UITextView!
  @IBOutlet weak var ratingPickerView: UIPickerView!
  
  @IBOutlet weak var ratingLabel: UILabel!
  var rating = [1,2,3,4,5,6,7,8,9,10]
  var post: Post!
  var member: Member!
  var imagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
        super.viewDidLoad()

    newSpotTextView.addBorder(width: 0.5, radius: 5, color: .gray)
    guard let member = member else {
      print("***ERROR: Did not have a valid spot in review detail VC")
      return
    }
    if post == nil {
      post = Post(spot: member.place, rating: 0, description: "", date: Date(), postingUserID: "", documentID: "")
    }
    ratingPickerView.delegate = self
    ratingPickerView.dataSource = self
    
    }
    
  func leaveViewController() {
      dismiss(animated: true, completion: nil)
  }
  
  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(alertAction)
    present(alertController, animated: true, completion: nil)
  }
  
  
  @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    post.description = newSpotTextView.text
    post.saveData(member: member) { (success) in
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
  
  @IBAction func takePhotoButtonPressed(_ sender: UIButton) {
    let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
    let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
      self.accessCamera()
    }
  }
  
  
  @IBAction func photoLibraryButtonPressed(_ sender: UIButton) {
  }
  
  
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



extension AddNewSpotViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func accessLibrary() {
    imagePicker.sourceType = .photoLibrary
    present(imagePicker, animated: true, completion: nil)
  }
  
  func accessCamera() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      imagePicker.sourceType = .camera
         present(imagePicker, animated: true, completion: nil)
    } else {
      showAlert(title: "Camera not available!", message: "There is no camera available to use on this device.")
    }
  }
}
