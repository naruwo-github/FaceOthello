//
//  FOOnlineOthelloViewController.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2020/10/13.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit
import SocketIO

class FOOnlineOthelloViewController: UIViewController {

    @IBOutlet private weak var othelloBoardView: UIView!
    @IBOutlet private weak var myImageView: FOCustomUIImageView!
    @IBOutlet private weak var opponentImageView: FOCustomUIImageView!
    @IBOutlet private weak var myStoneCountLabel: UILabel!
    @IBOutlet private weak var opponentStoneCountLabel: UILabel!
    @IBOutlet private weak var passButton: FOCustomUIButton!
    @IBOutlet private weak var retryButton: FOCustomUIButton!
    
    private var myImage: UIImage?
    private var opponentImage: UIImage?
    // socketやmanagerはシングルトンなはずなので、画面遷移の際は渡す/渡される
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    private let BOARDSIZE = 8
    private let USER_COLOR = -1
    private let OPPONENT_COLOR = 1
    private let baseBoardImage = R.image.board()
    private let board = FOBoardModel()
    private var buttonArray: [UIButton] = []
    
    private var isFirstStrike: Bool = false
    private var isMyTurn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.createUI(w: UIScreen.main.bounds.width, h: UIScreen.main.bounds.height)
    }
    
    func setupFirstStrikeFlag() {
        self.isFirstStrike = true
        self.isMyTurn = true
    }
    
    func setupMyImage(myImage: UIImage) {
        self.myImage = myImage
    }
    
    func setupOpponentImage(opponentImage: UIImage) {
        self.opponentImage = opponentImage
    }
    
    func setupSocketIO(manager: SocketManager?, socket: SocketIOClient?) {
        self.manager = manager
        self.socket = socket
        
        self.socket!.on("put stone") { data, _ in
            if let _data = data.first as? [Int] {
                print(_data)
                let position = (_data.first!, _data.last!)
                self.opponentTurn(opponentStone: position)
                self.isMyTurn = true
            }
        }
        
    }
    
    private func setup() {
        if let myImage = self.myImage {
            self.myImageView.image = myImage
        } else {
            self.myImage = R.image.black()
        }
        
        if let opponentImage = self.opponentImage {
            self.opponentImageView.image = opponentImage
        } else {
            self.opponentImage = R.image.white()
        }
        
    }
    
    private func createUI(w: CGFloat, h: CGFloat) {
        self.board.start(size: self.BOARDSIZE, isFirstStrike: self.isFirstStrike)
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
                button.addTarget(self, action: #selector(FOOnlineOthelloViewController.pushed), for: .touchUpInside)
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
        guard self.isMyTurn else { return }
        
        mybtn.isEnabled = false
        self.board.put(x: mybtn.x, y: mybtn.y, stone: self.USER_COLOR)
        self.drawBoard()
        
        if self.board.isGameOver() == true {
            self.switchButtonAppearance(button: self.retryButton, isEnabled: true)
        }
        
        // 対戦相手に送る
        let sendData = [mybtn.x, mybtn.y]
        self.socket?.emit("put stone", sendData as SocketData)
        self.isMyTurn = false
        
    }
    
    private func drawBoard() {
        let stonecount = self.board.returnStoneNumberOnTheBoard()
        self.myStoneCountLabel.text = "YOU: \(stonecount.0)"
        self.opponentStoneCountLabel.text = "OPPONENT: \(stonecount.1)"
        
        var count = 0
        let _board = self.board.returnBoardState()
        for y in 0..<self.BOARDSIZE {
            for x in 0..<self.BOARDSIZE {
                if _board[y][x] == self.USER_COLOR {
                    self.buttonArray[count].setImage(self.myImage, for: .normal)
                } else if _board[y][x] == self.OPPONENT_COLOR {
                    self.buttonArray[count].setImage(self.opponentImage, for: .normal)
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
    
    private func opponentTurn(opponentStone: (Int, Int)) {
        if self.board.available(stone: self.OPPONENT_COLOR).count != 0 {
            self.board.put(x: opponentStone.0, y: opponentStone.1, stone: self.OPPONENT_COLOR)
            self.drawBoard()
            if self.board.isGameOver() == true {
                self.switchButtonAppearance(button: self.retryButton, isEnabled: true)
            }
        }
        
        if self.board.isGameOver() == true {
            self.switchButtonAppearance(button: self.retryButton, isEnabled: true)
            // TODO: ゲーム終了のモーダルを出したい
        }
        
        if self.board.available(stone: self.USER_COLOR).count == 0 {
            self.switchButtonAppearance(button: self.passButton, isEnabled: true)
        }
    }
    
    private func switchButtonAppearance(button: FOCustomUIButton, isEnabled: Bool) {
        let alpha: CGFloat = isEnabled ? 1.0 : 0.3
        button.alpha = alpha
        button.isEnabled = isEnabled
    }
    
    @IBAction private func passButtonTapped(_ sender: Any) {
        // TODO: passしたときの処理が未実装である
        self.switchButtonAppearance(button: self.passButton, isEnabled: false)
    }
    
    @IBAction private func retryButtonTapped(_ sender: Any) {
        self.board.reset()
        self.drawBoard()
        self.switchButtonAppearance(button: self.retryButton, isEnabled: false)
        self.switchButtonAppearance(button: self.passButton, isEnabled: false)
    }
    
}

extension FOOnlineOthelloViewController {
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
