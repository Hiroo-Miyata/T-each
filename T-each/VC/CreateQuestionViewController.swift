//
//  CreateQuestionViewController.swift
//  T-each
//
//  Created by hiro on 2018/06/21.
//  Copyright © 2018年 hiro. All rights reserved.
//

import UIKit
import Firebase
import Photos

class CreateQuestionViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var subjectButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.darkView.alpha = 0
        self.imagePicker.delegate = self
        self.contentTextView.delegate = self
        fetchUserData()
        customizeView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUserData() {
        if let id = Auth.auth().currentUser?.uid {
            User.info(forUserID: id, completion: {(user) in
                self.currentUser = user
            })
        }
    }
    
    @IBAction func sendRegistration() {
        self.showLoading(state: true)
        let content = contentTextView.text!
        let image = questionImageView.image!
        let subject = ""
        if let id = Auth.auth().currentUser?.uid {
            Question.registerQuestion(userID: id, content: content, subject: subject, image: image, timestamp: Int(Date().timeIntervalSince1970)){ (result) in
                DispatchQueue.main.async {
                    self.showLoading(state: false)
                    if result == true{
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        
                    }
                }
            }
            
        }
    }
    
    func customizeView(){
        imageView.layer.cornerRadius = 10
        questionImageView.layer.cornerRadius = 10
        contentTextView.layer.cornerRadius = 10
        subjectButton.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10
    }
    
    func showLoading(state: Bool)  {
        if state {
            self.darkView.isHidden = false
            self.spinner.startAnimating()
            UIView.animate(withDuration: 0.3, animations: {
                self.darkView.alpha = 0.5
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.darkView.alpha = 0
            }, completion: { _ in
                self.spinner.stopAnimating()
                self.darkView.isHidden = true
            })
        }
    }
    
    @IBAction func selectPic(_ sender: Any) {
        let sheet = UIAlertController(title: nil, message: "Select the source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWith(source: .camera)
        })
        let photoAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWith(source: .library)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cameraAction)
        sheet.addAction(photoAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
    func openPhotoPickerWith(source: PhotoSource) {
        switch source {
        case .camera:
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if (status == .authorized || status == .notDetermined) {
                
                DispatchQueue.main.async {
                    self.imagePicker.sourceType = .camera
                    self.imagePicker.allowsEditing = true
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
        case .library:
            let status = PHPhotoLibrary.authorizationStatus()
            if (status == .authorized || status == .notDetermined) {
                
                DispatchQueue.main.async {
                    self.imagePicker.sourceType = .savedPhotosAlbum
                    self.imagePicker.allowsEditing = true
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.questionImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            //あなたのテキストフィールド
            contentTextView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
