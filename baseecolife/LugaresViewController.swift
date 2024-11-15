//
//  LugaresViewController.swift
//  baseecolife
//
//  Created by Administrador on 28/10/24.
//

import UIKit

class LugaresViewController : UIViewController{
    let titulo = ["La casa de pedro", "la paella inmortañ"]
    
    let ubi = ["Una casa", "Una calle"]
    
    let horario = ["10:00-7:00", "15:00-21:00"]
    
    let días = ["Toda la semana", "Lu,Ma,Mi,Vi,Do"]
    
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
        print("item")
        print(indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LugaresCellSirve", for: indexPath) as! LugaresCollectionViewCell
        cell.tituloLabel.text = titulo[indexPath.row]
        cell.ubicacionLabel.text = ubi[indexPath.row]
        cell.diasLabel.text = días[indexPath.row]
        cell.horarioLabel.text = horario[indexPath.row]
        return cell
    }

}

