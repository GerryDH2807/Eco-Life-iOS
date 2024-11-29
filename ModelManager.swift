import Foundation

let sharedInstance = ModelManager()

class ModelManager: NSObject {
    var database: FMDatabase?

    class var instance: ModelManager {
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let databaseFileName = "DatabaseEco.sqlite3"
        let path = (documentsFolder as NSString).appendingPathComponent(databaseFileName)
        
        sharedInstance.database = FMDatabase(path: path)
        return sharedInstance
    }

    func findFactoresTransp(tipoFact: Int) -> [Factores] {
        var factoresList: [Factores] = [] // Array para almacenar los factores
        sharedInstance.database!.open()

        // Ejecutar consulta y verificar errores
        if let resultSet = sharedInstance.database!.executeQuery("SELECT Nombre, Valor FROM FactorTransporte WHERE TipoFact = ?", withArgumentsIn: [tipoFact]) {
            print("Consulta ejecutada correctamente para tipoFact = \(tipoFact)")
            while resultSet.next() {
                let fact = Factores()
                if let nombreFactor = resultSet.string(forColumn: "Nombre") {
                    fact.nameFactor = nombreFactor
                    fact.valorFactor = Float(resultSet.double(forColumn: "Valor"))
                    factoresList.append(fact) // Agregar el objeto Factores al array
                }
            }
            resultSet.close() // Cerrar el resultSet
        } else {
            print("Error al ejecutar la consulta: \(sharedInstance.database!.lastErrorMessage())")
        }

        sharedInstance.database!.close()
        print("Factores encontrados: \(factoresList)")
        return factoresList // Devolver el array de Factores
    }

    func findFactoresAli(tipoFact: Int) -> [Factores] {
        var factoresList: [Factores] = [] // Array para almacenar los factores
        sharedInstance.database!.open()

        // Ejecutar consulta y verificar errores
        if let resultSet = sharedInstance.database!.executeQuery("SELECT Nombre, Valor FROM FactorAlimento WHERE TipoFact = ?", withArgumentsIn: [tipoFact]) {
            print("Consulta ejecutada correctamente para tipoFact = \(tipoFact)")
            while resultSet.next() {
                let fact = Factores()
                if let nombreFactor = resultSet.string(forColumn: "Nombre") {
                    fact.nameFactor = nombreFactor
                    fact.valorFactor = Float(resultSet.double(forColumn: "Valor"))
                    factoresList.append(fact) // Agregar el objeto Factores al array
                }
            }
            resultSet.close() // Cerrar el resultSet
        } else {
            print("Error al ejecutar la consulta: \(sharedInstance.database!.lastErrorMessage())")
        }

        sharedInstance.database!.close()
        print("Factores encontrados: \(factoresList)")
        return factoresList // Devolver el array de Factores
    }

    func findFactoresDese(tipoFact: Int) -> [Factores] {
        var factoresList: [Factores] = [] // Array para almacenar los factores
        sharedInstance.database!.open()

        // Ejecutar consulta y verificar errores
        if let resultSet = sharedInstance.database!.executeQuery("SELECT Nombre, Valor FROM FactorBasura WHERE TipoFac = ?", withArgumentsIn: [tipoFact]) {
            print("Consulta ejecutada correctamente para tipoFact = \(tipoFact)")
            while resultSet.next() {
                let fact = Factores()
                if let nombreFactor = resultSet.string(forColumn: "Nombre") {
                    fact.nameFactor = nombreFactor
                    fact.valorFactor = Float(resultSet.double(forColumn: "Valor"))
                    factoresList.append(fact) // Agregar el objeto Factores al array
                }
            }
            resultSet.close() // Cerrar el resultSet
        } else {
            print("Error al ejecutar la consulta: \(sharedInstance.database!.lastErrorMessage())")
        }

        sharedInstance.database!.close()
        print("Factores encontrados: \(factoresList)")
        return factoresList // Devolver el array de Factores
    }

    func obtenerHistorial(fechaBusqueda: String) -> Historial? {
        print("Attempting to fetch data for date: \(fechaBusqueda)")
        sharedInstance.database!.open()
        
        var historial: Historial? = nil
        if let resultSet = sharedInstance.database!.executeQuery(
            "SELECT * FROM Historial WHERE Fecha = ?;", withArgumentsIn: [fechaBusqueda]) {
            
            if resultSet.next() {
                historial = Historial(resultSet: resultSet)
                print("Data retrieved for \(fechaBusqueda): \(String(describing: historial))")
            } else {
                print("No data found for date: \(fechaBusqueda)")
            }
            resultSet.close()
        } else {
            print("Query error: \(sharedInstance.database!.lastErrorMessage())")
        }
        
        sharedInstance.database!.close()
        return historial
    }

    func obtenerPruebaSubida(fechaBusqueda: String) -> PrubasDeBase {
        let hist = PrubasDeBase()
        sharedInstance.database!.open()
        
        let resultSet = sharedInstance.database!.executeQuery(
            "SELECT ValorTrans, ValorFactor FROM EmisionTransporte WHERE FechaCarga = ?",
            withArgumentsIn: [fechaBusqueda]
        )
        
        if let resultSet = resultSet, resultSet.next() {
            hist.pruebasSalperra = Float(resultSet.double(forColumn: "ValorTrans"))
            hist.pruebaFactor = Int(resultSet.int(forColumn: "ValorFactor"))
        }
        
        sharedInstance.database!.close()
        return hist
    }

    func addEmisionTransp(emisionUsuarioTransp: Float, fechaCarga: String, valorFactor: Float) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate(
            "INSERT INTO EmisionTransporte (ValorTrans, FechaCarga, ValorFactor) VALUES (?, ?, ?);",
            withArgumentsIn: [emisionUsuarioTransp, fechaCarga, valorFactor]
        )
        
        sharedInstance.database!.close()
        return isInserted
    }
    
    func addEmisionAli(emisionUsuarioAli: Float, fechaCarga: String, valorFactor: Float) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate(
            "INSERT INTO EmisionAlimentos (ValorAli, FechaCarga, ValorFactor) VALUES (?, ?, ?);",
            withArgumentsIn: [emisionUsuarioAli, fechaCarga, valorFactor]
        )
        
        sharedInstance.database!.close()
        return isInserted
    }
    
    func addEmisionDese(emisionUsuarioDese: Float, fechaCarga: String, valorFactor: Float) -> Bool {
        
        print("Intentando agregar emisión DESECHO con valores: \(emisionUsuarioDese), \(fechaCarga), \(valorFactor)")
        
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate(
            "INSERT INTO EmisionBasura (ValorDes, FechaCarga, ValorFactor) VALUES (?, ?, ?);",
            withArgumentsIn: [emisionUsuarioDese, fechaCarga, valorFactor]
        )
        
        sharedInstance.database!.close()
        return isInserted
    }
    
    func addEmisionEner(emisionUsuarioEner: Float, fechaCarga: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let fechaActual = Date()
        let fechaFormateada = dateFormatter.string(from: fechaActual)
        
        print("Intentando updatear historial energia con valores: \(emisionUsuarioEner), \(fechaCarga)")
        
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate(
            "UPDATE Historial SET TotalEnergia = ? WHERE Fecha = ?",
            withArgumentsIn: [emisionUsuarioEner, fechaFormateada]
        )
        
        sharedInstance.database!.close()
        return isInserted
    }
    
    func addFactorTransporte(nombre: String) -> Bool {
        sharedInstance.database!.open()
        let tipoFact = 4 // Tipo fijo para los factores creados
        let isInserted = sharedInstance.database!.executeUpdate(
            "INSERT INTO FactorTransporte (Nombre, TipoFact) VALUES (?, ?);",
            withArgumentsIn: [nombre, tipoFact]
        )
        sharedInstance.database!.close()
        
        if !isInserted {
            print("Error al insertar el factor de transporte: \(sharedInstance.database!.lastErrorMessage())")
        }
        
        return isInserted
    }


    func RecuperarEmisionesSubidas(FechaSubida: String) -> [ListaDeEmisionesSeleccionadas] {
        var EmisionesSubidas: [ListaDeEmisionesSeleccionadas] = []
        sharedInstance.database!.open()
        
        if let resultSet = sharedInstance.database!.executeQuery("SELECT ValorTrans, ValorFactor FROM EmisionTransporte WHERE FechaCarga = ?", withArgumentsIn: [FechaSubida]) {
            while resultSet.next() {
                let lis = ListaDeEmisionesSeleccionadas()
                lis.valorUsuarioEmisionSubida = resultSet.double(forColumn: "ValorTrans")
                lis.valorFactorSeleccionado = resultSet.double(forColumn: "ValorFactor")
                EmisionesSubidas.append(lis)
            }
            resultSet.close()
        }
        
        sharedInstance.database!.close()
        return EmisionesSubidas
    }
    
    func RecuperarEmisionesSubidasAli(FechaSubida: String) -> [ListaDeEmisionesSeleccionadas] {
        var EmisionesSubidas: [ListaDeEmisionesSeleccionadas] = []
        sharedInstance.database!.open()
        
        if let resultSet = sharedInstance.database!.executeQuery("SELECT ValorAli, ValorFactor FROM EmisionAlimentos WHERE FechaCarga = ?", withArgumentsIn: [FechaSubida]) {
            while resultSet.next() {
                let lis = ListaDeEmisionesSeleccionadas()
                lis.valorUsuarioEmisionSubida = resultSet.double(forColumn: "ValorAli")
                lis.valorFactorSeleccionado = resultSet.double(forColumn: "ValorFactor")
                EmisionesSubidas.append(lis)
            }
            resultSet.close()
        }
        
        sharedInstance.database!.close()
        return EmisionesSubidas
    }
    
    func RecuperarEmisionesSubidasDese(FechaSubida: String) -> [ListaDeEmisionesSeleccionadas] {
        var EmisionesSubidas: [ListaDeEmisionesSeleccionadas] = []
        sharedInstance.database!.open()
        
        if let resultSet = sharedInstance.database!.executeQuery("SELECT ValorDes, ValorFactor FROM EmisionBasura WHERE FechaCarga = ?", withArgumentsIn: [FechaSubida]) {
            while resultSet.next() {
                let lis = ListaDeEmisionesSeleccionadas()
                lis.valorUsuarioEmisionSubida = resultSet.double(forColumn: "ValorDes")
                lis.valorFactorSeleccionado = resultSet.double(forColumn: "ValorFactor")
                EmisionesSubidas.append(lis)
            }
            resultSet.close()
        }
        
        sharedInstance.database!.close()
        return EmisionesSubidas
    }

    func updateHistorialtrasEmision(SumaTotal: Double) -> Bool {
        sharedInstance.database!.open()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let fechaActual = Date()
        let fechaFormateada = dateFormatter.string(from: fechaActual)
        
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Historial SET TotalTransporte = ? WHERE Fecha = ?", withArgumentsIn: [SumaTotal, fechaFormateada])
        
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func updateHistorialtrasEmisionAli(SumaTotal: Double) -> Bool {
        sharedInstance.database!.open()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let fechaActual = Date()
        let fechaFormateada = dateFormatter.string(from: fechaActual)
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Historial SET TotalAlimento = ? WHERE Fecha = ?", withArgumentsIn: [SumaTotal, fechaFormateada])
        
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func updateHistorialtrasEmisionDese(SumaTotal: Double) -> Bool {
        sharedInstance.database!.open()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let fechaActual = Date()
        let fechaFormateada = dateFormatter.string(from: fechaActual)
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Historial SET TotalDesecho = ? WHERE Fecha = ?", withArgumentsIn: [SumaTotal, fechaFormateada])
        
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func historialCada12() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let fechaActual = Date()
        let fechaFormateada = dateFormatter.string(from: fechaActual)
        
        sharedInstance.database!.open()
        
        // Usamos executeUpdate para una inserción, no executeQuery
        let querySuccess = sharedInstance.database!.executeUpdate(
            "INSERT INTO Historial (Fecha, TotalDesecho, TotalEnergia, TotalAlimento, TotalTransporte) VALUES (? , NULL, NULL, NULL, NULL)",
            withArgumentsIn: [fechaFormateada]
        )
        
        sharedInstance.database!.close()
        
        // Retornamos el resultado de executeUpdate como un booleano
        return querySuccess // Este es un booleano
    }
    
    //BD JUEGO
    func saveHighScore(score: Int) -> Bool {
            sharedInstance.database!.open()
            let isInserted = sharedInstance.database!.executeUpdate(
                "INSERT INTO Highscores (score) VALUES (?);",
                withArgumentsIn: [score]
            )
            sharedInstance.database!.close()

            if isInserted {
                print("Nueva puntuación guardada: \(score)")
            } else {
                print("Error al guardar la puntuación: \(sharedInstance.database!.lastErrorMessage())")
            }
            return isInserted
        }

        func getHighestScore() -> Int {
            sharedInstance.database!.open()
            var highestScore = 0
            if let resultSet = sharedInstance.database!.executeQuery("SELECT MAX(score) FROM Highscores;", withArgumentsIn: []) {
                if resultSet.next() {
                    highestScore = Int(resultSet.int(forColumnIndex: 0))
                }
                resultSet.close()
            }
            sharedInstance.database!.close()

            print("Puntuación más alta recuperada: \(highestScore)")
            return highestScore
        }
}
