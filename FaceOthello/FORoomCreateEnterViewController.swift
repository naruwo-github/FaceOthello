//
//  FORoomCreateJoinViewController.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2020/09/30.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit
import SocketIO

class FORoomCreateEnterViewController: UIViewController {
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var roomIdTextField: UITextField!
    
    private var profileImage: UIImage?
    private var socket: SocketIOClient!
    private var roomId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setProfileImage()
        self.setupTextField()
        self.setupSocketIO()
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
        // キーボードは数字のみのものを扱う
        self.roomIdTextField.keyboardType = UIKeyboardType.numberPad
        self.roomIdTextField.attributedPlaceholder = NSAttributedString(string: "Room ID", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    }
    
    private func setupSocketIO() {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        socket = appDelegate.socket
//        socket.on("") { (data, emitter) in
//            if let message = data as? [String] {
//            }
//        }
    }
    
    @IBAction private func createRoomButtonTapped(_ sender: Any) {
        self.getCreateRoomIdAsync()
        guard let _roomId = self.roomId else { return }
        if let matchingVC = R.storyboard.main.foMatchingViewController() {
            matchingVC.setup(roomId: _roomId)
            self.navigationController?.pushViewController(matchingVC, animated: true)
        }
    }
    
    @IBAction private func enterRoomButtonTapped(_ sender: Any) {
        // TODO: RoomIdが入力済みならそのIdのルームが存在するかサーバー側にリクエスト
        // 存在する場合はルームに入る＝マッチング画面へ遷移
        if let roomId = self.roomIdTextField.text, !roomId.isEmpty {
        }
    }
    
    @IBAction func beginEditTextfield(_ sender: Any) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.roomIdTextField.resignFirstResponder()
    }
    
    private func getCreateRoomIdAsync() {
        let url = URL(string: FOHelper.urlType.createRoom.rawValue)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let _data = data else { return }
            do {
                let object = try JSONSerialization.jsonObject(with: _data, options: [])
                print(object)
            } catch let error {
                print(error)
            }
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
