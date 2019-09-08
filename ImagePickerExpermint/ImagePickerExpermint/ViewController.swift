//
//  ViewController.swift
//  ImagePickerExpermint
//
//  Created by Kawthar Khalid al-Tamimi on 9/8/19.
//  Copyright © 2019 Kawthar Khalid al-Tamimi. All rights reserved.
//


import UIKit
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate {
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    
    let pickerController = UIImagePickerController()
    // cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSAttributedString.Key.strokeWidth:  5.5,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate()
        self.setUIText(textField: topText)
        self.setUIText(textField: bottomText)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Disabling the Camera Button
        cameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Subscribe to keyboard notifications, to allow the view to raise when necessary
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func delegate(){
        self.topText.delegate = self
        self.bottomText.delegate = self
        self.pickerController.delegate = self
        pickerController.allowsEditing = true
    }
    
    func setUIText(textField: UITextField){
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    
    @IBAction func shareImage(_ sender: Any) {
        let controller = UIActivityViewController(activityItems: [imagePickerView.image ?? "", topText.text ?? ""], applicationActivities: nil)
        present(controller,animated: true,completion: nil)
    }
    
    @IBAction func pickAnImageFromPhotoLibrary(_ sender: Any) {
        self.ImagePickerSourceType(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        self.ImagePickerSourceType(sourceType: .camera)
    }
    
    // Present image depending on sourceType
    func ImagePickerSourceType(sourceType: UIImagePickerController.SourceType) {
        present(pickerController, animated: true, completion: nil)
    }
    
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    // MARK: - UIKeyboardWillShowNotification
    
    //When the keyboardWillShow notification is received, shift the view's frame up
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotification() {
        // Rigester to listen for a notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
}

