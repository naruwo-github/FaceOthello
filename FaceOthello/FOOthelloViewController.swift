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
    
    private var buttonArray: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.createUI(w: self.screenSize.width, h: self.screenSize.height)
    }

    private func createUI(w: CGFloat, h: CGFloat) {
        self.board.start(size: BOARDSIZE)
        var y: Int = Int(screenHeight / 4)
        let boxSize: Int = Int(self.othelloBoardView.frame.width) / (BOARDSIZE + 1)
        
        for i in 0..<BOARDSIZE {
            var x = 19
            for j in 0..<BOARDSIZE {
                let button: UIButton = ButtonClass(
                    x: i,
                    y: j,
                    frame: CGRect(x: x, y: y, width: boxSize, height: boxSize))
                button.addTarget(self, action: #selector(FOOthelloViewController.pushed), for: .touchUpInside)
                self.view.addSubview(button)
                button.isEnabled = false
                buttonArray.append(button)
                x += boxSize + 1
            }
            y += boxSize + 1
        }
        
        self.switchButtonAppearance(button: self.passButton, isEnabled: false)
        self.switchButtonAppearance(button: self.retryButton, isEnabled: false)
        drawBoard()
    }

    @objc func pushed(mybtn: ButtonClass) {
        mybtn.isEnabled = false
        board.put(x: mybtn.x, y: mybtn.y, stone: USER_COLOR)
        drawBoard()
        if board.isGameOver() == true {
            self.switchButtonAppearance(button: self.retryButton, isEnabled: true)
        }
        self.CpuTurn()
    }

    private func CpuTurn() {
        if board.available(stone: CPU_COLOR).count != 0 {
            let xy = player.play(board: board, stone: CPU_COLOR)
            board.put(x: xy.0, y: xy.1, stone: CPU_COLOR)
            drawBoard()
            if board.isGameOver() == true {
                self.switchButtonAppearance(button: self.retryButton, isEnabled: true)
            }
        }
        if board.isGameOver() == true {
            self.switchButtonAppearance(button: self.retryButton, isEnabled: true)
            self.navigationItem.hidesBackButton = false
        }
        if board.available(stone: USER_COLOR).count == 0 {
            self.switchButtonAppearance(button: self.passButton, isEnabled: true)
        }
    }

    private func drawBoard() {
        let stonecount = self.board.returnStoneNumberOnTheBoard()
        self.myStoneCountLabel.text = "YOU: \(stonecount.0)"
        self.cpuStoneCountLabel.text = "CPU: \(stonecount.1)"
        var count = 0
        let _board = board.returnBoardState()
        for y in 0..<BOARDSIZE {
            for x in 0..<BOARDSIZE {
                if _board[y][x] == USER_COLOR {
                    buttonArray[count].setImage(myStoneImage, for: .normal)
                } else if _board[y][x] == CPU_COLOR {
                    buttonArray[count].setImage(cpuStoneImage, for: .normal)
                } else {
                    buttonArray[count].setImage(baseBoardImage, for: .normal)
                }
                buttonArray[count].isEnabled = false
                count += 1
            }
        }
        let availableList = board.available(stone: USER_COLOR)
        for i in 0..<(availableList.count) {
            let x = availableList[i][0]
            let y = availableList[i][1]
            buttonArray[x*BOARDSIZE+y].isEnabled = true
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
