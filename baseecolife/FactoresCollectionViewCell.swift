//
//  FactoresCollectionViewCell.swift
//  baseecolife
//
//  Created by Administrador on 17/10/24.
//

import UIKit

class FactoresCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var factoresBoton: UIButton!
    @IBOutlet weak var stackFactor: UIStackView!
    
    // Closure to notify the view controller when the button is tapped
    var onFactorSelected: (() -> Void)?
    
    func configure(with factor: Factores) {
        factoresBoton.setTitle(factor.nameFactor, for: .normal)
        
        let selectedColor = UIColor(red: 0/255, green: 154/255, blue: 20/255, alpha: 1.0)
        let deselectedColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        
        factoresBoton.backgroundColor = factor.isSelected ? selectedColor : deselectedColor
        stackFactor.backgroundColor = factor.isSelected ? selectedColor : deselectedColor
        
        // Set up the button action
        factoresBoton.addTarget(self, action: #selector(factorButtonTapped), for: .touchUpInside)
    }
    
    @objc func factorButtonTapped() {
        // Trigger the closure when the button is tapped
        onFactorSelected?()
    }
}
