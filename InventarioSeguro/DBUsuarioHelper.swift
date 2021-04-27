//
//  DBUsuarioHelper.swift
//  InventarioSeguro
//
//  Created by Maggie Jimenez Herrera on 27/04/21.
//

import Foundation
import SQLite3

class DBUsuarioHelper {
    
    let dbPath: String = "inventarioSeguroDB.sqlite"
    var db:OpaquePointer?
    
    init(){
        db = openDatabase()
        createTable()
    }
    
    func openDatabase() -> OpaquePointer? {
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print("error opening db")
            return nil
        }
        else {
            print("Successfully open db")
            return db
        }
    }
    
    func createTable() {
        let createTableString =
            "CREATE TABLE IF NOT EXISTS usuario(id INTEGER PRIMARY KEY, nombre TEXT, correo TEXT, cargo TEXT);"
        var createTableStatment: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatment, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatment) == SQLITE_DONE{
                print("usuario table created")
            }
            else {
                print("usuario table could not be created")
            }
        }
        else {
            print("CREATE TABLE statement could not be prepared")
        }
        sqlite3_finalize(createTableStatment)
    }
    
    func insert(id:Int, nombre:String, correo:String, cargo:String) {
        
        let usuarios = read()
        for usuario in usuarios{
            if usuario.id == id {
                return
            }
        }
        let insertStatenentString =
            "INSERT INTO usuario (id, nombre, correo, cargo) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatenentString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (nombre as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (correo as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (cargo as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("Successfully inserted row")
            }
            else {
                print("Could not insert row")
            }
        }
        else {
            print("INSERT statement could not be prepared")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Usuario] {
        let queryStatementString = "SELECT * FROM usuario;"
        var queryStatement: OpaquePointer? = nil
        var usuarios : [Usuario] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let nombre = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let correo = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let cargo = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                usuarios.append(Usuario(id: Int(id), nombre: nombre, correo: correo, cargo: cargo))
                //print("Query Result: ")
                //print("\(id) | \(numeroIdent)")
            }
        }
        else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return usuarios
    }
    
    func deleteByID(id:Int) {
        let deleteStatementString = "DELETE FROM usuario WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row")
            }
            else {
                print("Cloud not delete row")
            }
        }
        else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}