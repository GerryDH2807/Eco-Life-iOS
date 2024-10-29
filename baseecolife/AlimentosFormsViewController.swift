//
//  AlimentosFormsViewController.swift
//  baseecolife
//
//  Created by Administrador on 26/10/24.
//

import UIKit

class AlimentosFormsViewController: UIViewController{
    
    var data: [String] = []
    
    @IBOutlet weak var factoresAlicv: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        factoresAlicv.isHidden = true
        factoresAlicv.dataSource = self
    }
    
    @IBAction func reciclaBoton(_ sender: Any) {
        data = ["Recicla0","Recicla1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7","Factor8","Factor9","Factor10","Factor11","Factor12","Factor13","Factor14",]
        factoresAlicv.reloadData()
        factoresAlicv.isHidden = false
        
    }
    
    @IBAction func organiBoton(_ sender: Any) {
        data = ["Organico0","Orginanico1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7","Factor8","Factor9","Factor10","Factor11","Factor12","Factor13","Factor14",]
        factoresAlicv.reloadData()
        factoresAlicv.isHidden = false
    }
    
    @IBAction func inorganiBoton(_ sender: Any) {
        data = ["Inorgacico0","Inorganico1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7","Factor8","Factor9","Factor10","Factor11","Factor12","Factor13","Factor14",]
        factoresAlicv.reloadData()
        factoresAlicv.isHidden = false
    }
    
    
    @IBAction func borrarBotonAli(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension AlimentosFormsViewController: UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "factoresAli", for: indexPath) as! AlimentosCollectionViewCell
        cell.labelFactAli.text = data[indexPath.row]
        return cell
    }

}
