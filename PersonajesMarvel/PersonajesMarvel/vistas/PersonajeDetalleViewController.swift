//
//  PersonajeDetalleViewController.swift
//  PersonajesMarvel
//
//  Created by Carlos Arismendy on 21/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import UIKit
import CoreData

class PersonajeDetalleViewController: UIViewController {
    
    var idPersonaje:Int64?
    
    @IBOutlet weak var imagenPersonaje: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var web: UILabel!
    @IBOutlet weak var comics: UILabel!
    @IBOutlet weak var comicsWeb: UILabel!
    @IBOutlet weak var series: UILabel!
    @IBOutlet weak var seriesWeb: UILabel!
    @IBOutlet weak var historias: UILabel!
    @IBOutlet weak var historiasWeb: UILabel!
    @IBOutlet weak var eventos: UILabel!
    @IBOutlet weak var eventosWeb: UILabel!
    
    
    lazy var unPersonaje:NSFetchedResultsController<Personajes> = {
       let fetchRequest:NSFetchRequest<Personajes> = Personajes.fetchRequest()
       fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Personajes.nombre), ascending: true)]
        if let id = self.idPersonaje {
            fetchRequest.predicate = NSPredicate(format: "idm = %@", NSNumber(value: id))
        }
       let result = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
       return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buscarPersonajeApiMarvel(idPersonaje: idPersonaje ?? 0)
        self.cargarPersonajeDatos()
        print("IdPersonaje:", idPersonaje ?? 0)
    }
    
    func cargarPersonajeDatos(){
       DispatchQueue.main.async { [weak self] in
            do {
                try self?.unPersonaje.performFetch()
            } catch {
                print("Error acceso a datos personaje DB")
            }
            self?.verPersonaje()
       }
    }
    
    func verPersonaje(){
        if let datos = self.unPersonaje.fetchedObjects?.first, let img = datos.imagen {
            self.navigationItem.title = datos.nombre
            self.imagenPersonaje.image = UIImage(data: img)
            self.desc.text = datos.descripcion
            self.web.text = datos.resourceuri
            self.comics.text = "Comics \(datos.comic?.count ?? 0)"
            self.comicsWeb.text = datos.comicColeccion
            self.series.text = "Series \(datos.serie?.count ?? 0)"
            self.seriesWeb.text = datos.serieColeccion
            self.historias.text = "Historias \(datos.story?.count ?? 0)"
            self.historiasWeb.text = datos.storyColeccion
            self.eventos.text = "Eventos \(datos.event?.count ?? 0)"
            self.eventosWeb.text = datos.eventColeccion
            self.web.isUserInteractionEnabled = true
            self.comicsWeb.isUserInteractionEnabled = true
            self.seriesWeb.isUserInteractionEnabled = true
            self.historiasWeb.isUserInteractionEnabled = true
            self.eventosWeb.isUserInteractionEnabled = true
            self.web.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:))))
            self.comicsWeb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:))))
            self.seriesWeb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:))))
            self.historiasWeb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:))))
            self.eventosWeb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:))))

            if let cm:[Urls] = datos.url?.allObjects as? [Urls] {
                cm.forEach{ c in
                    switch c.uTipo {
                    case "comiclink":
                        self.web.text = c.uUrl ?? ""
                    case "detail" :
                        self.seriesWeb.text = c.uUrl ?? ""
                    case "wiki":
                        self.comicsWeb.text = c.uUrl ?? ""
                    default:
                        self.eventosWeb.text = c.uUrl ?? ""
                    }
                }
            }
            
        }
    }
    
    func buscarPersonajeApiMarvel(idPersonaje: Int64){
        buscarPersonajes(idPersonaje: "\(idPersonaje)")
    }
    
    @objc func tapLabel(tap: UITapGestureRecognizer){
        let web = tap.view as! UILabel
        if let str = web.text, let url = URL(string: str) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }

}
