//
//  Registro.swift
//  InventarioSeguro
//
//  Created by Angel Trevino on 27/04/21.
//

import Foundation

class Registro {
    var id: Int = 0
    var idUsuario: Int = 0
    var idRollos: String = ""
    var ubicacion: String = ""
    var fecha: String
    
    init(
        id: Int,
        idUsuario: Int,
        idRollos: String,
        ubicacion: String,
        fecha: String
    ) {
        self.id = id
        self.idUsuario = idUsuario
        self.idRollos = idRollos
        self.ubicacion = ubicacion
        self.fecha = fecha
    }
}
