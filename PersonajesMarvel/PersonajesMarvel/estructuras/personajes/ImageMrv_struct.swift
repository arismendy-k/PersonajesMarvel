//
//  ImageMrv_struct.swift
//  DescargarURL
//
//  Created by Carlos Arismendy on 17/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import Foundation

struct ImageMrv:Codable {
    let path:String?
    let ext:String?
    
    enum CodingKeys: String, CodingKey {
        case path = "path"
        case ext = "extension"
    }
}

