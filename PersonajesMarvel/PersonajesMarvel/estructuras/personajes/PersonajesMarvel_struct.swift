//
//  PersonajesMarvel.swift
//  DescargarURL
//
//  Created by Carlos Arismendy on 17/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import Foundation

struct PersonajesMarvel:Codable {
    let code:Int?
    let status:String?
    let copyright:String?
    let attributionText:String?
    let attributionHTML:String?
    let data:CharacterDataContainer?
    let etag:String?
}
