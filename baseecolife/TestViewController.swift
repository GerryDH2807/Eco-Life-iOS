//
//  TestViewController.swift
//  baseecolife
//
//  Created by Administrador on 14/10/24.
//

import UIKit

class TestViewController: UIViewController {
    
    var data: [String] = []
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        collectionView.isHidden = true
        collectionView.dataSource = self
    }
    
    @IBAction func terrestreBoton(_ sender: UIButton) {
        data = ["Terrestre0","Terrestre1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7","Factor0","Factor1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7"]
        collectionView.reloadData()
        collectionView.isHidden = false
    }
    
    @IBAction func acuaticoBoton(_ sender: UIButton) {
        data = ["Acuatico0","Acuatico1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7","Factor0","Factor1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7"]
        collectionView.reloadData()
        collectionView.isHidden = false
    }
    
    @IBAction func aereoBoton(_ sender: UIButton) {
        data = ["Aereo0","Aereo1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7","Factor0","Factor1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7"]
        collectionView.reloadData()
        collectionView.isHidden = false
    }
    
    @IBAction func otrosBoton(_ sender: UIButton) {
        data = ["Otros0","Otros1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7","Factor0","Factor1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7"]
        collectionView.reloadData()
        collectionView.isHidden = false
    }
    
    
    @IBAction func cerrarBoton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}



extension TestViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "factoresCell", for: indexPath) as! FactoresCollectionViewCell
        cell.labelFactor.text = data[indexPath.row]
        return cell
    }
}

