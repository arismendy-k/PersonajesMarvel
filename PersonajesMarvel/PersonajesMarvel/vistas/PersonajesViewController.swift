//
//  ViewController.swift
//  PersonajesMarvel
//
//  Created by Carlos Arismendy on 17/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import UIKit
import CoreData

class PersonajesViewController: UIViewController {

    @IBOutlet weak var barraBuscar: UISearchBar!
    @IBOutlet weak var tablaPersonajes: UITableView!
    @IBOutlet weak var masPersonajes: UIBarButtonItem!
    @IBOutlet weak var botonBuscarPersonaje: UIBarButtonItem!
    
    struct Fila {
        let idm:Int64
        let nombre:String
        let descripcion:String
        let imagen:UIImage
    }
    
    lazy var allPersonajes:NSFetchedResultsController<Personajes> = {
       let fetchRequest:NSFetchRequest<Personajes> = Personajes.fetchRequest()
       fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Personajes.nombre), ascending: true)]
       let result = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
       return result
    }()

    var listaPersonajes = [Fila]()
    var listaPersonajesBusqueda = [Fila]()
    
    func recargar(){
       DispatchQueue.main.async { [weak self] in
            do {
                try self?.allPersonajes.performFetch()
            } catch {
                print("Error acceso a personajes DB")
            }
            self?.cargarPersonajes()
       }
    }
    
    var refresco = false
    
    lazy var refresh:UIRefreshControl = {
       let refresh = UIRefreshControl()
       refresh.addTarget(self, action: #selector(refrescoTotal), for: .valueChanged)
       return refresh
    }()
    
    @objc func refrescoTotal(){
      refresco = true
      buscarPersonajes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tablaPersonajes.delegate = self
        self.tablaPersonajes.dataSource = self
        self.barraBuscar.delegate = self
        self.masPersonajes.target = self
        self.masPersonajes.action = #selector(self.lanzarBusqueda)
        self.botonBuscarPersonaje.target = self
        self.botonBuscarPersonaje.action = #selector(self.mostrarBusquedaNombrePersonaje)
        self.realizarBusquedaPersonajes()
    }
    
    @objc func lanzarBusqueda(){
        let alertController = UIAlertController(title: "Buscar en el Servicio API Marvel", message: "50 personajes", preferredStyle: .alert)
        
               let okAccion = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
                    self.realizarBusquedaPersonajes()
               })

               let cancelarAccion = UIAlertAction(title: "Cancelar", style: .default, handler: {
                   (action : UIAlertAction!) -> Void in })

               alertController.addAction(cancelarAccion)
               alertController.addAction(okAccion)
               alertController.preferredAction = okAccion
               self.present(alertController, animated: true, completion: nil)
    }
   
    @objc func mostrarBusquedaNombrePersonaje(){
        let alertController = UIAlertController(title: "Buscar en el Servicio API Marvel", message: "Nombre personaje", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Nombre"
        }

        let okAccion = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
            if let textField = alertController.textFields?[0] {
                if let texto = textField.text, texto.count > 0 {
                    self.realizarBusquedaPersonajes(nombrePersonaje: texto)
                } else {
                    "Sin personaje a buscar".alerta(controlador: self)
                }
            }
        })

        let cancelarAccion = UIAlertAction(title: "Cancelar", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })

        alertController.addAction(cancelarAccion)
        alertController.addAction(okAccion)
        alertController.preferredAction = okAccion
        self.present(alertController, animated: true, completion: nil)
    }
    
    func realizarBusquedaPersonajes(nombrePersonaje:String = ""){
        buscarPersonajes(nombrePersonaje: nombrePersonaje)
        
        let blurEffect =  UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = navigationController?.view.frame ?? CGRect.zero
        blurredEffectView.tag = 200
        self.view.addSubview(blurredEffectView)
        
        let activity = UIActivityIndicatorView(style: .whiteLarge)
        activity.frame = navigationController?.view.frame ?? CGRect.zero
        activity.tag = 201
        activity.startAnimating()
        self.view.addSubview(activity)
        
        NotificationCenter.default.addObserver(
         forName: NSNotification.Name("OKCARGA"), object: nil, queue: .main ) { [weak self] _ in
            self?.recargar()

            if let ref = self?.refresco, ref {
              self?.refresco = false
              self?.refresh.endRefreshing()
            }

            guard let blur = self?.view.viewWithTag(200) as? UIVisualEffectView,
              let activity = self?.view.viewWithTag(201) as? UIActivityIndicatorView else {
              return
            }
            blur.removeFromSuperview()
            activity.stopAnimating()
            activity.removeFromSuperview()
         }
    }
    
    func cargarPersonajes(){
        self.listaPersonajes = [Fila]()
        self.listaPersonajesBusqueda = [Fila]()
        if let p:[Personajes] = self.allPersonajes.fetchedObjects {
            p.forEach{ m in
                if let nom = m.nombre, let des = m.descripcion, let img = m.imagen, let imgn = UIImage(data: img)?.redimensionarImagen(ancho: 40, alto: 40) {
                   let fila = Fila(idm: m.idm, nombre: nom, descripcion: des, imagen: imgn)
                    self.listaPersonajes.append(fila)
                    self.listaPersonajesBusqueda.append(fila)
               }
            }
            print("*: Personajes en BDD:", self.listaPersonajes.count)
            self.tablaPersonajes.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:  NSNotification.Name("OKCARGA"), object: nil)
    }
    
}

extension PersonajesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listaPersonajes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaPersonaje", for: indexPath)
        let fila = listaPersonajes[indexPath.row]
        cell.textLabel?.text = fila.nombre
        cell.detailTextLabel?.text = fila.descripcion
        cell.imageView?.image = fila.imagen
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.barraBuscar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "detalleSegue" {
            guard let celda = sender as? UITableViewCell,
                let indexPath = self.tablaPersonajes.indexPath(for: celda),
               let destination = segue.destination as? PersonajeDetalleViewController  else {
                  return
            }
            destination.idPersonaje = listaPersonajes[indexPath.row].idm
         }
       }
}

extension PersonajesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.listaPersonajes = self.listaPersonajesBusqueda
        } else {
            self.listaPersonajes = self.listaPersonajesBusqueda.filter({ (dato) -> Bool in
                let valor: NSString = (dato.nombre ) as NSString
                let lista = valor.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                let r = lista.location != NSNotFound
                return r
            })
        }
        self.tablaPersonajes.reloadData()
    }
    
}
