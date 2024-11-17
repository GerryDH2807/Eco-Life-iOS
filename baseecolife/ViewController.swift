import UIKit

class ViewController: UIViewController {
    
    // Imágenes outlets para cada día de la semana
    @IBOutlet weak var lunesImage: UIImageView!
    @IBOutlet weak var martesImage: UIImageView!
    @IBOutlet weak var miercolesImage: UIImageView!
    @IBOutlet weak var juevesImage: UIImageView!
    @IBOutlet weak var viernesImage: UIImageView!
    @IBOutlet weak var sabadoImage: UIImageView!
    @IBOutlet weak var domingoImage: UIImageView!
    
    var timer: Timer?
    var rachaIncrementada = false // Nueva variable para controlar la incrementación de la racha
    
    func startTimer() {
        // Programar el temporizador para que se ejecute cada 12 horas (43200 segundos)
        timer = Timer.scheduledTimer(timeInterval: 86400, target: self, selector: #selector(funcionesCada12Horas), userInfo: nil, repeats: true)
    }

    @objc func funcionesCada12Horas() {
        // Aquí colocas lo que quieres que se ejecute cada 12 horas
        self.generarRetoButton.isEnabled = true
        rachaIncrementada = false // Permitir que la racha pueda ser incrementada nuevamente

        var huboActualizacion = false

        // Crear un observador temporal para detectar si hubo actualizaciones
        let observer = NotificationCenter.default.addObserver(forName: Notification.Name("EmisionesTransAdded"), object: nil, queue: .main) { [weak self] _ in
            huboActualizacion = true
            self?.verificarYIncrementarRacha()
        }

        NotificationCenter.default.addObserver(forName: Notification.Name("EmisionesAliAdded"), object: nil, queue: .main) { [weak self] _ in
            huboActualizacion = true
            self?.verificarYIncrementarRacha()
        }

        NotificationCenter.default.addObserver(forName: Notification.Name("EmisionesDeseAdded"), object: nil, queue: .main) { [weak self] _ in
            huboActualizacion = true
            self?.verificarYIncrementarRacha()
        }

        // Verificar si hubo actualización después de un breve retraso
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            if !huboActualizacion {
                self?.resetearRacha()
                print("No hubo actualización, la racha se ha reseteado.")
            } else {
                print("Se detectó una actualización, la racha continúa.")
            }
            
            // Eliminar el observador después de la verificación
            NotificationCenter.default.removeObserver(observer)
        }

        print("La tarea se ejecutó a las \(Date())")
    }
    
    func startTimerParaInsert() {
        // Programar el temporizador para que se ejecute cada 12 horas (43200 segundos)
        timer = Timer.scheduledTimer(timeInterval: 43200, target: self, selector: #selector(nuevoInsertBase), userInfo: nil, repeats: true)
    }

    @objc func nuevoInsertBase() {
        _ = ModelManager.instance.historialCada12()
    }

    // Arreglos para almacenar los títulos y descripciones
    let titulos = ["Título 1", "Título 2", "Título 3", "Título 4", "Título 5"]
    let descripciones = [
        "Descripción del reto 1.",
        "Descripción del reto 2.",
        "Descripción del reto 3.",
        "Descripción del reto 4.",
        "Descripción del reto 5."
    ]
    
    let diccionariotest: [String: Int] = [
        "No hay reto prueba": 0,
        "Reto de prueba 1": 1,
        "Reto de prueba 2": 2,
        "Reto de prueba 3": 3,
        "Reto de prueba 4": 4,
        "Reto de prueba 5": 5,
        "Reto de prueba 6": 6,
        "Reto de prueba 7": 7,
        "Reto de prueba 8": 8,
        "Reto de prueba 9": 9,
        "Reto de prueba 10": 10
    ]
    
    // Índice actual del carrusel
    var indiceActual = 0
    var indiceReto = 0
    
    @IBOutlet weak var ciclosDeRacha: UILabel!
    // Outlets para los elementos de la interfaz
    @IBOutlet weak var TituloReco: UILabel!
    @IBOutlet weak var RecoInfo: UITextView!
    @IBOutlet weak var retoActivo: UILabel!
    
    // Variables para el control de la racha
    var rachaActiva = true  // Estado de la racha (si está activa o rota)
    var contadorRacha = 0  // Contador de la racha actual
    var imagenesDeRacha = [UIImage(named: "path133-7-6.png"),
                           UIImage(named: "path133-7-7.png"),
                           UIImage(named: "path133-7-8.png")]  // Los estados de las imágenes

    @IBOutlet weak var generarRetoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        startTimerParaInsert()
        
        let docName = "DatabaseEco"
        let docExt = "sqlite3"
        copyFilesToDocumentsFolder(nameForFile: docName, extForFile: docExt)
        actualizarVista()
        
        let insertSuccess = ModelManager.instance.historialCada12()
        if insertSuccess {
            print("Insert inicial realizado con éxito.")
        } else {
            print("Falló el insert inicial.")
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("EmisionesTransAdded"), object: nil, queue: .main) { [weak self] _ in
            self?.verificarYIncrementarRacha()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("EmisionesAliAdded"), object: nil, queue: .main) { [weak self] _ in
            self?.verificarYIncrementarRacha()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("EmisionesDeseAdded"), object: nil, queue: .main) { [weak self] _ in
            self?.verificarYIncrementarRacha()
        }
    }

    func copyFilesToDocumentsFolder(nameForFile: String, extForFile: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destURL = documentsURL!.appendingPathComponent(nameForFile).appendingPathExtension(extForFile)

        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destURL.path) {
            do {
                try fileManager.removeItem(at: destURL)
                print("Archivo existente eliminado")
            } catch {
                print("Error al eliminar el archivo existente: \(error)")
            }
        }

        guard let sourceURL = Bundle.main.url(forResource: nameForFile, withExtension: extForFile) else {
            print("Source file not found")
            return
        }

        do {
            try fileManager.copyItem(at: sourceURL, to: destURL)
            print("Archivo copiado exitosamente")
        } catch {
            print("Unable to copy file: \(error)")
        }
    }


    // Función para verificar si se puede incrementar la racha
    func verificarYIncrementarRacha() {
        if !generarRetoButton.isEnabled && rachaActiva && !rachaIncrementada {
            incrementarRacha()
            rachaIncrementada = true // Marcar que la racha ya fue incrementada
        }
    }

    // Función que actualiza la racha de manera independiente
    func incrementarRacha() {
        contadorRacha += 1
        actualizarImágenesRacha()
        verificarRachaCompletada()
    }

    // Función que resetea la racha de manera independiente
    func resetearRacha() {
        contadorRacha = 0
        rachaActiva = false
        actualizarImágenesRacha()
        print("La racha se ha roto")
    }

    // Función para actualizar las imágenes de la racha de manera independiente
    func actualizarImágenesRacha() {
        let imagenActual = rachaActiva ? imagenesDeRacha[0] : imagenesDeRacha[2]
        
        switch contadorRacha {
        case 1:
            lunesImage.image = imagenActual
        case 2:
            martesImage.image = imagenActual
        case 3:
            miercolesImage.image = imagenActual
        case 4:
            juevesImage.image = imagenActual
        case 5:
            viernesImage.image = imagenActual
        case 6:
            sabadoImage.image = imagenActual
        case 7:
            domingoImage.image = imagenActual
        default:
            break
        }
    }
    
    var ciclosDeRachaCount = 0

    // Función para verificar si la racha ha sido completada
    func verificarRachaCompletada() {
        if contadorRacha >= 7 {
            ciclosDeRachaCount += 1
            
            // Actualiza el UILabel con el nuevo contador
            ciclosDeRacha.text = String(ciclosDeRachaCount)
            resetearRacha()
        }
    }

    @IBAction func BotonIzquCar(_ sender: Any) {
        indiceActual = (indiceActual - 1 + titulos.count) % titulos.count
        actualizarVista()
    }

    @IBAction func BotonDerCar(_ sender: Any) {
        indiceActual = (indiceActual + 1) % titulos.count
        actualizarVista()
    }

    @IBAction func generarReto(_ sender: Any) {
        generarRetoButton.isEnabled = false
        indiceReto = Int.random(in: 1...10)
        actualizarVista()
        
        startTimer()
    }


    func actualizarVista() {
        TituloReco.text = titulos[indiceActual]
        RecoInfo.text = descripciones[indiceActual]

        if let retoTexto = diccionariotest.first(where: { $0.value == indiceReto })?.key {
            retoActivo.text = retoTexto
        } else {
            retoActivo.text = "Reto no encontrado"
        }
    }
}
