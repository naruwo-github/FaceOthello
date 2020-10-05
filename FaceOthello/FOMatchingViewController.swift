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
    
    private var roomId: String?
    private var socket: SocketIOClient?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSocketIO()
    }

    func setup(roomId: String) {
        self.roomId = roomId
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
}
