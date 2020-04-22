//
//  ExtensionUIAlert.swift
//  PersonajesMarvel
//
//  Created by Carlos Arismendy on 22/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import Foundation
import UIKit

@objc public extension UIAlertController {
    
    @objc class func aviso(mensaje: String? = "") -> UIAlertController {
        let aviso = UIAlertController(title: "", message: mensaje, preferredStyle: .alert)
        aviso.title = "API Marvel"
        aviso.addAction( UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        return aviso;
    }
}
