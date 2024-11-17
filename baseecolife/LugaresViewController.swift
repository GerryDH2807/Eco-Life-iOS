//
//  LugaresViewController.swift
//  baseecolife
//
//  Created by Administrador on 28/10/24.
//

import UIKit

class LugaresViewController : UIViewController{
    let titulo = ["La casa verde", "EcoloFood", "D.O. HD Naturales", "100% Zona Bio"]
    
    let ubi = ["P. Sherman, 42 Wallaby Way", "P. Sherman, 42 Wallaby Way", "P. Sherman, 42 Wallaby Way", "P. Sherman, 42 Wallaby Way"]
    
    let horario = ["09:00 AM - 07:00 PM", "11:00 AM - 05:00 PM", "06:00 AM - 07:00 PM", "01:00 PM - 010:00 PM"]
    
    let días = ["Toda la semana", "Lu,Ma,Mi,Vi,Do","Toda la semana", "Lu,Ma,Mi,Vi,Do"]
    
    var imagenesLugares = [UIImage(named: "0376.jpg"),
                           UIImage(named: "0377.jpg"),
                           UIImage(named: "0378.jpg"),
                           UIImage(named: "0379.jpg")]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
    }
}

extension LugaresViewController: UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        titulo.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LugaresCellSirve", for: indexPath) as! LugaresCollectionViewCell
        cell.tituloLabel.text = titulo[indexPath.row]
        cell.ubicacionLabel.text = ubi[indexPath.row]
        cell.diasLabel.text = días[indexPath.row]
        cell.horarioLabel.text = horario[indexPath.row]
        
        cell.imagenLugares.image = imagenesLugares[indexPath.row]
                
                // Aplicar cornerRadius solo a las esquinas izquierda
                cell.imagenLugares.layer.cornerRadius = 10
                cell.imagenLugares.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return cell
    }

}

