import UIKit

class AlimentosFormsViewController: UIViewController {

    var data: [Factores] = [] // Cambiar a un array de Factores
    var selectedFactors: [Factores] = [] // Arreglo para almacenar los ítems seleccionados
    
    @IBOutlet weak var factoresAlicv: UICollectionView!  // Primer UICollectionView
    @IBOutlet weak var formularioCV: UICollectionView!  // Segundo UICollectionView (similar a 'formularioCV' en el primer código)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedFactors.removeAll() // Limpiar selección al inicio

        // Asegurarte de que ambos collection views son visibles
        factoresAlicv.isHidden = false
        formularioCV.isHidden = false
        
        factoresAlicv.dataSource = self
        factoresAlicv.delegate = self
        
        formularioCV.dataSource = self
        formularioCV.delegate = self
        
        // Recargar datos de los collection views (en caso de que ya tengas datos previamente cargados)
        factoresAlicv.reloadData()
        formularioCV.reloadData()
    }

    @IBAction func reciclaBoton(_ sender: Any) {
        let factores = ModelManager.instance.findFactoresAli(tipoFact: 1)
        data = factores // Guardar objetos Factores directamente
        selectedFactors.removeAll() // Limpiar selecciones anteriores
        factoresAlicv.reloadData()
        formularioCV.reloadData() // Recargar el segundo collection view
        factoresAlicv.isHidden = false
    }

    @IBAction func organiBoton(_ sender: Any) {
        let factores = ModelManager.instance.findFactoresAli(tipoFact: 2)
        data = factores
        selectedFactors.removeAll() // Limpiar selecciones anteriores
        factoresAlicv.reloadData()
        formularioCV.reloadData()
        factoresAlicv.isHidden = false
    }

    @IBAction func inorganiBoton(_ sender: Any) {
        let factores = ModelManager.instance.findFactoresAli(tipoFact: 3)
        data = factores
        selectedFactors.removeAll() // Limpiar selecciones anteriores
        factoresAlicv.reloadData()
        formularioCV.reloadData()
        factoresAlicv.isHidden = false
    }

    @IBAction func borrarBotonAli(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let nc = NotificationCenter.default

    @IBAction func guardarSelec(_ sender: Any) {
        print("Ítems seleccionados: \(selectedFactors.map { $0.nameFactor })")
        
        // Crear un arreglo para almacenar los valores de los campos de texto
        var valoresCamposTexto: [String] = []
        
        // Recorremos las celdas de formularioCV (el segundo UICollectionView) para obtener los valores de los UITextFields
        for indexPath in formularioCV.indexPathsForVisibleItems {
            if let cell = formularioCV.cellForItem(at: indexPath) as? InputFormularioAlimentoCollectionViewCell {
                if let text = cell.inputFormulario.text, !text.isEmpty {
                    valoresCamposTexto.append(text)
                } else {
                    print("El campo de texto en la celda \(indexPath.row) está vacío.")
                }
            }
        }
        
        // Ahora, recorremos los factores seleccionados y sus valores de entrada
        for (index, factor) in selectedFactors.enumerated() {
            if index < valoresCamposTexto.count {
                let valorUsuario = valoresCamposTexto[index] // Usamos safe subscript para evitar index fuera de rango
                print("Valor ingresado para \(factor.nameFactor): \(valorUsuario)")
                factor.inputValue = valorUsuario
            } else {
                print("Advertencia: No hay valor ingresado para el factor \(factor.nameFactor).")
            }
        }

        // Verificamos que tenemos valores válidos para usuarioEmision
        var usuarioEmisiones: [Float] = []
        for indexPath in formularioCV.indexPathsForVisibleItems {
            if let cell = formularioCV.cellForItem(at: indexPath) as? InputFormularioAlimentoCollectionViewCell {
                if let text = cell.inputFormulario.text, let emision = Float(text) {
                    usuarioEmisiones.append(emision)
                }
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let fechaActual = Date()
        let fechaFormateada = dateFormatter.string(from: fechaActual)

        // Verificamos si tenemos al menos un valor válido de emisión
        if !usuarioEmisiones.isEmpty {
            // Recorremos todos los factores seleccionados y guardamos una emisión para cada uno
            for (index, factor) in selectedFactors.enumerated() {
                if index < usuarioEmisiones.count {
                    let valorUsuario = usuarioEmisiones[index] // Obtenemos el valor de emisión correspondiente para el factor
                    
                    let isInserted = ModelManager.instance.addEmisionAli(
                        emisionUsuarioAli: valorUsuario,
                        fechaCarga: fechaFormateada,
                        valorFactor: factor.valorFactor // Usamos el valor de cada factor
                    )
                    
                    if isInserted {
                        let listaDeEmisiones = ModelManager.instance.RecuperarEmisionesSubidasAli(FechaSubida: fechaFormateada)
                        
                        var sumaTotal = 0.0
                        for emisio in listaDeEmisiones {
                            let calculoindividual = emisio.valorUsuarioEmisionSubida * emisio.valorFactorSeleccionado
                            sumaTotal += calculoindividual
                        }
                        
                        print("Se agregó correctamente a la base de datos \(sumaTotal).")
                        _ = ModelManager.instance.updateHistorialtrasEmisionAli(SumaTotal: sumaTotal)
                    } else {
                        print("Hubo un error al agregar los datos a la base.")
                    }
                }
            }
        } else {
            print("No se pudo obtener el valor de emisión del usuario.")
        }
        
        // Enviar notificación de que las emisiones han sido añadidas
        nc.post(name: Notification.Name("EmisionesAliAdded"), object: nil)
        
        // Cerrar el popover
        dismiss(animated: true, completion: nil)
    }


}

extension AlimentosFormsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.factoresAlicv {
            return data.count
        } else {
            return selectedFactors.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.factoresAlicv {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "factoresAli", for: indexPath) as! AlimentosCollectionViewCell
            let factor = data[indexPath.row]
            cell.configure(with: factor)
            
            // Configuración para la acción de selección
            cell.onFactorSelected = { [weak self] in
                guard let self = self else { return }
                
                factor.isSelected.toggle()
                
                if factor.isSelected {
                    self.selectedFactors.append(factor)
                } else {
                    if let index = self.selectedFactors.firstIndex(where: { $0.nameFactor == factor.nameFactor }) {
                        self.selectedFactors.remove(at: index)
                    }
                }
                
                // Recargar los collection views para actualizar la UI
                self.formularioCV.reloadData()
                self.factoresAlicv.reloadItems(at: [indexPath])
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "inputFomrularioAli", for: indexPath) as! InputFormularioAlimentoCollectionViewCell
            let factor = selectedFactors[indexPath.row]
            cell.labelTitulo.text = factor.nameFactor
            return cell
        }
    }
}

extension AlimentosFormsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.factoresAlicv {
            let factor = data[indexPath.row]
            factor.isSelected.toggle()

            if factor.isSelected {
                selectedFactors.append(factor)
            } else {
                if let index = selectedFactors.firstIndex(where: { $0.nameFactor == factor.nameFactor }) {
                    selectedFactors.remove(at: index)
                }
            }
            
            // Actualizar la celda seleccionada
            if let cell = collectionView.cellForItem(at: indexPath) as? AlimentosCollectionViewCell {
                cell.configure(with: factor)
            }
            formularioCV.reloadData()
        } else {
            // Manejar la selección en el segundo collection view si es necesario
            print("Seleccionaste: \(selectedFactors[indexPath.row].nameFactor)")
        }
    }
}
