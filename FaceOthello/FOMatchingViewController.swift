//
//  FOMatchingViewController.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2020/10/04.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit
import SocketIO

class FOMatchingViewController: UIViewController {
    
    @IBOutlet private weak var myProfileImageView: UIImageView!
    @IBOutlet private weak var opponentProfileImageView: UIImageView!
    @IBOutlet private weak var roomIdLabel: UILabel!
    
    private var roomId: String?
    private var profileImage: UIImage?
    
    // socketやmanagerはシングルトンなはずなので、画面遷移の際は渡す
    private var manager: SocketManager?
    private var socket: SocketIOClient?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setupSocketIO()
    }
    
    func setup(roomId: String, profileImage: UIImage?) {
        self.roomId = roomId
        if let image = profileImage {
            self.profileImage = image
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
                    self.sendProfileImageOnce()
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
    }
    
    private func sendProfileImageOnce() {
        if let image = self.profileImage {
            let imageData = image.pngData()! as NSData
            let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
            socket!.emit("send image", base64String)
        }
    }
}
