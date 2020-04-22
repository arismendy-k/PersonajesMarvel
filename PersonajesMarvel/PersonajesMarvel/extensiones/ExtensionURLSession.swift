//
//  ExtensionURLSession.swift
//  DescargarURL
//
//  Created by Carlos Arismendy on 17/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import Foundation

extension URLSession: ManagerRed {
    typealias Handler = ManagerRed.callBack

    func doRequest(for url: URLRequest, completionHandler: @escaping Handler) {
        let task = dataTask(with: url, completionHandler: completionHandler)
        task.resume()
    }
}
