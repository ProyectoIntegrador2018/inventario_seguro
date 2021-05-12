//
//  Usuario.swift
//  InventarioSeguro
//
//  Created by Maggie Jimenez Herrera on 27/04/21.
//

import Foundation

class Usuario {
    
    var id : Int = 0
    var nombre : String = ""
    var correo : String = ""
    var password: String = ""
    var cargo : String = ""
    
    init(id:Int, nombre:String, correo:String, password: String, cargo:String) {
        self.id = id
        self.nombre = nombre
        self.correo = correo
        self.password = password
        self.cargo = cargo
    }
    
}
