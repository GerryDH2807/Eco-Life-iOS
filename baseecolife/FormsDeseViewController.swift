import UIKit

class FormsDeseViewController: UIViewController{
    
    var data: [String] = []
    
    @IBOutlet weak var factoresDesechosCV: UICollectionView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        factoresDesechosCV.isHidden = true
        factoresDesechosCV.dataSource = self
    }
    
    
    @IBAction func carnesBoton(_ sender: Any) {
        data =     ["Carnes0","Carnes1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7","Factor0","Factor1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7"]
        factoresDesechosCV.reloadData()
        factoresDesechosCV.isHidden = false
    }
    
    @IBAction func lacteosBoton(_ sender: Any) {
        data =     ["Lacteos0","Lacteos1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7","Factor0","Factor1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7"]
        factoresDesechosCV.reloadData()
        factoresDesechosCV.isHidden = false
    }
    
    @IBAction func proceadosBoton(_ sender: Any) {
        data =     ["Procesados0","Proceados1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7","Factor0","Factor1","Factor2","Factor3","Factor4","Factor5","Factor6","Factor7"]
        factoresDesechosCV.reloadData()
        factoresDesechosCV.isHidden = false
    }
    
    
    @IBAction func cerrarBotonDese(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension FormsDeseViewController: UICollectionViewDataSource{
    func collectionView(_ factoresDesechosCV: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        data.count
    }
    
    func collectionView(_ factoresDesechosCV: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = factoresDesechosCV.dequeueReusableCell(withReuseIdentifier: "factoresDesechos", for: indexPath) as! DesechosCollectionViewCell
        cell.labelFactorDesecho.text = data[indexPath.row]
        return cell
    }
}
