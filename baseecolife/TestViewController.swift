import UIKit
import Foundation

protocol TestViewControllerDelegate: AnyObject {
    func didSaveDataAndClose()
}

class TestViewController: UIViewController {
    
    var data: [Factores] = [] // Cambiar a un array de Factores
    var selectedFactors: [Factores] = []
    
    var data2 = ["Hola"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var formularioCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedFactors.removeAll()
        
        // Asegúrate de que ambos collection views son visibles
        collectionView.isHidden = false
        formularioCV.isHidden = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        formularioCV.dataSource = self
        formularioCV.delegate = self
        
        // Carga inicial de datos (opcional)
        collectionView.reloadData()
        formularioCV.reloadData() // Asegúrate de que se recargue el segundo
    }
    
    @IBAction func terrestreBoton(_ sender: UIButton) {
        let factores = ModelManager.instance.findFactoresTransp(tipoFact: 1)
        data = factores
        selectedFactors.removeAll()
        collectionView.reloadData()
        formularioCV.reloadData()
        collectionView.isHidden = false
    }
    
    @IBAction func acuaticoBoton(_ sender: UIButton) {
        let factores = ModelManager.instance.findFactoresTransp(tipoFact: 2)
        data = factores
        selectedFactors.removeAll()
        collectionView.reloadData()
        formularioCV.reloadData()
        collectionView.isHidden = false
    }
    
    @IBAction func aereoBoton(_ sender: UIButton) {
        let factores = ModelManager.instance.findFactoresTransp(tipoFact: 3)
        data = factores
        selectedFactors.removeAll()
        collectionView.reloadData()
        formularioCV.reloadData()
        collectionView.isHidden = false
    }
    
    @IBAction func otrosBoton(_ sender: UIButton) {
        let factores = ModelManager.instance.findFactoresTransp(tipoFact: 4)
        data = factores
        selectedFactors.removeAll()
        collectionView.reloadData()
        formularioCV.reloadData()
        collectionView.isHidden = false
    }
    
    @IBAction func agregarBoton(_ sender: Any) {
        let alertController = UIAlertController(title: "Nuevo Factor de Transporte", message: "Ingresa el nombre del nuevo factor", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Nombre"
        }
        
        let saveAction = UIAlertAction(title: "Guardar", style: .default) { _ in
            guard let nombre = alertController.textFields?.first?.text, !nombre.isEmpty else {
                print("Error: El nombre no puede estar vacío")
                return
            }
            

            let isInserted = ModelManager.instance.addFactorTransporte(nombre: nombre)
            
            if isInserted {
                print("Nuevo factor de transporte agregado correctamente")
                self.data = ModelManager.instance.findFactoresTransp(tipoFact: 4)
                self.collectionView.reloadData()
            } else {
                print("Error al insertar el nuevo factor de transporte")
            }
        }
        
        // Acción para cancelar
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        // Mostrar la alerta
        present(alertController, animated: true, completion: nil)    }
    
    
    @IBAction func cerrarBoton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    weak var delegate: TestViewControllerDelegate?
    
    let nc = NotificationCenter.default
    
    @IBAction func guardarSelec(_ sender: Any) {
        print("Ítems seleccionados: \(selectedFactors.map { $0.nameFactor })")
        
        // Crear un arreglo para almacenar los valores de los campos de texto
        var valoresCamposTexto: [String] = []
        
        // Recorremos las celdas de formularioCV (el segundo UICollectionView) para obtener los valores de los UITextFields
        for indexPath in formularioCV.indexPathsForVisibleItems {
            if let cell = formularioCV.cellForItem(at: indexPath) as? InputFormularioCollectionViewCell {
                // Aquí obtenemos el valor del UITextField dentro de la celda
                if let text = cell.fieldFormulario.text, !text.isEmpty {
                    valoresCamposTexto.append(text)
                } else {
                    // Si el campo está vacío, podemos manejarlo de alguna manera
                    print("El campo de texto en la celda \(indexPath.row) está vacío.")
                }
            }
        }
        
        print("Valores ingresados por el usuario: \(valoresCamposTexto)")
        
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
        
        // Ahora, se obtiene el valor de 'usuarioEmision' del campo 'fieldFormulario' correspondiente
        var usuarioEmision: Float?
        for indexPath in formularioCV.indexPathsForVisibleItems {
            if let cell = formularioCV.cellForItem(at: indexPath) as? InputFormularioCollectionViewCell {
                // Aquí obtenemos el valor del 'fieldFormulario' que representa al 'fieldUsuairos'
                if let text = cell.fieldFormulario.text, let emision = Float(text) {
                    usuarioEmision = emision
                    break  // Si encontramos el campo, lo asignamos y salimos del bucle
                }
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let fechaActual = Date()
        let fechaFormateada = dateFormatter.string(from: fechaActual)
        
        // Verificamos que tenemos un valor válido para usuarioEmision
        if let usuarioEmision = usuarioEmision {
            // Recorremos todos los factores seleccionados y asociamos un valor de emisión para cada uno
            for (index, factor) in selectedFactors.enumerated() {
                if index < valoresCamposTexto.count {
                    let valorFactor = factor.valorFactor // Obtenemos el valor del factor correspondiente
                    let valorUsuario = Float(valoresCamposTexto[index]) ?? 0.0 // Obtenemos el valor de emisión para el factor
                    
                    // Guardamos la emisión para cada factor con su valor específico
                    let isInserted = ModelManager.instance.addEmisionTransp(
                        emisionUsuarioTransp: valorUsuario,
                        fechaCarga: fechaFormateada, // O puedes usar DateFormatter para poner la fecha actual
                        valorFactor: valorFactor // Se pasa el valor de cada factor al método
                    )
                    
                    if isInserted {
                        let listaDeEmisiones = ModelManager.instance.RecuperarEmisionesSubidas(FechaSubida: fechaFormateada)
                        
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
                        _ = ModelManager.instance.updateHistorialtrasEmision(SumaTotal: sumaTotal)
                    }
                }
            }
        } else {
            print("No se pudo obtener el valor de emisión del usuario o no se seleccionó un factor.")
        }
        
        // Notificar que las emisiones se han añadido
        nc.post(name: Notification.Name("EmisionesTransAdded"), object: nil)
        
        // Cerrar el popover
        dismiss(animated: true, completion: nil)
    }


}


extension TestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return data.count
        } else {
            return selectedFactors.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "factoresCell", for: indexPath) as! FactoresCollectionViewCell
            let factor = data[indexPath.row]
            cell.configure(with: factor)
            
            // Set the closure to handle the button tap using the correct closure name
            cell.onFactorSelected = { [weak self] in
                guard let self = self else { return }
                
                // Toggle selection for the factor
                factor.isSelected.toggle()
                
                if factor.isSelected {
                    self.selectedFactors.append(factor)
                } else {
                    if let index = self.selectedFactors.firstIndex(where: { $0.nameFactor == factor.nameFactor }) {
                        self.selectedFactors.remove(at: index)
                    }
                }
                
                // Reload the collection views to update the UI
                self.formularioCV.reloadData()
                self.collectionView.reloadItems(at: [indexPath])
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "inputFormulario", for: indexPath) as! InputFormularioCollectionViewCell
            let factor = selectedFactors[indexPath.row]
            cell.labelTitulo.text = factor.nameFactor
            return cell
        }
    }
}


// Añadir UICollectionViewDelegate
extension TestViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if collectionView == self.collectionView {
            let factor = data[indexPath.row]
            factor.isSelected.toggle() // Alternar el estado de selección

            if factor.isSelected {
                selectedFactors.append(factor)
                print(indexPath.row)
            } else {
                print(indexPath.row)
                if let index = selectedFactors.firstIndex(where: { $0.nameFactor == factor.nameFactor }) {
                    selectedFactors.remove(at: index) // Eliminar del arreglo si está deseleccionado
                }
            }

            // Actualizar la celda seleccionada
            if let cell = collectionView.cellForItem(at: indexPath) as? FactoresCollectionViewCell {
                cell.configure(with: factor) // Reconfigurar la celda
            }
            formularioCV.reloadData()
        } 
    }
}
