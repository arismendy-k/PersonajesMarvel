//
//  CharacterDataContainer.swift
//  DescargarURL
//
//  Created by Carlos Arismendy on 17/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import Foundation

struct CharacterDataContainer:Codable {
    let offset:Int?
    let limit:Int?
    let total:Int?
    let count:Int?
    let results:[CharacterMrv]?
}

