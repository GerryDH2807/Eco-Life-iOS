import UIKit

class FormsDeseViewController: UIViewController {
    
    var data: [Factores] = [] // Cambiar a un array de Factores
    var selectedFactors: [Factores] = [] // Arreglo para almacenar los ítems seleccionados
    var data2 = ["Hola"] // Arreglo para manejar los campos de texto si es necesario
    
    @IBOutlet weak var factoresDesechosCV: UICollectionView!
    @IBOutlet weak var formularioDesechosCV: UICollectionView! // Nuevo UICollectionView para los campos de texto
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedFactors.removeAll() // Limpiar la lista de factores seleccionados
        factoresDesechosCV.isHidden = false
        formularioDesechosCV.isHidden = false
        
        factoresDesechosCV.dataSource = self
        factoresDesechosCV.delegate = self
        
        formularioDesechosCV.dataSource = self
        formularioDesechosCV.delegate = self
        
        // Recargar ambos collection views al inicio
        factoresDesechosCV.reloadData()
        formularioDesechosCV.reloadData()
    }
    
    @IBAction func carnesBoton(_ sender: Any) {
        let factores = ModelManager.instance.findFactoresDese(tipoFact: 1)
        data = factores // Guardar objetos Factores directamente
        selectedFactors.removeAll() // Limpiar selecciones anteriores
        factoresDesechosCV.reloadData()
        formularioDesechosCV.reloadData()
        factoresDesechosCV.isHidden = false
    }
    
    @IBAction func lacteosBoton(_ sender: Any) {
        let factores = ModelManager.instance.findFactoresDese(tipoFact: 2)
        data = factores
        selectedFactors.removeAll() // Limpiar selecciones anteriores
        factoresDesechosCV.reloadData()
        formularioDesechosCV.reloadData()
        factoresDesechosCV.isHidden = false
    }
    
    @IBAction func procesadosBoton(_ sender: Any) {
        let factores = ModelManager.instance.findFactoresDese(tipoFact: 3)
        data = factores
        selectedFactors.removeAll() // Limpiar selecciones anteriores
        factoresDesechosCV.reloadData()
        formularioDesechosCV.reloadData()
        factoresDesechosCV.isHidden = false
    }
    
    @IBAction func cerrarBotonDese(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let nc = NotificationCenter.default
    
    @IBAction func guardarSelec(_ sender: Any) {
        print("Ítems seleccionados: \(selectedFactors.map { $0.nameFactor })")
        
        // Crear un arreglo para almacenar los valores de los campos de texto
        var valoresCamposTexto: [String] = []
        
        // Recorremos las celdas de formularioDesechosCV (el segundo UICollectionView) para obtener los valores de los UITextFields
        for indexPath in formularioDesechosCV.indexPathsForVisibleItems {
            if let cell = formularioDesechosCV.cellForItem(at: indexPath) as? inputFormularioDesechosCollectionViewCell {
                // Aquí obtenemos el valor del UITextField dentro de la celda
                if let text = cell.inputFormulario.text, !text.isEmpty {
                    valoresCamposTexto.append(text)
                } else {
                    // Si el campo está vacío, podemos manejarlo de alguna manera
                    print("El campo de texto en la celda \(indexPath.row) está vacío.")
                }
            }
        }
        
        // Ahora, recorremos los factores seleccionados y sus valores de entrada
        for (index, factor) in selectedFactors.enumerated() {
            if index < valoresCamposTexto.count {
                let valorUsuario = valoresCamposTexto[index] // Usamos safe subscript para evitar index fuera de rango
                print("Valor ingresado para \(factor.nameFactor): \(valorUsuario)")
                
                // Asignamos el valor ingresado al factor
                factor.inputValue = valorUsuario
            } else {
                print("Advertencia: No hay valor ingresado para el factor \(factor.nameFactor).")
            }
        }
        
        // Ahora procedemos a guardar los valores en la base de datos
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let fechaActual = Date()
        let fechaFormateada = dateFormatter.string(from: fechaActual)
        
        // Verificamos que tenemos valores válidos para usuarioEmision
        for (index, factor) in selectedFactors.enumerated() {
            if index < valoresCamposTexto.count, let usuarioEmision = Float(valoresCamposTexto[index]) {
                // Guardamos las emisiones para cada factor, asegurándonos de que cada uno tenga su valor de emisión correspondiente
                let isInserted = ModelManager.instance.addEmisionDese(
                    emisionUsuarioDese: usuarioEmision,
                    fechaCarga: fechaFormateada,
                    valorFactor: factor.valorFactor // Usamos el valor de cada factor
                )
                
                if isInserted {
                    let listaDeEmisiones = ModelManager.instance.RecuperarEmisionesSubidasDese(FechaSubida: fechaFormateada)
                    
                    // Variable para la suma total de todas las emisiones y factores
                    var sumaTotal = 0.0
                    
                    // Recorrer la lista de emisiones y calcular la suma de emisión y factor
                    for emisio in listaDeEmisiones {
                        // Sumar el valor de emisión (ValorTrans) y el valor de factor (ValorFactor)
                        let calculoindividual = emisio.valorUsuarioEmisionSubida * emisio.valorFactorSeleccionado
                        // Acumular esa suma a la suma total
                        sumaTotal += calculoindividual
                    }
                    
                    print("Número de emisiones recuperadas: \(listaDeEmisiones.count)")
                    for emisio in listaDeEmisiones {
                        print("Emisión: \(emisio.valorUsuarioEmisionSubida) - Factor: \(emisio.valorFactorSeleccionado)")
                    }
                    
                    print("Se agregó correctamente a la base de datos.")
                    _ = ModelManager.instance.updateHistorialtrasEmisionDese(SumaTotal: sumaTotal)
                } else {
                    print("Hubo un error al agregar los datos a la base.")
                }
            } else {
                print("No se pudo obtener el valor de emisión para el factor \(factor.nameFactor).")
            }
        }
        
        // Enviar notificación de que las emisiones han sido añadidas
        nc.post(name: Notification.Name("EmisionesDeseAdded"), object: nil)
        
        // Cerrar el view controller cuando terminamos
        dismiss(animated: true, completion: nil)
    }


}

extension FormsDeseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.factoresDesechosCV {
            return data.count
        } else {
            return selectedFactors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.factoresDesechosCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "factoresDesechos", for: indexPath) as! DesechosCollectionViewCell
            let factor = data[indexPath.row]
            cell.configure(with: factor) // Usar el nombre del factor
            
            // Configuramos el closure para manejar la selección de los factores
            cell.onFactorSelected = { [weak self] in
                guard let self = self else { return }
                
                // Alternamos la selección del factor
                factor.isSelected.toggle()
                
                if factor.isSelected {
                    self.selectedFactors.append(factor)
                } else {
                    if let index = self.selectedFactors.firstIndex(where: { $0.nameFactor == factor.nameFactor }) {
                        self.selectedFactors.remove(at: index)
                    }
                }
                
                // Recargamos los collection views para actualizar la UI
                self.formularioDesechosCV.reloadData()
                self.factoresDesechosCV.reloadItems(at: [indexPath])
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InputFormularioDesechos", for: indexPath) as! inputFormularioDesechosCollectionViewCell
            let factor = selectedFactors[indexPath.row]
            cell.labelTitulo.text = factor.nameFactor
            return cell
        }
    }
}

extension FormsDeseViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.factoresDesechosCV {
            let factor = data[indexPath.row]
            factor.isSelected.toggle() // Alternar el estado de selección

            if factor.isSelected {
                selectedFactors.append(factor)
            } else {
                if let index = selectedFactors.firstIndex(where: { $0.nameFactor == factor.nameFactor }) {
                    selectedFactors.remove(at: index) // Eliminar del arreglo si está deseleccionado
                }
            }

            // Actualizar la celda seleccionada
            if let cell = collectionView.cellForItem(at: indexPath) as? DesechosCollectionViewCell {
                cell.configure(with: factor) // Reconfigurar la celda
            }
            formularioDesechosCV.reloadData()
        } else {
            // Manejar la selección del segundo collection view
            print("Seleccionaste: \(data2[indexPath.row])")
        }
    }
}
