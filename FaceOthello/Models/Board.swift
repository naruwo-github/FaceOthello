//
//  Board.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2019/11/09.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import Foundation

class Board {
    let Directions = [
        [-1, -1], [+0, -1], [+1, -1],
        [-1, +0],           [+1, +0],
        [-1, +1], [+0, +1], [+1, +1]
    ]
    let Black = -1
    let White = 1
    let Blank = 0
    var Size: Int = 0
    var Square:[[Int]] = []

    //Initialization method of Othello board
    func start(size: Int){
        self.Size = size
        let center = size / 2
        
        for _ in 0..<self.Size{
            var array:[Int] = []
            for _ in 0..<self.Size{
                array += [Blank]
            }
            Square += [array]
        }
        
        Square[center-1][center-1] = self.White
        Square[center-1][center] = self.Black
        Square[center][center-1] = self.Black
        Square[center][center] = self.White
    }

    //Stone number on the board
    func returnStone() -> (Int,Int) {
        var black = 0
        var white = 0
        var blank = 0
        
        for y in 0..<Size{
            for x in 0..<Size{
                switch Square[y][x]{
                case Black:
                    black += 1
                case White:
                    white += 1
                default:
                    blank += 1
                }
            }
        }
        
        return (black, white)
    }

    //restart board
    func reset(){
        var _square:[[Int]] = []
        let size = Size
        let center = size / 2
        
        for _ in 0..<Size{
            var array:[Int] = []
            for _ in 0..<Size{
                array += [Blank]
            }
            _square += [array]
        }
        
        _square[center-1][center-1] = self.White
        _square[center-1][center] = self.Black
        _square[center][center-1] = self.Black
        _square[center][center] = self.White
        Square = _square
    }

    //return board state
    func return_board() -> [[Int]]{
        return Square
    }

    //judging the state of game(when the game is over, then true)
    func gameOver() -> Bool {
        var black = 0
        var white = 0
        var blank = 0
        
        for y in 0..<Size{
            for x in 0..<Size{
                switch Square[y][x]{
                case Black:
                    black += 1
                case White:
                    white += 1
                default:
                    blank += 1
                }
            }
        }
        
        if( blank == 0 || black == 0 || white == 0 ){
            return true
        }
        
        if( self.available(stone: Black).count == 0 && self.available(stone: White).count == 0){
            return true
        }
        
        return false
    }

    func is_available( x: Int, y:Int, stone: Int) -> Bool {
        if ( Square[x][y] != Blank ){
            return false
        }
        
        for i in 0..<8 {
            let dx = Directions[i][0]
            let dy = Directions[i][1]
            if( self.count_reversible(x: x, y: y, dx: dx, dy: dy, stone: stone) > 0 ){
                return true
            }
        }
        
        return false
    }

    //return available positon
    func available(stone: Int) -> [[Int]]{
        var return_array:[[Int]] = []
        
        for x in 0..<Size{
            for y in 0..<Size{
                if( self.is_available( x: x, y: y, stone: stone) ){
                    return_array += [[x,y]]
                }
            }
        }
        
        return return_array
    }

    //put stone
    func put( x: Int, y:Int, stone: Int){
        Square[x][y] = stone
        
        for i in 0..<8 {
            let dx = Directions[i][0]
            let dy = Directions[i][1]
            let n = self.count_reversible( x: x, y: y, dx: dx, dy: dy, stone: stone)
            
            for j in 1..<(n+1){
                Square[x + j * dx][y + j * dy] = stone
            }
        }
    }

    func count_reversible( x: Int, y: Int, dx: Int, dy: Int, stone: Int) -> Int {
        var _x = x
        var _y = y
        
        for i in 0..<Size{
            _x = _x + dx
            _y = _y + dy
            // 0 <= x < 4 : can't write <- Annoying!!!!
            if !( 0 <= _x && _x < Size && 0 <= _y && _y < Size ){
                return 0
            }
            
            if (Square[_x][_y] == Blank){
                return 0
            }
            
            if (Square[_x][_y] == stone){
                return i
            }
        }
        
        return 0
    }
}
