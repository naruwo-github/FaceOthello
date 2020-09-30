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
        // TODO: サーバー側にルームID取得をリクエスト
        // ルームIDを受け取ったらマッチング画面へ遷移する
    }
    
    @IBAction private func enterRoomButtonTapped(_ sender: Any) {
        // TODO: RoomIdが入力済みならそのIdのルームが存在するかサーバー側にリクエスト
        // 存在する場合はルームに入る＝マッチング画面へ遷移
    }
}
