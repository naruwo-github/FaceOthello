//
//  Player.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2019/11/09.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import Foundation

class FOPlayerModel {
    
    func play(board: FOBoardModel, stone: Int) -> (Int, Int) {
        return self.Random(available: board.available(stone: stone))
    }

    private func Random(available: [[Int]]) -> (Int, Int) {
        let int = Int.random(in: 0..<available.count)
        return (available[int][0], available[int][1])
    }
}
