//
//  FOHelper.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2020/10/04.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import Foundation

class FOHelper {
    enum UrlType: String {
        case initialUrl = "http://localhost:3000"
        case createRoom = "http://localhost:3000/room/create"
        case enterRoom = "http://localhost:3000/room/enter"
    }
}
