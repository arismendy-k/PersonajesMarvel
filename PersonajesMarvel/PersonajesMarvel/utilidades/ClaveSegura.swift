//
//  ClaveSegura.swift
//  DescargarURL
//
//  Created by Carlos Arismendy on 17/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import Foundation

open class ClaveSegura {
    static func grabar(key:String, data:Data){
       let query = [kSecClass as String: kSecClassGenericPassword as String,
                    kSecAttrAccount as String: key, kSecValueData as String: data]
                as [String:Any]
       SecItemDelete(query as CFDictionary)
       let result = SecItemAdd(query as CFDictionary, nil)
       if result != errSecSuccess {
          print("Error de grabacion")
       }
    }

    static func cargar(key:String) -> Data? {
       let query = [kSecClass as String: kSecClassGenericPassword as String,
                    kSecAttrAccount as String: key,
                    kSecReturnData as String: kCFBooleanTrue as Any,
                    kSecMatchLimit as String: kSecMatchLimitOne ]
                as [String:Any]
       var dataTypeRef:AnyObject?
       let status:OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
       if status == noErr {
          return dataTypeRef as! Data?
       } else {
          return nil
       }
    }

}
