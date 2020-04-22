//
//  Respuesta.swift
//  DescargarURL
//
//  Created by Carlos Arismendy on 17/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import Foundation

struct Respuesta:Codable {
    public let timestamp: Int?
    public let status: Int?
    public let error: String?
    public let message: String?
    public let path: String?
    public let code:Int?
}
