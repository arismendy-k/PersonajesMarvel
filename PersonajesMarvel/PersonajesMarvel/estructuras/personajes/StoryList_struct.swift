//
//  StoryList_struct.swift
//  DescargarURL
//
//  Created by Carlos Arismendy on 17/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import Foundation

struct StoryList:Codable {
    let available:Int?
    let returned:Int?
    let collectionURI:String?
    let items:[StorySummary]?
}


