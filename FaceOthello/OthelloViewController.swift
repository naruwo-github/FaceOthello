//
//  ViewController.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2019/11/09.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import UIKit

class OthelloViewController: UIViewController {
    
    private let screenSize: CGSize = UIScreen.main.bounds.size
    private let BOARDSIZE = 8
    private let USER_COLOR = -1
    private let CPU_COLOR = 1
    
    private let board = Board()
    private let player = Player()

    private let resetButton = UIButton()
    private let passButton = UIButton()
    private let viewStoneCount = UILabel()
    
    private let baseBoard = R.image.board()
    private let white = R.image.white()
    var black = R.image.black()
    
    private var buttonArray: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.createUI(w: self.screenSize.width, h: self.screenSize.height)
    }

    func createUI(w: CGFloat, h: CGFloat){
        board.start(size: BOARDSIZE)
        var y = 183
        let boxSize = 84 / (BOARDSIZE/4)
        
        viewStoneCount.frame = CGRect(x: 0, y: 0, width: w, height: 100)
        viewStoneCount.textAlignment = NSTextAlignment.center
        viewStoneCount.font = UIFont.systemFont(ofSize: 25)
        viewStoneCount.center = CGPoint(x: w/2, y: h-100)
        self.view.addSubview(viewStoneCount)
        
        for i in 0..<BOARDSIZE{
            var x = 19
            for j in 0..<BOARDSIZE{
                let button: UIButton = buttonClass(
                    x: i,
                    y: j,
                    frame:CGRect(x: x,y: y, width: boxSize,height: boxSize))
                button.addTarget(self, action: #selector(OthelloViewController.pushed), for: .touchUpInside)
                self.view.addSubview(button)
                button.isEnabled = false
                buttonArray.append(button)
                x = x + boxSize + 1
            }
            y = y + boxSize + 1
        }
        
        resetButton.frame = CGRect(x: 125, y: 575, width: 125, height: 45)
        resetButton.addTarget(self, action: #selector(OthelloViewController.pushResetButton), for: .touchUpInside)
        resetButton.isEnabled = false
        resetButton.isHidden = true
        resetButton.setTitle("RESET", for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.6, alpha: 1)
        resetButton.layer.cornerRadius = 20
        resetButton.layer.shadowOpacity = 0.5
        resetButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.view.addSubview(resetButton)

        passButton.frame = CGRect(x: 150, y: 500, width: 80, height: 30)
        passButton.addTarget(self, action: #selector(OthelloViewController.pushPassButton), for: .touchUpInside)
        passButton.isEnabled = false
        passButton.isHidden = true
        passButton.setTitle("PASS", for: .normal)
        passButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        passButton.setTitleColor(.white, for: .normal)
        passButton.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.6, alpha: 1)
        passButton.layer.cornerRadius = 20
        passButton.layer.shadowOpacity = 0.5
        passButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.view.addSubview(passButton)
        
        drawBoard()
    }

    @objc func pushPassButton() {
        CpuTurn()
        passButton.isEnabled = false
        passButton.isHidden = true
    }

    @objc func pushResetButton() {
        board.reset()
        drawBoard()
        resetButton.isEnabled = false
        resetButton.isHidden = true
        passButton.isEnabled = false
        passButton.isHidden = true
    }

    @objc func pushed(mybtn: buttonClass){
        mybtn.isEnabled = false
        board.put(x: mybtn.x, y: mybtn.y, stone: USER_COLOR)
        drawBoard()
        if( board.gameOver() == true ){
            resetButton.isEnabled = true
            resetButton.isHidden = false
        }
        self.CpuTurn()
    }

    func CpuTurn() {
        if( board.available(stone: CPU_COLOR).count != 0 ){
            let xy = player.play(board: board, stone: CPU_COLOR)
            board.put(x: xy.0, y: xy.1, stone: CPU_COLOR)
            drawBoard()
            if( board.gameOver() == true ){
                resetButton.isHidden = false
                resetButton.isEnabled = true
            }
        }
        if( board.gameOver() == true ){
            resetButton.isHidden = false
            resetButton.isEnabled = true
            self.navigationItem.hidesBackButton = false
        }
        if( board.available(stone: USER_COLOR).count == 0){
            passButton.isHidden = false
            passButton.isEnabled = true
        }
    }

    func drawBoard(){
        let stonecount = board.returnStone()
        viewStoneCount.text = "● Uer: " + String(stonecount.0) + "     ○ CPU: " + String(stonecount.1)
        var count = 0
        let _board = board.return_board()
        for y in 0..<BOARDSIZE{
            for x in 0..<BOARDSIZE{
                if( _board[y][x] == USER_COLOR ){
                    buttonArray[count].setImage(black, for: .normal)
                } else if( _board[y][x] == CPU_COLOR ){
                    buttonArray[count].setImage(white, for: .normal)
                } else {
                    buttonArray[count].setImage(baseBoard, for: .normal)
                }
                buttonArray[count].isEnabled = false
                count += 1
            }
        }
        let availableList = board.available(stone: USER_COLOR)
        for i in 0..<(availableList.count){
            let x = availableList[i][0]
            let y = availableList[i][1]
            buttonArray[x*BOARDSIZE+y].isEnabled = true
        }
    }
}

extension OthelloViewController {
    class buttonClass: UIButton {
        let x: Int
        let y: Int
        init( x:Int, y:Int, frame: CGRect ) {
            self.x = x
            self.y = y
            super.init(frame:frame)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("error")
        }
    }
}
