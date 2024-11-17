//
//  LugaresCollectionViewCell.swift
//  baseecolife
//
//  Created by Administrador on 29/10/24.
//

import UIKit


class LugaresCollectionViewCell:UICollectionViewCell{
    
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var ubicacionLabel: UILabel!
    @IBOutlet weak var diasLabel: UILabel!
    @IBOutlet weak var horarioLabel: UILabel!
    
    
    @IBOutlet weak var imagenLugares: UIImageView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            
            // Configuración inicial de la imagen, si es necesario
            imagenLugares.layer.masksToBounds = true // Asegura que el cornerRadius se aplique correctamente
        }
}
