//
//  FOMatchingViewController.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2020/10/04.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit
import SocketIO
import HNToaster

class FOMatchingViewController: UIViewController {
    
    @IBOutlet private weak var myProfileImageView: FOCustomUIImageView!
    @IBOutlet private weak var opponentProfileImageView: FOCustomUIImageView!
    @IBOutlet private weak var roomIdLabel: UILabel!
    @IBOutlet weak var playButton: FOCustomUIButton!
    
    private var roomId: String?
    private var profileImage: UIImage?
    private var sendImageFlag: Bool = false
    
    // socketやmanagerはシングルトンなはずなので、画面遷移の際は渡す/渡される
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    // 自分が先攻かどうかのフラグ
    private var isFirstStrike: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setupSocketIO()
    }
    
    func setup(roomId: String, profileImage: UIImage?, isFirstStrike: Bool) {
        self.roomId = roomId
        if let image = profileImage {
            self.profileImage = image
        }
        self.isFirstStrike = isFirstStrike
    }
    
    @IBAction private func playButtonTapped(_ sender: Any) {
        if let onlineOthelloVC = R.storyboard.online.foOnlineOthelloViewController() {
            if let myImage = self.myProfileImageView.image {
                onlineOthelloVC.setupMyImage(myImage: myImage)
            }
            if let opponentImage = self.opponentProfileImageView.image {
                onlineOthelloVC.setupOpponentImage(opponentImage: opponentImage)
            }
            if self.isFirstStrike {
                onlineOthelloVC.setupFirstStrikeFlag()
            }
            onlineOthelloVC.setupSocketIO(manager: self.manager, socket: self.socket)
            self.navigationController?.pushViewController(onlineOthelloVC, animated: true)
        }
    }
    
    private func setupSocketIO() {
        manager = SocketManager(socketURL: URL(string: FOHelper.UrlType.initialUrl.rawValue)!,
                                config: [.log(true), .forceWebsockets(true), .forcePolling(true)])
        socket = manager?.defaultSocket
        socket!.on(clientEvent: .connect) {_, _ in
            print("socket connected")
        }
        socket!.on(clientEvent: .disconnect) { _, _ in
            print("socket disconnected!!")
        }
        socket!.on("enter") { data, _ in
            if let _data = data.first as? Int {
                if _data == 2 {
                    self.setupPlayButton(enabled: true)
                    Toaster.toast(onView: self.view, message: "Other player is online!")
                    !self.sendImageFlag ? self.sendProfileImageOnce() : ()
                }
            }
        }
        socket!.on("exit") { data, _ in
            if let _data = data.first as? String {
                print("exit: " + _data)
            }
        }
        socket!.on("send image") { data, _ in
            if let imageDataBase64 = data.first as? String {
                let imageData = NSData(base64Encoded: imageDataBase64, options: .ignoreUnknownCharacters)
                self.opponentProfileImageView.image = UIImage(data: imageData! as Data)
                print("profile image received!")
            }
        }
        socket!.connect()
    }
    
    private func setupView() {
        self.myProfileImageView.image = self.profileImage
        self.roomIdLabel.text = self.roomId
        self.setupPlayButton(enabled: false)
    }
    
    private func setupPlayButton(enabled: Bool) {
        self.playButton.isEnabled = enabled
        if enabled {
            self.playButton.layer.opacity = 1.0
        } else {
            self.playButton.layer.opacity = 0.2
        }
    }
    
    private func sendProfileImageOnce() {
        guard let _image = self.profileImage else { return }
        guard let _sendImage = _image.resized(withPercentage: 0.1) else { return }
        
        let imageData = _sendImage.pngData()! as NSData
        let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
        socket!.emit("send image", base64String)
        self.sendImageFlag = true
    }
}
