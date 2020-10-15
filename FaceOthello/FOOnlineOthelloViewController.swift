//
//  FOOnlineOthelloViewController.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2020/10/13.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit

class FOOnlineOthelloViewController: UIViewController {

    @IBOutlet private weak var myImageView: UIImageView!
    @IBOutlet private weak var opponentImageView: UIImageView!
    
    private var myImage: UIImage?
    private var opponentImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupMyImage(myImage: UIImage) {
        self.myImage = myImage
        self.myImageView.image = self.myImage
    }
    
    func setupOpponentImage(opponentImage: UIImage) {
        self.opponentImage = opponentImage
        self.opponentImageView.image = self.opponentImage
    }

}
