//
//  EcoApp.swift
//  baseecolife
//
//  Created by Administrador on 14/10/24.
//

import Foundation

class Movie: NSObject {
    var id = Int()
    var name = String()
    var review = Int()
}

class Factores: NSObject {
    var nameFactor = String()
    var valorFactor = Float()
    var isSelected = false
    var inputValue: String? // Para almacenar el valor del UITextField

    init(nameFactor: String) {
        self.nameFactor = nameFactor
    }
    
    convenience override init() {
        self.init(nameFactor: "Factor desconocido") // Asignar un valor por defecto
    }
}

class Historial: NSObject {
    var id_hist: Int
    var fecha: String
    var valdesecho: Float
    var valtransp: Float
    var valener: Float
    var valali: Float

    // Default initializer
    override init() {
        self.id_hist = 0
        self.fecha = ""
        self.valdesecho = 0.0
        self.valtransp = 0.0
        self.valener = 0.0
        self.valali = 0.0
    }

    // Convenience initializer for initializing from FMResultSet
    init?(resultSet: FMResultSet) {
        guard let fecha = resultSet.string(forColumn: "Fecha") else { return nil }
        
        self.id_hist = Int(resultSet.int(forColumn: "ID_EmisionHist"))
        self.fecha = fecha
        self.valdesecho = Float(resultSet.double(forColumn: "TotalDesecho"))
        self.valtransp = Float(resultSet.double(forColumn: "TotalTransporte"))
        self.valener = Float(resultSet.double(forColumn: "TotalEnergia"))
        self.valali = Float(resultSet.double(forColumn: "TotalAlimento"))
    }
}

class PrubasDeBase: NSObject{
    var pruebasSalperra = Float()
    
    var pruebaFactor = Int()
}


class ListaDeEmisionesSeleccionadas: NSObject{
    var valorUsuarioEmisionSubida = Double()
    var valorFactorSeleccionado = Double()
}
