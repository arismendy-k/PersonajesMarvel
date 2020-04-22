//
//  Descargar.swift
//  DescargarURL
//
//  Created by Carlos Arismendy on 17/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import Foundation

//
//  Determina el ambito de la busqueda.
//  si nombrePersonaje:  Devuelve todos los personajes que comienzan con dicho nombre
//  si idPersonaje:  Devuelve solo el detalle del personaje seleccionado de la lista
//  defecto: Devuelve todos los personajes hasta un maximo de 50
func getUrl(nombrePersonaje:String = "", idPersonaje:String = "") -> URL {
    let privateKey = "1c146c1ca37cfbaa11df68c6af8e34e5215ddbe0"
    let publicKey = "4bf223675d542f57236493780a84d005"

//    let privateKey = "ae7808ded52096fa924b0201271262924ad6be7b"
//    let publicKey = "9ebe293d46dab2a006d5b13bbdc8d86f"

    let baseURL = URL(string: "https://gateway.marvel.com/v1/public")!
    let ts = "\(Date().timeIntervalSince1970)"
    let valorFirma = ts + privateKey + publicKey
    let hash = valorFirma.MD5
    var url = URLComponents()
    url.scheme = baseURL.scheme
    url.host = baseURL.host
    url.path = baseURL.path
    var offsetValor = 0
    if nombrePersonaje.isEmpty && idPersonaje.isEmpty {
        if let offsetData = ClaveSegura.cargar(key: "offset"),
            let offset = String(data: offsetData, encoding: .utf8) {
                offsetValor = Int(offset) ?? 0
        } else {
            if let valor = "0".data(using: .utf8) {
                ClaveSegura.grabar(key: "offset", data: valor)
            }
        }
    }
    let offset = "\(offsetValor)".trimmingCharacters(in: .whitespaces)
    let queryts = URLQueryItem(name: "ts", value: ts)
    let queryApiKey = URLQueryItem(name: "apikey", value: publicKey)
    let queryHash = URLQueryItem(name: "hash", value: hash)
    let queryLimit = URLQueryItem(name: "limit", value: "50")
    let queryOffSet = URLQueryItem(name: "offset", value: offset )
    let queryOrder = URLQueryItem(name: "orderBy", value: "name")
    url.queryItems = [queryts, queryApiKey, queryHash, queryLimit, queryOffSet, queryOrder]
    if !nombrePersonaje.isEmpty {
        let queryStartWith = URLQueryItem(name: "nameStartsWith", value: nombrePersonaje )
        url.queryItems?.append(queryStartWith)
    }
    let pathComponent = idPersonaje.isEmpty ? "characters" : "characters/\(idPersonaje)"
    let urlFinal = url.url!.appendingPathComponent(pathComponent)
    return urlFinal
}

class Descargar<T:Codable> {
    
    enum MetodoHTTP: String {
        case get = "GET"
    }
    
    enum Result {
        
        case data((Int, Data))
        case error((Int, Error))
        
        func respuesta() -> (Int, String) {
            switch self {
                case .data( ( let cod, let datos) ):
                    return (cod, String(decoding: datos, as: UTF8.self) )
                case .error( ( let cod, let err) ):
                    return  (cod, "{\"status\":\(cod), \"message\":\"\(err.localizedDescription)\"}")
            }
        }
        
        func entidad() -> T? {
            if let s = self.respuesta().1.data(using: .utf8) {
                return try? JSONDecoder().decode(T.self, from: s)
            }
            return nil
        }
        
        func error() -> Respuesta? {
            if let s = self.respuesta().1.data(using: .utf8) {
                return try? JSONDecoder().decode(Respuesta.self, from: s)
            }
            return nil
        }
    }

    class Peticion:NSObject {
        public let metodo: MetodoHTTP
        public let path: String
        public var queryItems: [URLQueryItem]?
        public var body: Data?

        public init(metodo: MetodoHTTP, path: String) {
            self.metodo = metodo
            self.path = path
        }
        
    }
    
    private let managerRed: ManagerRed

    init(managerRed: ManagerRed = URLSession.shared) {
        self.managerRed = managerRed
    }
    
    func de(url: URLRequest, metodo: MetodoHTTP, completionHandler: @escaping (Result) -> Void) {
            
        print("K: *: URL = ", url.url?.absoluteString ?? "")
        let request = Peticion(metodo: metodo, path: url.url!.absoluteString)
        var urlRequest = URLRequest(url: url.url!)
        urlRequest.httpMethod = request.metodo.rawValue
        urlRequest.httpBody = request.body
        urlRequest.addValue("*/*", forHTTPHeaderField: "Accept")
        
        if let etag = ClaveSegura.cargar(key: "etag"),
            let ETag = String(data: etag, encoding: .utf8) {
            urlRequest.addValue(ETag, forHTTPHeaderField: "ETag")
        }
        
        managerRed.doRequest(for: urlRequest) { (data, response, error) in
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
