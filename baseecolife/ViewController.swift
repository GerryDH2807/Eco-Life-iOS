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

    // Índice actual del carrusel
    var indiceActual = 0

    // Outlets para los elementos de la interfaz
    @IBOutlet weak var TituloReco: UILabel!
    @IBOutlet weak var RecoInfo: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Cargar el primer título y descripción
        actualizarVista()
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

    // Función para actualizar la vista con el título y descripción actual
    func actualizarVista() {
        TituloReco.text = titulos[indiceActual]
        RecoInfo.text = descripciones[indiceActual]
    }
    
    
    
    
    
    
}

