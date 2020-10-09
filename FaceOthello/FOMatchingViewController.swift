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
    private var socket: SocketIOClient?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSocketIO()
        self.setupView()
    }

    func setup(roomId: String, profileImage: UIImage?) {
        self.roomId = roomId
        if let image = profileImage {
            self.profileImage = image
        }
    }
    
    private func setupSocketIO() {
        let manager = SocketManager(socketURL: URL(string: FOHelper.urlType.initialUrl.rawValue + "/socket")!, config: [.log(true), .compress])
        socket = manager.defaultSocket
        socket!.on("connect") { data, ack  in
            print("socket connected!!")
        }
        socket!.on("disconnect") { data, ack in
            print("socket disconnected!!")
        }
        socket!.connect()
    }
    
    private func setupView() {
        self.myProfileImageView.image = self.profileImage
        self.roomIdLabel.text = self.roomId
    }
}
