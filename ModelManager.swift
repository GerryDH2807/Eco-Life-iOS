//
//  ModelManager.swift
//  baseecolife
//
//  Created by Administrador on 14/10/24.
//
import Foundation

let sharedInstance = ModelManager()

class ModelManager: NSObject{
    var database : FMDatabase?
    
    class var instance: ModelManager{
        let documentsFolder = NSSearchPathForDirectoriesInDomains (.documentDirectory, .userDomainMask, true)[0] as String
        let databaseFileName = "pruebas.sqlite"
                let path = (documentsFolder as NSString).appendingPathComponent(databaseFileName)
                
                sharedInstance.database = FMDatabase(path: path)
        return sharedInstance
    }
    
    func createDatabase() -> Bool {
        sharedInstance.database!.open()
        let isCreated = sharedInstance.database!.executeUpdate(
            "CREATE TABLE IF NOT EXISTS EmisionBasura( ID_Desecho   INTEGER, FactorDes   INTEGER, ValorDes    REAL, PRIMARY KEY(ID_Desecho AUTOINCREMENT),FOREIGN KEY(FactorDes) REFERENCES FactorBasura(ID_FactorDes));CREATE TABLE IF NOT EXISTS FactorBasura (ID_FactorDes   INTEGER,Nombre   TEXT,Valor   REAL,PRIMARY KEY(ID_FactorDes AUTOINCREMENT));COMMIT;",
            withArgumentsIn: [])
        sharedInstance.database!.close()
        return isCreated
    }
    
    func addMovie(name: String, review: Int) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO EmisionEnergia (FactorEner, ValorEner) VALUES(?, ?)", withArgumentsIn: [name, review])
        sharedInstance.database!.close()
        return isInserted
        
    }
    
    func findTest (name: String) -> Movie {
        let mov = Movie()
        sharedInstance.database!.open()
        let resultSet = sharedInstance.database!.executeQuery("SELECT * FROM EmisionTransporte WHERE FactorTransp=?", withArgumentsIn: [name])
        if resultSet != nil && (resultSet?.next())! {
            mov.id = Int((resultSet?.int(forColumn: "FactorTransp"))!)
            mov.name = name
            mov.review = Int((resultSet?.int(forColumn: "ValorTransp"))!)
        }
        sharedInstance.database!.close()
        return mov
    }
    
    func deleteTest(name: String) -> Bool{
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM test WHERE name=?", withArgumentsIn: [name])
        sharedInstance.database!.close()
        return isDeleted
    }
    
    
    
    
    
}
