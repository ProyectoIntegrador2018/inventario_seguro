//
//  DBHelper.swift
//  InventarioSeguro
//
//  Created by Maggie Jimenez Herrera on 26/04/21.
//

import Foundation
import SQLite3

class DBRolloHelper {
    
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
            "CREATE TABLE IF NOT EXISTS rollo(id TEXT INTEGER PRIMARY KEY, numeroIdent TEXT);"
        var createTableStatment: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatment, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatment) == SQLITE_DONE{
                print("rollo table created")
            }
            else {
                print("rollo table could not be created")
            }
        }
        else {
            print("CREATE TABLE statement could not be prepared")
        }
        sqlite3_finalize(createTableStatment)
    }
    
    func insert(id:String, numeroIdent:String) {
        
        let rollos = read()
        for rollo in rollos{
            if rollo.id == id {
                return
            }
        }
        let insertStatenentString =
            "INSERT INTO rollo (id, numeroIdent) VALUES (?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatenentString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (numeroIdent as NSString).utf8String, -1, nil)
            
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
    
    func read() -> [Rollo] {
        let queryStatementString = "SELECT * FROM rollo;"
        var queryStatement: OpaquePointer? = nil
        var rollos : [Rollo] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let numeroIdent = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                rollos.append(Rollo(id: id, numeroIdent: numeroIdent))
                //print("Query Result: ")
                //print("\(id) | \(numeroIdent)")
            }
        }
        else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return rollos
    }
    
    func read_rid(ids:[String]) -> [Rollo] {
        let format_ids = ids.joined(separator: ",")
        print(format_ids)
        let format_ids2 = "F2882720-4008-45F8-9B94-AB07C34110D4,6AC651C7-CB39-49D3-9EAA-4C07BB4CA73"
        let queryStatementString = "SELECT * FROM rollo WHERE id IN (?);"
        var queryStatement: OpaquePointer? = nil
        var rollos : [Rollo] = []
    
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (format_ids2 as NSString).utf8String, -1, nil)
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let numeroIdent = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                rollos.append(Rollo(id: id, numeroIdent: numeroIdent))
                //print("Query Result: ")
                //print("\(id) | \(numeroIdent)")
            }
        }
        else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return rollos
    }
    
    
    func deleteByID(id: String) {
        let deleteStatementString = "DELETE FROM rollo WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (id as NSString).utf8String, -1, nil)
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
