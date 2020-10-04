//
//  FOMatchingViewController.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2020/10/04.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit

class FOMatchingViewController: UIViewController {
    
    private var roomId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setup(roomId: Int) {
        self.roomId = roomId
    }
}
