//
//  InputFormularioAlimentoCollectionViewCell.swift
//  baseecolife
//
//  Created by Administrador on 13/11/24.
//

import UIKit

class InputFormularioAlimentoCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var inputFormulario: UITextField!
    
    var factor: Factores? // La referencia al factor relacionado

    func configure(with factor: Factores) {
        self.factor = factor
        labelTitulo.text = factor.nameFactor
        inputFormulario.text = factor.inputValue
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField){
        // Encuentra la celda que contiene este UITextField
        if let cell = sender.superview?.superview as? InputFormularioCollectionViewCell {
            // Actualiza el valor del modelo con el texto del UITextField
            if let factor = cell.factor {
                factor.inputValue = sender.text
                print("Actualizado alimento inputValue para \(factor.nameFactor) a \(sender.text ?? "")")
            }
        }
    }
}
