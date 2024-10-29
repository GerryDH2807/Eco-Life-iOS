//
//  ViewController.swift
//  baseecolife
//
//  Created by Administrador on 02/09/24.
//

import UIKit

class ViewController: UIViewController {

    // Arreglos para almacenar los títulos y descripciones
    let titulos = ["Título 1", "Título 2", "Título 3", "Título 4", "Título 5"]
    let descripciones = [
        "Descripción del reto 1.",
        "Descripción del reto 2.",
        "Descripción del reto 3.",
        "Descripción del reto 4.",
        "Descripción del reto 5."
    ]
    
    
    let diccionariotest: [String: Int] = [
        "No hay reto prueba" :0,
        "Reto de prueba 1": 1,
        "Reto de prueba 2": 2,
        "Reto de prueba 3": 3,
        "Reto de prueba 4": 4,
        "Reto de prueba 5": 5,
        "Reto de prueba 6": 6,
        "Reto de prueba 7": 7,
        "Reto de prueba 8": 8,
        "Reto de prueba 9": 9,
        "Reto de prueba 10": 10
        
    ]

    // Índice actual del carrusel
    var indiceActual = 0
    var indiceReto = 0

    // Outlets para los elementos de la interfaz
    @IBOutlet weak var TituloReco: UILabel!
    @IBOutlet weak var RecoInfo: UITextView!
    @IBOutlet weak var retoActivo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Cargar el primer título y descripción
        let docName = "pruebas"
        let docExt = "sqlite"
        copyFilesToDocumentsFolder(nameForFile: docName, extForFile: docExt)
        actualizarVista()
        
    }
    
    func copyFilesToDocumentsFolder(nameForFile: String, extForFile: String){
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destURL = documentsURL!.appendingPathComponent(nameForFile).appendingPathExtension(extForFile)
        guard let sourceURL = Bundle.main.url(forResource: nameForFile, withExtension: extForFile)
        else{
            print("Sorce file not found")
            return
        }
        let fileManager = FileManager.default
        do{
            try fileManager.copyItem(at: sourceURL, to: destURL)
        } catch {
            print("Unable to copy file")
        }
    }

    @IBAction func BotonIzquCar(_ sender: Any) {
        // Decrementar el índice y manejar el carrusel circular
        indiceActual = (indiceActual - 1 + titulos.count) % titulos.count
        actualizarVista()
    }

    @IBAction func BotonDerCar(_ sender: Any) {
        // Incrementar el índice y manejar el carrusel circular
        indiceActual = (indiceActual + 1) % titulos.count
        actualizarVista()
    }
    
    
    @IBAction func generarReto(_ sender: Any) {
        indiceReto = Int.random(in: 1...10)
        actualizarVista()
    }
    
    
    
    
    
    

    // Función para actualizar la vista con el título y descripción actual
    func actualizarVista() {
        TituloReco.text = titulos[indiceActual]
        RecoInfo.text = descripciones[indiceActual]

        // Obtener el valor del diccionario usando el índice del reto
        if let retoTexto = diccionariotest.first(where: { $0.value == indiceReto })?.key {
            retoActivo.text = retoTexto
        } else {
            retoActivo.text = "Reto no encontrado"
        }
    }
    
    
    
    
    
    
}

