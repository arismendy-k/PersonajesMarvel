//
//  DescargarEnEntidad.swift
//  DescargarURL
//
//  Created by Carlos Arismendy on 17/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import Foundation

class DescargarImagen {
    
    enum Result {

        case data((Int, Data))
        case error((Int, Error))
        
        func respuesta() -> (Int, String, Data?) {
            switch self {
                case .data( ( let cod, let datos) ):
                    return (cod, "Imagen OK", datos)
                case .error( ( let cod, let err) ):
                    return  (cod, err.localizedDescription, "".data(using: .utf8))
            }
        }
        
        func error() -> Respuesta? {
            if let s = self.respuesta().1.data(using: .utf8) {
                return try? JSONDecoder().decode(Respuesta.self, from: s)
            }
            return nil
        }
        
    }

    private let managerRed: ManagerRed

    init(managerRed: ManagerRed = URLSession.shared) {
        self.managerRed = managerRed
    }

    func de(url: URLRequest, completionHandler: @escaping (Result) -> Void) {
        managerRed.doRequest(for: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    return completionHandler(.error((error._code, error)))
                }
                let cod = (response as? HTTPURLResponse)?.statusCode
                completionHandler(.data((cod ?? 200, data ?? Data())))
            }
        }
    }
}


