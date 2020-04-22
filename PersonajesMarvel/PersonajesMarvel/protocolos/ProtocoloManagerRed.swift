//
//  ProtocoloManagerRed.swift
//  DescargarURL
//
//  Created by Carlos Arismendy on 17/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import Foundation

protocol ManagerRed {
    
    typealias callBack = (Data?, URLResponse?, Error?) -> Void

    func doRequest(for url: URLRequest, completionHandler: @escaping callBack)
}
