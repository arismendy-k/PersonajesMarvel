//
//  BDD.swift
//  PersonajesMarvel
//
//  Created by Carlos Arismendy on 19/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import Foundation
import CoreData
    
var contenedorPersistencia: NSPersistentContainer = {
   let contenedor = NSPersistentContainer(name: "MarvelDB")
   contenedor.loadPersistentStores { storeDescription, error in
      if let error = error as NSError? {
         fatalError("No se puede abrir la base de Datos")
      }
   }
   return contenedor
}()

var contexto:NSManagedObjectContext {
   contenedorPersistencia.viewContext.automaticallyMergesChangesFromParent = true
   return contenedorPersistencia.viewContext
}

func guardarContexto(){
   DispatchQueue.main.async {
      if contexto.hasChanges {
         do {
            try contexto.save()
         } catch {
            print("Error actualizando Base de Datos")
         }
      }
   }
}

func personajeExiste(id:Int) -> Bool {
   let consulta:NSFetchRequest<Personajes> = Personajes.fetchRequest()
   consulta.predicate = NSPredicate(format: "idm = %@", NSNumber(value: id))
   return ((try? contexto.count(for: consulta)) ?? 0 ) > 0 ? true : false
}

func guardarPersonaje(id: Int, personaje: CharacterMrv, imagenData:Data, imagenUrl:String) {
    print("Guardar Id:", personaje.id ?? "", personaje.name ?? "")
    let nuevo = Personajes(context: contexto)
    nuevo.idm = Int64( id)
    nuevo.nombre = personaje.name
    nuevo.descripcion = personaje.description
    nuevo.modificado = personaje.modified
    nuevo.resourceuri =  personaje.resourceURI
    nuevo.imagen =  imagenData
    nuevo.imagenUrl = imagenUrl
    nuevo.comicColeccion = personaje.comics?.collectionURI
    nuevo.eventColeccion = personaje.events?.collectionURI
    nuevo.serieColeccion = personaje.series?.collectionURI
    nuevo.storyColeccion = personaje.stories?.collectionURI
    guardarContexto()
    
    if let mUrls = personaje.urls {
        mUrls.forEach{ u in
            let item = Urls(context: contexto)
            item.uTipo = u.type
            item.uUrl = u.url
            item.personaje = nuevo
            nuevo.addToUrl(item)
            guardarContexto()
        }
    }
    
    if let mComics = personaje.comics?.items {
        mComics.forEach{ c in
            let item = Comics(context: contexto)
            item.cNombre = c.name
            item.cUrl = c.resourceURI
            item.personaje = nuevo
            nuevo.addToComic( item)
            guardarContexto()
        }
    }
    
    if let mEvents = personaje.events?.items {
        mEvents.forEach{ e in
            let item = Events(context: contexto)
            item.eNombre = e.name
            item.eUrl = e.resourceURI
            item.personaje = nuevo
            nuevo.addToEvent( item)
            guardarContexto()
        }
    }
    
    if let mStories = personaje.stories?.items {
        mStories.forEach { s in
            let item = Stories(context: contexto)
            item.sNombre = s.name
            item.sTipo = s.type
            item.sUrl = s.resourceURI
            item.personaje = nuevo
            nuevo.addToStory( item)
            guardarContexto()
        }
    }
    
    if let mSeries = personaje.series?.items {
        mSeries.forEach { s in
            let item = Series(context: contexto)
            item.rNombre = s.name
            item.rUrl = s.resourceURI
            item.personaje = nuevo
            nuevo.addToSerie( item)
            guardarContexto()
        }
    }
    
}



