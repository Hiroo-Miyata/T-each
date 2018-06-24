//
//  CreateMessageViewController.swift
//  T-each
//
//  Created by hiro on 2018/06/24.
//  Copyright © 2018年 hiro. All rights reserved.
//

import UIKit
import Firebase
import Photos

class CreateMessageViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let imagePicker = UIImagePickerController()
    var currentQuestion: Question?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = currentQuestion?.content
        self.darkView.alpha = 0
        self.imagePicker.delegate = self
        self.contentTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMessage() {
        self.showLoading(state: true)
        let content = contentTextView.text!
        let image = messageImageView.image!
        let questionId = currentQuestion?.id
        if let id = Auth.auth().currentUser?.uid{
            Message.sendMessage(userID: id, content: content, image: image, questionID: questionId!, timestamp: Int(Date().timeIntervalSince1970)){ (result) in
                DispatchQueue.main.async {
                    self.showLoading(state: false)
                    if result == true{
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        print("送信失敗")
                    }
                }
            }
        }else{
            print("ログインしてません！！")
        }
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
            self.messageImageView.image = pickedImage
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
