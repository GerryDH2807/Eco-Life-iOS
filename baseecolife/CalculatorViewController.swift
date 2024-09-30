//
//  Untitled.swift
//  baseecolife
//
//  Created by Administrador on 26/09/24.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var EmisionTransp: UILabel!
    
    @IBAction func BotonActTransp(_ sender: Any) {
        
        
        
    }
    
    func actualizacionTransp() {
        EmisionTransp.text = BotonActTransp(<#T##sender: Any##Any#>)

    }
    
    
}
