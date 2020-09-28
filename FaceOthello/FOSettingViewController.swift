//
//  SettingViewController.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2019/11/25.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import Foundation
import UIKit
import CropViewController

class FOSettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet fileprivate weak var profileImageView: UIImageView!
    @IBOutlet private weak var selectPhotoButton: FOCustomUIButton!
    @IBOutlet private weak var playWithCpuButton: FOCustomUIButton!
    @IBOutlet private weak var bluetoothButton: FOCustomUIButton!
    @IBOutlet weak var playOnlineButton: FOCustomUIButton!
    
    fileprivate let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedImage = self.userDefaults.image(forKey: "image") {
            self.profileImageView.image = savedImage
        }
    }
    
    @IBAction private func imageViewTapped(_ sender: Any) {
        if let image = self.profileImageView.image {
            let cropViewController = CropViewController(image: image)
            cropViewController.delegate = self
            present(cropViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction private func selectPhotoButtonTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    @IBAction private func playWithCpuButtonTapped(_ sender: Any) {
    }
    
    @IBAction private func bluetoothButtonTapped(_ sender: Any) {
    }
    
    @IBAction func playOnlineButtonTapped(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OthelloViewSegue" {
            let othelloViewController: FOOthelloViewController = segue.destination as! FOOthelloViewController
            if let image = self.profileImageView.image {
                othelloViewController.black = image
            }
        }
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.profileImageView.image = image
        self.userDefaults.setUIImageToData(image: image, forKey: "image")
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

extension FOSettingViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 加工した画像の取得
        self.profileImageView.image = image
        self.userDefaults.setUIImageToData(image: image, forKey: "image")
        cropViewController.dismiss(animated: true, completion: nil)
    }

    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
}