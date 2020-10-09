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
    private var canEnterFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setProfileImage()
    }

    func setup(profileImage: UIImage) {
        self.profileImage = profileImage
    }
    
    private func setProfileImage() {
        if let image = self.profileImage {
            self.profileImageView.image = image
        }
    }
    
    @IBAction private func createRoomButtonTapped(_ sender: Any) {
        self.getRoomIdAsync()
        // サーバーからroomIdを取得する時間を確保するための遅延処理
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            guard let _roomId = self.roomId else { return }
            self.postRoomIdAsync(roomId: _roomId)
            // サーバーへroomIdを使ってルームに入る時間を確保するための遅延処理
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if self.canEnterFlag,
                   let matchingVC = R.storyboard.online.foMatchingViewController() {
                    matchingVC.setup(roomId: _roomId)
                    self.navigationController?.pushViewController(matchingVC, animated: true)
                }
            }
        }
    }
    
    @IBAction private func enterRoomButtonTapped(_ sender: Any) {
        if let _roomId = self.roomIdTextField.text, !_roomId.isEmpty {
            self.postRoomIdAsync(roomId: _roomId)
            // サーバーへroomIdを使ってルームに入る時間を確保するための遅延処理
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if self.canEnterFlag,
                   let matchingVC = R.storyboard.online.foMatchingViewController() {
                    matchingVC.setup(roomId: _roomId)
                    self.navigationController?.pushViewController(matchingVC, animated: true)
                }
            }
        }
    }
    
    private func getRoomIdAsync() {
        let urlString = FOHelper.urlType.createRoom.rawValue
        guard let url = URLComponents(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url.url!) {(data, response, error) in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            guard let _data = data, let _roomId = String(data: _data, encoding: .utf8) else { return }
            self.roomId = _roomId
            print("roomId = " + _roomId)
        }
        task.resume()
    }
    
    private func postRoomIdAsync(roomId: String) {
        let urlString = FOHelper.urlType.enterRoom.rawValue + "/\(roomId)"
        guard let url = URLComponents(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url.url!) {(data, response, error) in
            if (error != nil) {
                print(error!.localizedDescription)
                self.canEnterFlag = false
            }
            guard let _data = data, let paramsId = String(data: _data, encoding: .utf8) else { return }
            self.canEnterFlag = true
            print("response data(params.id) = " + paramsId)
        }
        task.resume()
    }
    
    // キーボード外を押した時にキーボードを非表示にする処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.roomIdTextField.resignFirstResponder()
    }
    
}
