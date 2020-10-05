//
//  FORoomCreateJoinViewController.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2020/09/30.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit

class FORoomCreateEnterViewController: UIViewController {
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var roomIdTextField: UITextField!
    
    private var profileImage: UIImage?
    private var roomId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setProfileImage()
        self.setupTextField()
    }

    func setup(profileImage: UIImage) {
        self.profileImage = profileImage
    }
    
    private func setProfileImage() {
        if let image = self.profileImage {
            self.profileImageView.image = image
        }
    }
    
    private func setupTextField() {
        self.roomIdTextField.attributedPlaceholder = NSAttributedString(string: "Room ID", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    }
    
    @IBAction private func createRoomButtonTapped(_ sender: Any) {
        self.getCreateRoomIdAsync()
        // サーバーからroomIdを取得する時間を確保するための遅延処理
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            guard let _roomId = self.roomId else { return }
            if let matchingVC = R.storyboard.main.foMatchingViewController() {
                matchingVC.setup(roomId: _roomId)
                self.navigationController?.pushViewController(matchingVC, animated: true)
            }
        }
    }
    
    @IBAction private func enterRoomButtonTapped(_ sender: Any) {
        if let roomId = self.roomIdTextField.text, !roomId.isEmpty {
        }
    }
    
    @IBAction func beginEditTextfield(_ sender: Any) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.roomIdTextField.resignFirstResponder()
    }
    
    private func getCreateRoomIdAsync() {
        let urlString = FOHelper.urlType.createRoom.rawValue
        guard let url = URLComponents(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url.url!) {(data, response, error) in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            guard let _data = data, let _roomId = String(data: _data, encoding: .utf8) else { return }
            self.roomId = _roomId
        }
        task.resume()
    }
    
    private func postRoomIdAsync(roomId: Int) {
        let url = URL(string: FOHelper.urlType.enterRoom.rawValue + "/\(roomId)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        let params: [String: AnyObject] = [
                    "id": roomId as AnyObject
                ]
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.sortedKeys)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let object = try JSONSerialization.jsonObject(with: data, options: [])
                print(object)
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
}
