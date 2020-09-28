//
//  Board.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2019/11/09.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import Foundation

class FOBoardModel {
    private let DIRECTION = [
        [-1, -1], [+0, -1], [+1, -1],
        [-1, +0],           [+1, +0],
        [-1, +1], [+0, +1], [+1, +1]
    ]
    private let BLACK = -1
    private let WHITE = 1
    private let BLANK = 0
    
    var Size: Int = 0
    var Square:[[Int]] = []

    //Initialization method of Othello board
    func start(size: Int){
        self.Size = size
        let center = size / 2
        
        for _ in 0..<self.Size {
            var array:[Int] = []
            for _ in 0..<self.Size {
                array += [BLANK]
            }
            Square += [array]
        }
        
        Square[center-1][center-1] = self.WHITE
        Square[center-1][center] = self.BLACK
        Square[center][center-1] = self.BLACK
        Square[center][center] = self.WHITE
    }

    func returnStoneNumberOnTheBoard() -> (Int,Int) {
        var black = 0
        var white = 0
        var blank = 0
        
        for y in 0..<Size {
            for x in 0..<Size {
                switch Square[y][x] {
                case BLACK:
                    black += 1
                case WHITE:
                    white += 1
                default:
                    blank += 1
                }
            }
        }
        
        return (black, white)
    }
    
    func reset(){
        var _square:[[Int]] = []
        let size = Size
        let center = size / 2
        
        for _ in 0..<Size{
            var array:[Int] = []
            for _ in 0..<Size{
                array += [BLANK]
            }
            _square += [array]
        }
        
        _square[center-1][center-1] = self.WHITE
        _square[center-1][center] = self.BLACK
        _square[center][center-1] = self.BLACK
        _square[center][center] = self.WHITE
        Square = _square
    }

    func returnBoardState() -> [[Int]]{
        return Square
    }

    func isGameOver() -> Bool {
        var black = 0
        var white = 0
        var blank = 0
        
        for y in 0..<Size {
            for x in 0..<Size {
                switch Square[y][x] {
                case BLACK:
                    black += 1
                case WHITE:
                    white += 1
                default:
                    blank += 1
                }
            }
        }
        
        if (blank == 0 || black == 0 || white == 0 ){
            return true
        }
        
        if (self.available(stone: BLACK).count == 0 && self.available(stone: WHITE).count == 0) {
            return true
        }
        
        return false
    }

    //return weather blank or not
    func is_available( x: Int, y:Int, stone: Int) -> Bool {
        if ( Square[x][y] != BLANK ){
            return false
        }
        
        for i in 0..<8 {
            let dx = DIRECTION[i][0]
            let dy = DIRECTION[i][1]
            if (self.count_reversible(x: x, y: y, dx: dx, dy: dy, stone: stone) > 0) {
                return true
            }
        }
        
        return false
    }

    //return available positon
    func available(stone: Int) -> [[Int]] {
        var return_array:[[Int]] = []
        
        for x in 0..<Size {
            for y in 0..<Size {
                if (self.is_available( x: x, y: y, stone: stone)) {
                    return_array += [[x,y]]
                }
            }
        }
        
        return return_array
    }

    func put(x: Int, y:Int, stone: Int) {
        Square[x][y] = stone
        
        for i in 0..<8 {
            let dx = DIRECTION[i][0]
            let dy = DIRECTION[i][1]
            let n = self.count_reversible(x: x, y: y, dx: dx, dy: dy, stone: stone)
            
            for j in 1..<(n+1) {
                Square[x + j * dx][y + j * dy] = stone
            }
        }
    }

    //return reversible stone position
    func count_reversible(x: Int, y: Int, dx: Int, dy: Int, stone: Int) -> Int {
        var _x = x
        var _y = y
        
        for i in 0..<Size {
            _x = _x + dx
            _y = _y + dy
            // 0 <= x < 4 : can't write <- Annoying!!!!
            if !(0 <= _x && _x < Size && 0 <= _y && _y < Size) {
                return 0
            }
            
            if (Square[_x][_y] == BLANK) {
                return 0
            }
            
            if (Square[_x][_y] == stone) {
                return i
            }
        }
        return 0
    }
}
