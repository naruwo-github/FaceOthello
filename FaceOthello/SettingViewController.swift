//
//  SettingViewController.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2019/11/25.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var profileImageView: UIImageView!   //Profile Image
    @IBOutlet weak var selectPhotoButton: UIButton!     //Select Button
    @IBOutlet weak var browseButton: UIButton!          //Browse User to Connect
    @IBOutlet weak var cpuButton: UIButton!            //Play with CPU
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let savedImage = self.userDefaults.image(forKey: "image") {
            self.profileImageView.image = savedImage
        }
    }
    
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func browseButtonTapped(_ sender: Any) {
    }
    
    @IBAction func cpuButtonTapped(_ sender: Any) {
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.profileImageView.image = image
        userDefaults.setUIImageToData(image: image, forKey: "image")
        self.dismiss(animated: true, completion: nil)
    }
}

extension UserDefaults {
    func setUIImageToData(image: UIImage, forKey: String) {
        let nsdata = image.pngData()
        self.set(nsdata, forKey: forKey)
    }
    
    func image(forKey: String) -> UIImage? {
        if let data = self.data(forKey: forKey) {
            return UIImage(data: data)
        } else {
            return nil
        }
    }

}
