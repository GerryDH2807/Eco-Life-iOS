//
//  EnergiaViewController.swift
//  baseecolife
//
//  Created by Administrador on 16/11/24.
//

import UIKit

class EnergiaViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        fieldEnergia.delegate = self
    }

    @IBOutlet weak var fieldEnergia: UITextField!
    
    @IBAction func cerrarPopOverEner(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let nc = NotificationCenter.default

    @IBAction func continuarBoton(_ sender: Any) {
        // Verificar si el campo de texto tiene un valor válido
        if let text = fieldEnergia.text, let emisionUsuario = Float(text) {
            // Multiplicar el valor ingresado por 2
            let emisionMultiplicada = emisionUsuario * 0.5
            
            // Instancia del model manager y llamada a la función
            let _ = ModelManager.instance.addEmisionEner(emisionUsuarioEner: emisionMultiplicada, fechaCarga: "")
            
            nc.post(name: Notification.Name("EmisionesEnerAdded"), object: nil)
            dismiss(animated: true, completion: nil)
        } else {
            print("Error: valor no válido en el campo de texto.")
        }
    }

    // Guardar el valor mientras se edita sin llamar a modelManager
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
