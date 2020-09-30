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
        // TODO: サーバー側にルームID取得をリクエスト
        // ルームIDを受け取ったらマッチング画面へ遷移する
    }
    
    @IBAction private func enterRoomButtonTapped(_ sender: Any) {
        // TODO: RoomIdが入力済みならそのIdのルームが存在するかサーバー側にリクエスト
        // 存在する場合はルームに入る＝マッチング画面へ遷移
        if let roomId = self.roomIdTextField.text, !roomId.isEmpty {
            // ルームidリクエスト処理
        }
    }
    
    @IBAction func beginEditTextfield(_ sender: Any) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.roomIdTextField.resignFirstResponder()
    }
}
