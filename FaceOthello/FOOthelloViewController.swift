//
//  ViewController.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2019/11/09.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import UIKit

class FOOthelloViewController: UIViewController {
    
    @IBOutlet private weak var profileImageView: FOCustomUIImageView!
    @IBOutlet private weak var othelloBoardView: UIView!
    @IBOutlet private weak var myStoneCountLabel: UILabel!
    @IBOutlet private weak var cpuStoneCountLabel: UILabel!
    @IBOutlet private weak var passButton: FOCustomUIButton!
    @IBOutlet private weak var retryButton: FOCustomUIButton!
    
    private let screenSize: CGSize = UIScreen.main.bounds.size
    private let screenHeight: CGFloat = UIScreen.main.bounds.height
    private let BOARDSIZE = 8
    private let USER_COLOR = -1
    private let CPU_COLOR = 1
    
    private let board = FOBoardModel()
    private let player = FOPlayerModel()
    private let baseBoardImage = R.image.board()
    private let cpuStoneImage = R.image.white()
    
    var myStoneImage = R.image.black()
    var myStoneImageShaped = R.image.black()
    
    private var buttonArray: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.profileImageView.image = myStoneImage
        self.createUI(w: self.screenSize.width, h: self.screenSize.height)
    }
    
    private func createUI(w: CGFloat, h: CGFloat) {
        self.board.start(size: self.BOARDSIZE, isFirstStrike: true)
        let stoneSideLength = w / CGFloat(self.BOARDSIZE + 1)
        let stoneStartX = w / 2 - (stoneSideLength + 1) * 4
        let stoneStartY = h / 2 - (stoneSideLength + 1) * 4
        
        for i in 0..<self.BOARDSIZE {
            let x = stoneStartX + CGFloat(i) * (stoneSideLength + 1)
            
            for j in 0..<self.BOARDSIZE {
                let y = stoneStartY + CGFloat(j) * (stoneSideLength + 1)
                
                let button: UIButton = ButtonClass(
                    x: i,
                    y: j,
                    frame: CGRect(x: x, y: y, width: stoneSideLength, height: stoneSideLength))
                button.addTarget(self, action: #selector(FOOthelloViewController.pushed), for: .touchUpInside)
                self.view.addSubview(button)
                button.isEnabled = false
                self.buttonArray.append(button)
            }
        }
        
        self.switchButtonAppearance(button: self.passButton, isEnabled: false)
        self.switchButtonAppearance(button: self.retryButton, isEnabled: false)
        self.drawBoard()
    }

    @objc func pushed(mybtn: ButtonClass) {
        mybtn.isEnabled = false
        self.board.put(x: mybtn.x, y: mybtn.y, stone: self.USER_COLOR)
        self.drawBoard()
        if self.board.isGameOver() == true {
            self.switchButtonAppearance(button: self.retryButton, isEnabled: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.CpuTurn()
        }
    }

    private func CpuTurn() {
        if self.board.available(stone: self.CPU_COLOR).count != 0 {
            let xy = player.play(board: self.board, stone: self.CPU_COLOR)
            self.board.put(x: xy.0, y: xy.1, stone: self.CPU_COLOR)
            self.drawBoard()
            if self.board.isGameOver() == true {
                self.switchButtonAppearance(button: self.retryButton, isEnabled: true)
            }
        }
        if self.board.isGameOver() == true {
            self.switchButtonAppearance(button: self.retryButton, isEnabled: true)
            self.navigationItem.hidesBackButton = false
        }
        if self.board.available(stone: self.USER_COLOR).count == 0 {
            self.switchButtonAppearance(button: self.passButton, isEnabled: true)
        }
    }

    private func drawBoard() {
        let stonecount = self.board.returnStoneNumberOnTheBoard()
        self.myStoneCountLabel.text = "YOU: \(stonecount.0)"
        self.cpuStoneCountLabel.text = "CPU: \(stonecount.1)"
        
        var count = 0
        let _board = self.board.returnBoardState()
        for y in 0..<self.BOARDSIZE {
            for x in 0..<self.BOARDSIZE {
                if _board[y][x] == self.USER_COLOR {
                    self.buttonArray[count].setImage(self.myStoneImageShaped, for: .normal)
                } else if _board[y][x] == self.CPU_COLOR {
                    self.buttonArray[count].setImage(self.cpuStoneImage, for: .normal)
                } else {
                    self.buttonArray[count].setImage(self.baseBoardImage, for: .normal)
                }
                self.buttonArray[count].isEnabled = false
                count += 1
            }
        }
        let availableList = self.board.available(stone: self.USER_COLOR)
        for i in 0..<(availableList.count) {
            let x = availableList[i][0]
            let y = availableList[i][1]
            self.buttonArray[x * self.BOARDSIZE + y].isEnabled = true
        }
    }
    
    private func switchButtonAppearance(button: FOCustomUIButton, isEnabled: Bool) {
        let alpha: CGFloat = isEnabled ? 1.0 : 0.3
        button.alpha = alpha
        button.isEnabled = isEnabled
    }
    
    @IBAction private func passButtonTapped(_ sender: Any) {
        self.CpuTurn()
        self.switchButtonAppearance(button: self.passButton, isEnabled: false)
    }
    
    @IBAction private func retryButtonTapped(_ sender: Any) {
        self.board.reset()
        self.drawBoard()
        self.switchButtonAppearance(button: self.retryButton, isEnabled: false)
        self.switchButtonAppearance(button: self.passButton, isEnabled: false)
    }
    
}

extension FOOthelloViewController {
    class ButtonClass: UIButton {
        let x: Int
        let y: Int
        
        init(x: Int, y: Int, frame: CGRect) {
            self.x = x
            self.y = y
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("error")
        }
        
    }
}
