//
//  CharacterMrv_struct.swift
//  DescargarURL
//
//  Created by Carlos Arismendy on 17/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import Foundation

struct CharacterMrv:Codable {
    let id:Int?
    let name:String?
    let description:String?
    let modified:String?
    let resourceURI:String?
    let urls:[UrlMrv]?
    let thumbnail:ImageMrv?
    let comics:ComicList?
    let stories:StoryList?
    let events:EventList?
    let series:SeriesList?
}

