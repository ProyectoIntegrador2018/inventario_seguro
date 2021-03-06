//
//  DBRegistroHelper.swift
//  InventarioSeguro
//
//  Created by Angel Trevino on 27/04/21.
//

import Foundation
import SQLite3

class DBRegistroHelper {
    
    let dbPath: String  = "inventarioSeguroDB.sqlite"
    var db: OpaquePointer?
    
    init() {
        db = openDatabase()
        createTable()
    }
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
        var db:OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        } else {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS registro(Id TEXT PRIMARY KEY, IdUsuario TEXT, idRollos TEXT, Ubicacion TEXT, Fecha TEXT, Accuracy INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("registro table created")
            } else {
                print("registro table could not be created")
            }
        } else {
            print("CREATE TABLE statement could not be prepared")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(
        id: String,
        idUsuario: String,
        idRollos: String,
        ubicacion: String,
        fecha: String,
        accuracy: Int
    ) {
        let registros = read()
        for r in registros {
            if r.id == id {
                return
            }
        }
        
        let insertStatementString = "INSERT INTO registro(Id, IdUsuario, idRollos, Ubicacion, Fecha, Accuracy) VALUES(?, ?, ?, ?, ?, ?)"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (idUsuario as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (idRollos as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (ubicacion as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (fecha as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 6, Int32(accuracy))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Registro] {
        let queryStatementString = "SELECT * FROM registro;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Registro] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let idUsuario = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let idRollos = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let ubicacion = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let fecha = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let accuracy = sqlite3_column_int(queryStatement, 5)
                psns.append(Registro(id: id, idUsuario: idUsuario, idRollos: idRollos, ubicacion: ubicacion, fecha: fecha, accuracy: Int(accuracy)))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func read_UID(uid: String) -> [Registro] {
        let queryStatementString = "SELECT * FROM registro WHERE IdUsuario = ?;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Registro] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (uid as NSString).utf8String, -1, nil)
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let idUsuario = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let idRollos = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let ubicacion = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let fecha = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let accuracy = sqlite3_column_int(queryStatement, 5)
                psns.append(Registro(id: id, idUsuario: idUsuario, idRollos: idRollos, ubicacion: ubicacion, fecha: fecha, accuracy: Int(accuracy)))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    
    
    func deleteByID(id: String) {
        let deleteStatementStirng = "DELETE FROM registro WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (id as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
