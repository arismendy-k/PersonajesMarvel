//
//  ExtensionUIImage.swift
//  PersonajesMarvel
//
//  Created by Carlos Arismendy on 21/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    func redimensionarImagen(ancho: Int, alto: Int) -> UIImage? {
        let size = CGSize(width: ancho, height: alto)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
