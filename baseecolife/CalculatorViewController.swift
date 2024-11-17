import UIKit
import DGCharts
import Charts

class CalculatorViewController: UIViewController {

    @IBOutlet weak var emisionTotalUsuario: UILabel!
    @IBOutlet weak var emisionTransporte: UILabel!
    @IBOutlet weak var emisionAlimentos: UILabel!
    @IBOutlet weak var emisionDesechos: UILabel!
    @IBOutlet weak var emisionEnergia: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    
    var emisionTotal: Historial?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("EmisionesTransAdded"), object: nil, queue: .main) { [weak self] _ in
            self?.update()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("EmisionesAliAdded"), object: nil, queue: .main) { [weak self] _ in
            self?.update()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("EmisionesDeseAdded"), object: nil, queue: .main) { [weak self] _ in
            self?.update()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("EmisionesEnerAdded"), object: nil, queue: .main) { [weak self] _ in
            self?.update()
        }
        
        update()
        updateChartData()
    }
    
    @objc func update() {
        print("Entré al update")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let fechaFormateada = dateFormatter.string(from: Date())
        
        // Get today's emissions data from ModelManager
        emisionTotal = ModelManager.instance.obtenerHistorial(fechaBusqueda: fechaFormateada)
        
        guard let emisionTotal = emisionTotal, emisionTotal.id_hist != 0 else {
            emisionTotalUsuario.text = "No se encontraron emisiones para esta fecha."
            return
        }
        
        let totalEmisiones = emisionTotal.valali + emisionTotal.valtransp + emisionTotal.valener + emisionTotal.valdesecho
        emisionTotalUsuario.text = String(format: "%.2f kg de carbono", totalEmisiones)
        emisionTransporte.text = String(format: "%.2f kg de CO2", emisionTotal.valtransp)
        emisionEnergia.text = String(format: "%.2f kg de CO2", emisionTotal.valener)
        emisionAlimentos.text = String(format: "%.2f kg de CO2", emisionTotal.valali)
        emisionDesechos.text = String(format: "%.2f kg de CO2", emisionTotal.valdesecho)
        
        updateChartData()
    }

    func updateChartData() {
        guard let emisionTotal = emisionTotal else { return }
        
        let emissionsData = [
            emisionTotal.valtransp,
            emisionTotal.valener,
            emisionTotal.valali,
            emisionTotal.valdesecho
        ]
        
        let entries = emissionsData.enumerated().map { index, value in
            BarChartDataEntry(x: Double(index), y: Double(value))
        }

        let dataSet = BarChartDataSet(entries: entries, label: "Emisiones de CO₂ del Día (kg)")
        dataSet.colors = ChartColorTemplates.colorful()

        let data = BarChartData(dataSet: dataSet)
        barChartView?.data = data
        barChartView?.notifyDataSetChanged()
    }

    deinit {
        print("CalculatorViewController is being deinitialized")
        NotificationCenter.default.removeObserver(self, name: Notification.Name("EmisionesTransAdded"), object: nil)
    }
}
