//
//  ExtensionString.swift
//  PersonajesMarvel
//
//  Created by Carlos Arismendy on 17/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import Foundation
import CommonCrypto
import UIKit

extension String {
   var MD5:String? {
      guard let messageData = data(using: .utf8) else {
         return nil
      }
      var dataMD5 = Data(count: Int(CC_MD5_DIGEST_LENGTH))
      _ = dataMD5.withUnsafeMutableBytes { bytes in
         messageData.withUnsafeBytes { messageBytes in
            CC_MD5(messageBytes.baseAddress,
                   CC_LONG(messageData.count),
                   bytes.bindMemory(to: UInt8.self).baseAddress)
         }
      }
      var MD5String = String()
      for c in dataMD5 {
         MD5String += String(format: "%02x", c)
      }
      return MD5String
   }
    
    func alerta(controlador: UIViewController){
        controlador.present(UIAlertController.aviso(mensaje: self), animated: true)
     }
}
