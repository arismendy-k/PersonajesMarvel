//
//  Buscar.swift
//  PersonajesMarvel
//
//  Created by Carlos Arismendy on 20/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import Foundation

func buscarPersonajes(nombrePersonaje:String = "", idPersonaje:String = "") {
    let urlMarvel = URLRequest(url: getUrl(nombrePersonaje: nombrePersonaje, idPersonaje: idPersonaje))
    let descargarPersonajes = Descargar<PersonajesMarvel>()
    descargarPersonajes.de(url: urlMarvel, metodo: .get) { res in
        
        if res.respuesta().0 == 200 {
            //Actualizar Base de Datos
            print("\nAPI Marvel:", res.entidad()?.data?.count ?? "" )
            if let personajesJSoN = res.entidad()?.data?.results {
                actualizarBDD(personajes: personajesJSoN)
                if nombrePersonaje.isEmpty && idPersonaje.isEmpty {
                    if let etagData = res.entidad()?.etag?.data(using: .utf8) {
                        ClaveSegura.grabar(key: "etag", data: etagData)
                    }
                }
                if nombrePersonaje.isEmpty {
                    if let offsetData = ClaveSegura.cargar(key: "offset"),
                        let offset = String(data: offsetData, encoding: .utf8),
                        var offsetValor = Int(offset) {
                        offsetValor += 50
                        if let valor = "\(offsetValor)".data(using: .utf8) {
                            ClaveSegura.grabar(key: "offset", data: valor)
                        }
                    }
                }
                if personajesJSoN.isEmpty {
                    NotificationCenter.default.post(name: NSNotification.Name("OKCARGA"), object: nil)
                }
            }
        } else {
            print(res.error() ?? "", res.respuesta().1)
            NotificationCenter.default.post(name: NSNotification.Name("OKCARGA"), object: nil)
        }

    }
}

func actualizarBDD(personajes: [CharacterMrv]){
//    let rutaCarpetaUsuario = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//    print(rutaCarpetaUsuario ?? "")
    
    var nroPersonajes = 0
    let totalEncontrados = personajes.count
    personajes.forEach{ p in
        if let path = p.thumbnail?.path, let ext = p.thumbnail?.ext, let personajeId = p.id {
            let strImagen = "\(path).\(ext)"
            let urlImagen =  URLRequest(url: URL(string: strImagen)!)
            let descargarImagen = DescargarImagen()
            
            descargarImagen.de(url: urlImagen) { res in
                
                if res.respuesta().0 == 200 {
                   // Imagen Descargada
                    if let imagenData = res.respuesta().2 {
                        if !personajeExiste(id: personajeId) {
                            guardarPersonaje(id: personajeId, personaje: p, imagenData: imagenData, imagenUrl: strImagen)
                        }
                    }
                } else {
                   print(res.error() ?? "", res.respuesta().1)
                }
                nroPersonajes += 1
                if nroPersonajes == totalEncontrados {
                    NotificationCenter.default.post(name: NSNotification.Name("OKCARGA"), object: nil)
                }
            }
        }
    }
    
}
