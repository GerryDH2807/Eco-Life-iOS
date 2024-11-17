import UIKit

class ScrollingViewController: UIViewController {
    
    //vidas del jugador
    var vidas = 3
    var livesLabel: UILabel!
    
    //energia del jugador
    var playerEnergy: CGFloat = 100.0
    
    var energyTimer: Timer?
    
    //estado del juego
    var isGameRunning = false
    
    
    //VARS inventario (No se usara para este proyecto)
    var inventario: [TiendaObjeto] = []
    var objetoSeleccionado: TiendaObjeto?
    
    //scrollView para colocar los objetos
    //var scrollView: UIScrollView!
    var cursorImageView: UIImageView?
    
    
    var scrollView: UIScrollView! //var scrollview
    
    //var scrollView: UIView!
    var movingRectangle: UIImageView! //Variable del jugador
    
    var casillasLimiteX: Int = 12 // a partir de 13 ya hay scroll //limite de casillas en x para que no sea iniftnito
    // limite de desplazamiento en X por caslla
    var scrollLimitX: CGFloat {
        return CGFloat(casillasLimiteX) * floorImages.first!.size.width
    }
    
    //var scrollLimitX: CGFloat = 2000//Limite del movimiento en X //Si se busca un juego muy grande
    var scrollLimitY: CGFloat = 20000 //Limite del movimiento en Y
    var movementSpeed: CGFloat = 15.0
    var movementTimer: Timer? //Temporizador para mover eal jugador
    var direction: CGPoint = .zero //Direccion del movimiento
    var spriteIndex: Int = 0 //indice actual del sprite
    var currentDirectionSprites: [UIImage] = [] //Imagenes del sprite para la direccion actual
    //var staticImages: [UIImageView] = [] //Array de almacenamiento imagenes estaticas
    var borderImages: [UIImageView] = [] //Array de almacenamiento bordes
    var coinLabel: UILabel! //Etiqueta para mostrar las monedas recogidas (basuras)
    
    //Array de imagenes del sprite para cada direccion
    let upSprites: [UIImage] = [
        UIImage(named: "sprite_up_1")!,
        UIImage(named: "sprite_up_2")!
    ]
    
    let downSprites: [UIImage] = [
        UIImage(named: "sprite_down_1")!,
        UIImage(named: "sprite_down_2")!
    ]
    
    let leftSprites: [UIImage] = [
        UIImage(named: "sprite_left_1")!,
        UIImage(named: "sprite_left_2")!
    ]
    
    let rightSprites: [UIImage] = [
        UIImage(named: "sprite_right_1")!,
        UIImage(named: "sprite_right_2")!
    ]
    
    //sprites zona deposito (basuras)
    let depositZoneSprites: [UIImage] = [
        UIImage(named: "can1")!
    ]
    
    var depositZoneSpriteSpeed: TimeInterval = 0.5 //Velocidad de cambio de sprite para la zona donde se depositan las mondedas/basura
    var depositZoneSpriteIndex: Int = 0 //indice actual del sprite para la zona de deposito
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Mostrar el menú principal al iniciar
        showMainMenu()
    }
    
    
    
    func setupGame(){
        //primera vista
        
        
        
        self.view.backgroundColor = .green
        
        //vista de desplazamiento
        
        
        setupScrollView()
        
        //movimineto del jugador
        setupMovingRectangle()
        
        
        generateRoadSections()
        setupCars()

        
        setupGameUI()
        //startEnergyTimer()
        
        //setupDebugButton()
        
        //stopAllTimers()
        stopLeafFallAnimation() // Asegúrate de limpiar las hojas previas
        startLeafFallAnimation() // Reinicia la animación de hojas
        
        //startCarMovement()
        
        //conf etiqueta de monedas recogidas (Monedas: )
        setupCoinLabel()
        setupCoinLabel2()
        
        //imagenes estaticas (las monedas)
        setupColectibles()
        
        
        //Agregar los edificios
        //setupBuildings()
        
        //Configuracion de los botones de control
        setupControlButtons()
        
        //Configuracion del boton para regenerar monedas (Dev testing)
        setupRegenerateCoinsButton()
        
        //Sistema de deposito
        setupCollectedCoinsLabel()
        setupDepositedCoinsLabel()
        setupDepositZones(numberOfZones: 20)
        
        //Añadir imagenes en los bordes de la zona cafe
        setupArboles(numberOfTrees:30)
        setupPanels(numberOfPanels: 20)
        
        //iIniciar animacion del sprite de la zona de deposito
        //startDepositZoneAnimation()
        
        //Iniciar particulas
        //startLeafFallAnimation()
        
        //Lagos
        //setupLakes() //Añadir
        //sstartLakeAnimation() //Animacion
        
        //Pasto poner
        //placeGrass()
        
        setupAnimals()
        //setupFollower()
        
        //Objetos
        //agregarObjetos()
        
        //Tienda
        //setupCoinLabel()
        //setupStoreButton()
        
        //Inventory
        setupInventoryButton()
        
        //PRUEBA VIEWDIDLOAD PRUEBA VIEWDIDLOAD  PRUEBA VIEWDIDLOAD PRUEBA VIEWDIDLOAD PRUEBA VIEWDIDLOAD
        //PRUEBA VIEWDIDLOAD PRUEBA VIEWDIDLOAD  PRUEBA VIEWDIDLOAD PRUEBA VIEWDIDLOAD PRUEBA VIEWDIDLOAD
        setupCubes() // Configurar los cubos inicialmente
        Timer.scheduledTimer(timeInterval: 0.016, target: self, selector: #selector(updateCubes), userInfo: nil, repeats: true) // Actualizar cubos

        
        //PRUEBA VIEWDIDLOAD PRUEBA VIEWDIDLOAD  PRUEBA VIEWDIDLOAD PRUEBA VIEWDIDLOAD PRUEBA VIEWDIDLOAD
        //PRUEBA VIEWDIDLOAD PRUEBA VIEWDIDLOAD  PRUEBA VIEWDIDLOAD PRUEBA VIEWDIDLOAD PRUEBA VIEWDIDLOAD
        
        
        //Añadir un gesto para colocar objetos en el mapa
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colocarObjeto(_:)))
        scrollView.addGestureRecognizer(tapGesture)
        //abrirInventario()
    }
    
    
 
   
    
    
    
    //PISO
    //PISO
    //Configuracion del piso jugable
    // Array de imágenes de pisos
    // Array de imágenes de pisos
    // Array de imágenes de pisos
    // Array de imágenes de pisos
    // Array de imágenes de pisos
    // Imágenes de piso y carretera
    
    
    //Booleano que nos sirve si queremos ejercutar acciones en donde el jugador este en
    //el piso en vez de las carreteras
    func isPlayerOnGrass() -> Bool {
        for subview in containerView.subviews {
            if let imageView = subview as? UIImageView,
               imageView.frame.contains(movingRectangle.frame.origin),
               imageView.image?.accessibilityIdentifier == "grass" {
                return true
            }
        }
        return false
    }

    
    //Imagenes de el piso, un array de varios para una vista mas detallada en los pisos al momento de jugar
    let floorImages: [UIImage] = [
        {
            let image = UIImage(named: "floor1")!
            image.accessibilityIdentifier = "grass"
            return image
        }(),
        {
            let image = UIImage(named: "floor2")!
            image.accessibilityIdentifier = "grass"
            return image
        }(),
        {
            let image = UIImage(named: "floor3")!
            image.accessibilityIdentifier = "grass"
            return image
        }(),
        {
            let image = UIImage(named: "floor4")!
            image.accessibilityIdentifier = "grass"
            return image
        }(),
        {
            let image = UIImage(named: "floor5")!
            image.accessibilityIdentifier = "grass"
            return image
        }(),
        {
            let image = UIImage(named: "floor6")!
            image.accessibilityIdentifier = "grass"
            return image
        }()
    ]

    //carreteras
    let roadImage = UIImage(named: "carretera")!
    //var roadSections: [CGRect] = []
    
    //Añadir los tiles/casillas iniciaeles
    func addInitialTiles() {
        let tileHeight = floorImages.first!.size.height
        let horizontalTiles = Int(scrollLimitX / tileHeight)
        var currentY: CGFloat = 0
        
        while currentY < scrollView.contentSize.height {
            // De 3 a 5 en Y que sean pisos, hay que tener mas carreeteras que pisos para
            //que el juego sea mas interesante
            let floorCount = Int.random(in: 3...5)
            for _ in 0..<floorCount {
                if currentY >= scrollView.contentSize.height { break }
                for i in 0..<horizontalTiles {
                    let randomFloorImage = floorImages.randomElement()!
                    let tileView = UIImageView(image: randomFloorImage)
                    tileView.contentMode = .scaleAspectFill
                    tileView.frame = CGRect(x: CGFloat(i) * tileHeight, y: currentY, width: tileHeight, height: tileHeight)
                    containerView.addSubview(tileView)
                }
                currentY += tileHeight
            }
            
            // Generar secciones de carretera
            let roadCount = Int.random(in: 4...7)
            columnsWithCars.removeAll()
            
            for _ in 0..<roadCount {
                if currentY >= scrollView.contentSize.height { break }
                for i in 0..<horizontalTiles {
                    let roadView = UIImageView(image: roadImage)
                    roadView.contentMode = .scaleAspectFill
                    roadView.frame = CGRect(x: CGFloat(i) * tileHeight, y: currentY, width: tileHeight, height: tileHeight)
                    roadContainerView.addSubview(roadView)
                    
                    if !columnsWithCars.contains(i) && Bool.random() {
                        let carPosition = CGPoint(x: CGFloat(i) * tileHeight, y: currentY + (tileHeight / 2) - (carSize.height / 2))
                        addCar(at: carPosition, column: i)
                        columnsWithCars.insert(i)
                    }
                }
                currentY += tileHeight
            }
        }
    }
    
    
    //COntinuar añadiendo elementos, ideal si se busca un juego infinito
    // Función para añadir tiles, carreteras, monedas, árboles, etc.
    func addTiles(startingAt yPosition: CGFloat, direction: ScrollDirection) {
        let tileWidth = floorImages.first!.size.width
        let tileHeight = floorImages.first!.size.height
        let horizontalTiles = Int(ceil(scrollLimitX / tileWidth))
        var currentY = yPosition
        
        while currentY < yPosition + scrollLimitY {
            let floorCount = Int.random(in: 3...5)
            for _ in 0..<floorCount {
                if currentY >= scrollView.contentSize.height { break }
                for i in 0..<horizontalTiles {
                    let randomFloorImage = floorImages.randomElement()!
                    let tileView = UIImageView(image: randomFloorImage)
                    tileView.contentMode = .scaleAspectFill
                    tileView.frame = CGRect(x: CGFloat(i) * tileWidth, y: currentY, width: tileWidth, height: tileHeight)
                    containerView.addSubview(tileView)
                }
                currentY += tileHeight
            }
            
            //carreteras
            let roadCount = Int.random(in: 4...7)
            for _ in 0..<roadCount {
                if currentY >= scrollView.contentSize.height { break }
                for i in 0..<horizontalTiles {
                    let roadView = UIImageView(image: roadImage)
                    roadView.contentMode = .scaleAspectFill
                    roadView.frame = CGRect(x: CGFloat(i) * tileWidth, y: currentY, width: tileWidth, height: tileHeight)
                    roadContainerView.addSubview(roadView)
                    roadSections.append(roadView.frame)
                }
                currentY += tileHeight
            }
            
            // Generar elementos adicionales (monedas y árboles)
            addElementsInSection(yPosition: currentY, horizontalTiles: horizontalTiles, tileWidth: tileWidth)
        }
    }
    
    //Añadir elementos de arbol, (se uso otra funcion que funcionaba mejor)
    func addElementsInSection(yPosition: CGFloat, horizontalTiles: Int, tileWidth: CGFloat) {

        for _ in 0..<horizontalTiles {
            if Bool.random() { //arboles aleatorios
                let randomX = CGFloat.random(in: 0...(scrollLimitX - tileWidth))
                let randomY = CGFloat.random(in: 0...(scrollLimitY - 80)) // Usa todo el mapa
             

                //arbol imaes
                let treeView = UIImageView(image: UIImage(named: ["arbol1", "arbol2", "arbol3"].randomElement()!))
                treeView.frame = CGRect(x: randomX, y: randomY, width: 40, height: 80)

                // Agregar al contenedor principal
                containerView.addSubview(treeView)
                borderImages.append(treeView)
            }
        }

    }



    //Set UP del jugador, especialmente en donde comenzara
    func setupMovingRectangle() {
        movingRectangle = UIImageView(frame: CGRect(x: 50, y: 11000 , width: 50, height: 50))
        movingRectangle.image = upSprites[0] //Imagen inicial
        scrollView.addSubview(movingRectangle)
    }
    
    //Inicia el movimiento
    func startMovement() {
        spriteIndex = 0 // Reiniciar el índice del sprite
        movementTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(movePlayer), userInfo: nil, repeats: true)
    }
    
    //Scroll mapa
    enum ScrollDirection {
        case up
        case down
    }
    


    //TODO el movimiento del jugador y funciones que se llaman cuanto este se mueva
    //como para detectar colisiones al comparar posiciones con elementos del juego
    @objc func movePlayer() {
        let newX = movingRectangle.frame.origin.x + direction.x
        let newY = movingRectangle.frame.origin.y + direction.y

        // Calcular nuevo marco del jugador
        let newFrame = CGRect(x: newX, y: newY, width: movingRectangle.frame.width, height: movingRectangle.frame.height)

        // Verificar colisión con árboles
        if isCollidingWithTrees(playerFrame: newFrame) {
            return
        }
        
        checkCollisionWithPanels()

        //se reduce energia si el jugador se mueve (Se supone que es un robot limpiador)
        if direction.x != 0 || direction.y != 0 {
            reduceEnergy() // reduce
        }

        //Movimiento en X dentro de los limites (No pueda seguir de mas)
        if newX >= 0 && newX <= scrollLimitX - movingRectangle.frame.width {
            movingRectangle.frame.origin.x = newX
        }

        //Movimiento en Y dentro en limites
        movingRectangle.frame.origin.y = newY

        //Centrar la camara en el personaje (no queremos que suba mucho y se pierda el jugador)
        let offsetX = max(0, min(newX - scrollView.bounds.width / 2 + movingRectangle.frame.width / 2, scrollView.contentSize.width - scrollView.bounds.width))
        let offsetY = max(0, min(newY - scrollView.bounds.height / 2 + movingRectangle.frame.height / 2, scrollView.contentSize.height - scrollView.bounds.height))

        scrollView.setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: false)

        // Expandir contenido en la dirección del personaje
        expandContentIfNeeded(forYPosition: newY)

        // Actualizar el sprite del personaje
        movingRectangle.image = currentDirectionSprites[spriteIndex]
        spriteIndex = (spriteIndex + 1) % currentDirectionSprites.count

        // Detectar colisiones
        checkForCoinCollisions()
        checkForCarCollisions()
        checkCollisionWithDepositZone()
    }


    
    //COLISIONES COLISIONES COLISIONES COLISIONES
    //COLISIONES COLISIONES COLISIONES COLISIONES
    
    //Recoger monedas
    func checkForCoinCollisions() {
        for (index, coin) in staticImages.enumerated().reversed() {
            if movingRectangle.frame.intersects(coin.frame) {
                if collectedCoins < collectedCoinsCapacity {
                    coin.removeFromSuperview()
                    staticImages.remove(at: index)
                    collectedCoins += 1
                    collectedCoinsBar.progress = Float(collectedCoins) / Float(collectedCoinsCapacity) // Actualiza la barra
                    
                    collectedCoinsLabel.text = "Basura recogidas: \(collectedCoins)"
                    depositedCoinsLabel.text = "Basura depositada: \(depositedCoins)"
                } else {
                    print("Se ha llenado la bolsa, deposite para continuar recolectando")
                }
            }
        }
    }
    
    //Funcion base (estandar) de las colisiones que se usara para el juego)
    func checkCollisionWithDepositZone() {
        for (index, depositZone) in depositZones.enumerated() {
            if movingRectangle.frame.intersects(depositZone.frame) && collectedCoins > 0 {
                depositedCoins += collectedCoins
                collectedCoins = 0 // Reinicia las monedas recogidas
                collectedCoinsBar.progress = Float(collectedCoins) / Float(collectedCoinsCapacity) // Reinicia la barra
                
                collectedCoinsLabel.text = "Basura recogidas: \(collectedCoins)"
                depositedCoinsLabel.text = "Basura depositada: \(depositedCoins)"
                
                print("Monedas depositadas en zona de deposito \(index)")
                break
            }
        }
    }
    
    
    //Nunca funciono, pero tras horas y horas y horas de debug se mostro que los elementos graficos
    //en moviento eran distintos a las posiciones que marcaban, aun asi se veian bonitos avanzando
    //como en una carretera real
    
    
    // Variable global para contar las veces que el jugador pasa por un vehículo
    var vehiclePassCount = 0
    
    func checkForCarCollisions() {
        for (index, car) in cars.enumerated() {
            let startX = car.frame.origin.x
            let endX = car.frame.origin.x - 50 // Ajusta según el paso del movimiento
            let steps = 10 // Divide el movimiento en 10 pasos

            for step in 0..<steps {
                let interpolatedX = startX + CGFloat(step) * (endX - startX) / CGFloat(steps)
                let interpolatedFrame = CGRect(x: interpolatedX, y: car.frame.origin.y, width: car.frame.width, height: car.frame.height)

                if movingRectangle.frame.intersects(interpolatedFrame) {
                    print("Colisión detectada con coche \(index) en paso \(step)")
                    vehiclePassCount += 1
                    return
                }
            }
        }
    }
    
    
    //Funcion para poder ver las hitboxes de los elementos del juego
    func highlightFrame(view: UIView, color: UIColor) {
        let border = CALayer()
        border.borderColor = color.cgColor
        border.borderWidth = 2
        border.frame = view.bounds
        view.layer.addSublayer(border)
    }

    
    //END OF ZONA
    
    
    // Configuración del scrollView y creación del escenario
    // Configuración del scrollView y creación del escenario
    func setupScrollView() {
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.contentSize = CGSize(width: scrollLimitX, height: scrollLimitY * 3) // Tamaño inicial del contenido en Y el cual se expandira de forma dinamica
        
        
        scrollView.isScrollEnabled = false // Deshabilita el desplazamiento manual (Activar para hacer test)
        //ideal para avanzar rapido en el mapa y ver como se genera sin tener que depender de la
        //lenta velocidad del jugador
        
        scrollView.isUserInteractionEnabled = false // Deshabilita interaccion tactil
        //para evitar trampas
        
        
        // Inicializa el contenedor principal y sus subviews
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: scrollLimitX, height: scrollView.contentSize.height))
        
        // Inicializa roadContainerView y carContainerView
        roadContainerView = UIView(frame: containerView.bounds)
        carContainerView = UIView(frame: containerView.bounds)
        
        containerView.addSubview(roadContainerView)
        containerView.addSubview(carContainerView)
        
        addInitialTiles() // Agrega el piso y las carreteras iniciales
        scrollView.addSubview(containerView)
        self.view.addSubview(scrollView)
    }
    
    
    //Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba
    //Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba
    //Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba
    //Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba
    //SI FUNCIONO!
    var cubes: [UIView] = [] //Array para almacenar los coches
    let cubeSize: CGFloat = 30 //Tamaño de los coches
    let cubeSpeed: CGFloat = 36.0 //Velocidad de los coches
    let numberOfCubes = 4 //coches por carretera, se podria implementar un factor random


    func setupCubes() {
        cubes.forEach { $0.removeFromSuperview() } //Limpiar coches anteriores
        cubes.removeAll()

        // Configurar los coches en las carreteras
        for roadFrame in roadSections {
            for i in 0..<numberOfCubes {
                let cubeX = CGFloat(i) * (cubeSize + 70) // Espaciados dinnmicos
                let cubeY = roadFrame.minY + (roadFrame.height / 2) - (cubeSize / 2)

                //Crear el coche (coche10)
                let carImageView = UIImageView(frame: CGRect(x: cubeX, y: cubeY, width: cubeSize, height: cubeSize))
                carImageView.image = UIImage(named: "car10") //Cargar la imagen del coche
                carImageView.contentMode = .scaleToFill // Forzar que ocupe el tamaño completo del frame
               // carImageView.layer.borderWidth = 1 //marco para depure
                //carImageView.layer.borderColor = UIColor.clear.cgColor

                // Añadir el coche a la vista contenedora
                carContainerView.addSubview(carImageView)
                cubes.append(carImageView) // Guardar la referencia en la lista de coches
            }
        }
    }



    @objc func updateCubes() {
        for cube in cubes {
            // Ignorar coches fuera del rango vertical del jugador
            if cube.frame.midY < movingRectangle.frame.minY - 200 || cube.frame.midY > movingRectangle.frame.maxY + 200 {
                continue
            }

            // Mover el coche hacia la derecha
            cube.frame.origin.x += cubeSpeed

            // Si el jugador está en pasto, no pierde vidas (sistema de colisiones extraños, pero funciona)
            if isPlayerOnGrass() {
                continue
            }

            // Calcular las distancias entre el cubo y el jugador
            let distanceToPlayerX = abs(cube.frame.midX - movingRectangle.frame.midX)
            let distanceToPlayerY = abs(cube.frame.midY - movingRectangle.frame.midY)

            // Verificar colision precisa
            if distanceToPlayerX <= cubeSize / 2 && distanceToPlayerY <= cubeSize / 2 {
                if cube.backgroundColor != .gray {
                    cube.backgroundColor = .gray // Cambiar color para indicar colisión
                    //vidas -= 1
                    loseLife()
                    print("Vidas restantes: \(vidas)")
                }
            }

            // Reiniciar posicion si el coche sale de la pantalla
            if cube.frame.origin.x > 590 {
                cube.frame.origin.x = -cubeSize //Reiniciar fuera de la pantalla
                //cube.backgroundColor = .red //color original
            }
        }
    }
















    
    //Coches Track
    /*
    var positionTrackerTimer: Timer?
    
    
    func startTrackingCarPositions() {
        // Iniciar un timer que se ejecuta cada 0.5 segundos
        positionTrackerTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.logCarPositions()
        }
    }
     

    func stopTrackingCarPositions() {
        // Detener el timer si existe
        positionTrackerTimer?.invalidate()
        positionTrackerTimer = nil
    }

    func logCarPositions() {
        for (index, car) in cars.enumerated() {
            print("Car \(index): Position x = \(car.frame.origin.x), y = \(car.frame.origin.y)")
        }
    }
     */
  
    

    
    //Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba
    //Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba
    //Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba
    //Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba Codigo de prueba
    //FIN

    
    
    
    
    
    
    
    
    
    
    //Nunca funciono, pero tras horas y horas y horas de debug se mostro que los elementos graficos
    //en moviento eran distintos a las posiciones que marcaban, aun asi se veian bonitos avanzando
    //como en una carretera real, podria funcinar como inspiracion
    
    // COCHES
    // Propiedades globales del controlador
    //NUNCA pude hacer que funcionaran las colisiones, pero se veian bonitos pueden servir para los futuros
    //coches (cubos)
    var containerView: UIView!
    var roadContainerView: UIView! // Contenedor para las carreteras
    var carContainerView: UIView!  // Contenedor para los coches
    var cars: [UIView] = []
    let carSize = CGSize(width: 50, height: 30)
    
    var columnsWithCars: Set<Int> = []
    var roadSections: [CGRect] = [] //arrey que almacena las posiciones de las secciones de carretera
    
    func addCar(at position: CGPoint, column: Int) {
        //revisa si ya hay un coche en esta columna
        if columnsWithCars.contains(column) {
            return
        }
        
        //imagen coche10 como coches
        let carImage = UIImage(named: "car10")
        let carView = UIImageView(image: carImage)
        carView.frame = CGRect(origin: position, size: carSize)
        carView.contentMode = .scaleAspectFit
        carView.tag = column
        carContainerView.addSubview(carView)
        cars.append(carView)
        
        // Marcar la columna como ocupada
        columnsWithCars.insert(column)
        
        // Ajustar la posición inicial del coche fuera del rango visible
        carView.frame.origin.x = CGFloat.random(in: 650...750) // Comienza fuera de la pantalla visible
        
        // Iniciar el movimiento hacia la izquierda
        startContinuousCarMovement(for: carView)
    }

    
    func startContinuousCarMovement(for car: UIView) {
        let speed = CGFloat(50 + Int.random(in: 2...3)) // Velocidad más baja
        let destinationX: CGFloat = -car.frame.width // Punto donde desaparece

        UIView.animate(withDuration: Double((car.frame.origin.x - destinationX) / speed), delay: 0, options: [.curveLinear], animations: {
            car.frame.origin.x = destinationX
        }) { _ in
            // Reiniciar posición del coche
            car.frame.origin.x = CGFloat.random(in: 650...750)
            car.frame.origin.y = CGFloat.random(in: 100...self.scrollLimitY)
            self.startContinuousCarMovement(for: car)
        }
    }
    
    func generateRoadSections() {
        let roadHeight: CGFloat = 60 // Altura de cada carretera
        let roadYPositions = stride(from: 100, to: scrollLimitY, by: roadHeight).map { $0 }
        
        for yPosition in roadYPositions {
            let roadFrame = CGRect(x: 0, y: yPosition, width: scrollLimitX, height: roadHeight)
            roadSections.append(roadFrame)
        }
    }


    
    func setupCars() {
        guard !roadSections.isEmpty else {
            return
        }

        // Limpiar coches anteriores
        cars.forEach { $0.removeFromSuperview() }
        cars.removeAll()
        columnsWithCars.removeAll()
        
        // Añadir coches en cada sección de carretera usando roadSections
        for roadSection in roadSections {
            if Bool.random() { // Añadir coche con probabilidad aleatoria
                let carPosition = CGPoint(x: -carSize.width, y: roadSection.midY - (carSize.height / 2))
                let column = Int(roadSection.minX / carSize.width)
                addCar(at: carPosition, column: column)
            }
        }
        
        //startTrackingCarPositions()
    }

    
    
    
    //COCHES FIN
   
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    //Añadir mas cosas para garantizar que el juego se reinicie y corra bien desde el menu en caso de jugar
    //varias veces
    func resetGameState() {
        //Eliminar todos los subviews del scrollView y de la vista principal
        scrollView?.subviews.forEach { $0.removeFromSuperview() }
        self.view.subviews.forEach {
            if $0 !== scrollView { $0.removeFromSuperview() }
        }
        
        //Detener todos los temporizadores y animaciones
        //stopAllTimers()
        stopLeafFallAnimation()
        
        // 3. Reiniciar estados globales
        vidas = 3
        playerEnergy = 100.0
        isGameRunning = false
        depositedCoins = 0
        collectedCoins = 0
        direction = .zero
        spriteIndex = 0

        //Limpiar hojas activas
        activeLeaves.forEach { $0.removeFromSuperview() }
        activeLeaves.removeAll()

        //Limpiar arrays de elementos del juego
        borderImages.removeAll()
        staticImages.removeAll()
        cars.removeAll()
        cubes.forEach { $0.removeFromSuperview() }
        cubes.removeAll()
        placedElements.removeAll()
        depositZones.removeAll()
        roadSections.removeAll()
        resetParticles()

        //Restaurar el scrollView
        scrollView?.contentOffset = .zero // Llevar al inicio
        scrollView?.contentSize = CGSize(width: scrollLimitX, height: scrollLimitY)

        //Limpieza de containers
        containerView?.subviews.forEach { $0.removeFromSuperview() }
        containerView?.removeFromSuperview()
        roadContainerView?.subviews.forEach { $0.removeFromSuperview() }
        roadContainerView?.removeFromSuperview()
    }


    
    
    
    //NEW
    //NEW
    // Mostrar el menu principal
    func showMainMenu() {
        
        resetGameState()
    
        stopLeafFallAnimation()
        
        // Elimina todas las vistas del juego activas
            scrollView?.removeFromSuperview()
            movingRectangle?.removeFromSuperview()
        
        
        let menuView = UIView(frame: self.view.bounds)
        menuView.backgroundColor = .white
        menuView.tag = 999
        self.view.addSubview(menuView)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 50))
        titleLabel.text = "Videojuego"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        menuView.addSubview(titleLabel)
        
        let startButton = UIButton(frame: CGRect(x: 50, y: 200, width: self.view.bounds.width - 100, height: 50))
        startButton.setTitle("Star Game", for: .normal)
        startButton.backgroundColor = .green
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        menuView.addSubview(startButton)
        //Posible boton de tutorial/enseñar lo basico
        
        
        
        let optionButton = UIButton(frame: CGRect(x: 50, y: 280, width: self.view.bounds.width - 100, height: 50))
        optionButton.setTitle("Botón 2", for: .normal)
        optionButton.backgroundColor = .green
        menuView.addSubview(optionButton)
         
    }
         
    
    @objc func startGame() {
        guard let menuView = self.view.viewWithTag(999) else { return }
        menuView.removeFromSuperview()
        
        
        resetGameState()
        
        // Reiniciar estado del juego
        //vidas = 3
        //playerEnergy = 100.0
        isGameRunning = true
        
        
        
        setupScrollView()
        setupGame()
    }
    
    
    var collectedCoinsCapacity: Int = 10 // Capacidad máxima de monedas
    var collectedCoinsBar: UIProgressView! // Barra de progreso para las monedas recogidas
    var energyBar: UIProgressView! // Barra de energía del jugador
    
    // Configuración de la interfaz de juego
    func setupGameUI() {
        // Etiqueta de vidas
        livesLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 30))
        livesLabel.text = "Vidas: \(vidas)"
        livesLabel.textColor = .white
        self.view.addSubview(livesLabel)
        
        // Barra de monedas recogidas
        collectedCoinsBar = UIProgressView(progressViewStyle: .default)
        collectedCoinsBar.frame = CGRect(x: self.view.bounds.width - 120, y: 20, width: 100, height: 10)
        collectedCoinsBar.progressTintColor = .yellow // Color de la barra
        collectedCoinsBar.trackTintColor = .darkGray // Color del fondo
        collectedCoinsBar.progress = Float(collectedCoins) / Float(collectedCoinsCapacity) // Actualiza el progreso inicial
        self.view.addSubview(collectedCoinsBar)
        
        // Barra de energia
        energyBar = UIProgressView(progressViewStyle: .default)
        energyBar.frame = CGRect(x: self.view.bounds.width - 120, y: 40, width: 100, height: 10)
        energyBar.progressTintColor = .blue // Color de la barra
        energyBar.trackTintColor = .darkGray // Color del fondo
        energyBar.progress = Float(playerEnergy / 100.0) // Progreso inicial
        self.view.addSubview(energyBar)
    }
    
    
    /*
    // Configuración de la barra de energía
    func startEnergyTimer() {
        energyTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.reduceEnergy()
        }
    }
     */
    
    func reduceEnergy() {
        guard isGameRunning else { return }
        playerEnergy -= 2.0 / 4.0 //rate en que se reduce la energia, parece bien
        energyBar.progress = Float(playerEnergy / 100.0) // Actualiza la barra de energía

        if playerEnergy <= 0 {
            endGame(reason: "Energia agotada") // Finaliza el juego si se queda sin energía
        }
    }

    
    // Configuración del botón para pruebas (quitar vidas)
    func setupDebugButton() {
        let debugButton = UIButton(frame: CGRect(x: self.view.bounds.width - 120, y: 100, width: 100, height: 40))
        debugButton.setTitle("Quitar Vida", for: .normal)
        debugButton.backgroundColor = .red
        debugButton.setTitleColor(.white, for: .normal)
        debugButton.addTarget(self, action: #selector(removeLife), for: .touchUpInside)
        self.view.addSubview(debugButton)
    }
    
    @objc func removeLife() {
        guard isGameRunning else { return } // Evitar que funcione si el juego no está activo
        vidas -= 1
        livesLabel.text = "Vidas: \(vidas)"
        
        if vidas <= 0 {
            endGame(reason: "Te quedaste sin vidas")
        }
    }
    
    
    //NEW
    //NEWS
    
    
    //NEWS2
    //NEWS2
    
    // Verificar colisiones
    func checkCollisions() {
        for car in cars {
            if movingRectangle.frame.intersects(car.frame) {
                loseLife()
                break
            }
        }
    }
    
    func loseLife() {
        guard isGameRunning else { return }
        vidas -= 1
        livesLabel.text = "Vidas: \(vidas)"
        if vidas <= 0 {
            endGame(reason: "Perdiste todas las vidas")
        }
    }
    
    func endGame(reason: String) {
        isGameRunning = false
        
        // Detener el temporizador de energía
        energyTimer?.invalidate()
        
        // Mostrar alerta de fin del juego
        let alert = UIAlertController(title: "Juego Terminado", message: reason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Volver al Menú", style: .default) { _ in
            self.showMainMenu()
        })
        self.present(alert, animated: true, completion: nil)
        
        resetGameState()
    }
    
    
    //NEWS2
    
    
    
    
    
    //ARBOLES
    func setupArboles(numberOfTrees: Int) {
        for i in 0..<numberOfTrees {
            let randomX = CGFloat.random(in: 0...(scrollLimitX - 40)) // Ajusta el tamaño
            let randomY = CGFloat.random(in: 0...(scrollLimitY - 80)) // Ajusta el tamaño
            
            let tree = UIImageView(frame: CGRect(x: randomX, y: randomY, width: 40, height: 80))
            tree.image = UIImage(named: ["arbol1", "arbol2", "arbol3"].randomElement()!)
            //tree.layer.borderWidth = 1
            //tree.layer.borderColor = UIColor.green.cgColor
            tree.backgroundColor = UIColor.clear
            
            containerView.addSubview(tree)
            borderImages.append(tree)
            
        }
    }
    
    func isCollidingWithTrees(playerFrame: CGRect) -> Bool {
        for tree in borderImages {
            if tree.frame.intersects(playerFrame) {
                return true
            }
        }
        return false
    }

    
    /*Piso Cafe
     func setupScrollView() {
     let scrollViewHeight = self.view.bounds.height / 3
     scrollView = UIView(frame: CGRect(x: 0, y: (self.view.bounds.height - scrollViewHeight) / 2, width: self.view.bounds.width, height: scrollViewHeight))
     scrollView.backgroundColor = .brown
     self.view.addSubview(scrollView)
     }
     */
    //PISO
    //PISO
    //Termina Zona de PISO
    
    
    
   
    //Basura label, se ve mas bonito pero ocupa mucho espacio
    func setupCoinLabel() {
        coinLabel = UILabel(frame: CGRect(x: 20, y: 40, width: 200, height: 40))
        coinLabel.textColor = .white
        coinLabel.font = UIFont.boldSystemFont(ofSize: 20)
        //coinLabel.text = "Monedas: \(collectedCoins)"
        //coinLabel.text = "Monedas depositadas: \(depositedCoins)"
        self.view.addSubview(coinLabel)
    }
    
    func setupCoinLabel2() {
        coinLabel = UILabel(frame: CGRect(x: 20, y: 60, width: 200, height: 40))
        coinLabel.textColor = .white
        coinLabel.font = UIFont.boldSystemFont(ofSize: 20)
        //coinLabel.text = "Monedas: \(collectedCoins)"
        //coinLabel.text = "Depositadas: \(depositedCoins)"
        self.view.addSubview(coinLabel)
    }
    
    //imagenes staticas array
    var staticImages: [UIImageView] = []
    
    
    func setupColectibles() {
        let imageSize: CGFloat = 30.0
        let numberOfImages = 100
        
        for _ in 0..<numberOfImages {
            createBasuras(imageSize: 30, numberOfImages: 10)
        }
    }
    
    
    
    
    let basura: [String] = [
        "basura1",
        "basura2",
        "basura3",
        "basura4",
        "basura5",
        "basura6",
        "basura7",
        "basura8"
    ]
    
    func createBasuras(imageSize: CGFloat, numberOfImages: Int) {
        for _ in 0..<numberOfImages {
            let randomX = CGFloat.random(in: 0...(scrollLimitX - imageSize))
            let randomY = CGFloat.random(in: 0...(scrollLimitY - imageSize))
            
            let imageView = UIImageView(frame: CGRect(x: randomX, y: randomY, width: imageSize, height: imageSize))
            
            if let randomImageName = basura.randomElement() {
                imageView.image = UIImage(named: randomImageName)
            }
            
            scrollView.addSubview(imageView)
            staticImages.append(imageView)
            
            
            
            startFloatingAnimation(for: imageView)
        }
    }

    
    
    func createBasura(imageSize: CGFloat) {
        let randomX = CGFloat.random(in: 0...(scrollLimitX - imageSize))
        //let randomY = CGFloat.random(in: 0...(scrollView.bounds.height - imageSize))
        let randomY = CGFloat.random(in: 0...(scrollLimitY - imageSize))

        
        let imageView = UIImageView(frame: CGRect(x: randomX, y: randomY, width: imageSize, height: imageSize))
        
        
        // Randomly select an image from the array
        if let randomImageName = basura.randomElement() {
            imageView.image = UIImage(named: randomImageName)
        }
        
        scrollView.addSubview(imageView)
        staticImages.append(imageView)
        
        // Start floating animation
        startFloatingAnimation(for: imageView)
    }
    
    // Animación de flotación
    func startFloatingAnimation(for imageView: UIImageView) {
        let floatDistance: CGFloat = 10.0 //distancia
        let floatDuration: Double = 1.0 //duracion
        
        //go up animation
        UIView.animate(withDuration: floatDuration, delay: 0, options: [.autoreverse, .repeat], animations: {
            imageView.frame.origin.y -= floatDistance
        }, completion: nil)
    }
    
    //regenerar cuando son recogidas o salen de la vista
    func regenerateImagesIfNeeded() {
        for (index, imageView) in staticImages.enumerated().reversed() {
            if imageIsOutOfView(imageView) || playerCollected(imageView) {
                imageView.removeFromSuperview()
                staticImages.remove(at: index)
                createBasura(imageSize: 30.0) // Crea una nuevo colectible en una posición aleatoria
            }
        }
    }
    
    //fuera de la vista
    func imageIsOutOfView(_ imageView: UIImageView) -> Bool {
        return imageView.frame.origin.y > scrollView.bounds.height || imageView.frame.origin.x > scrollView.bounds.width
    }
    
    // Simula si el jugador recoge una imagen
    func playerCollected(_ imageView: UIImageView) -> Bool {
       
        return false
    }
    
    func setupControlButtons() {
        let buttonSize: CGFloat = 50.0
        let verticalOffset: CGFloat = 50.0
        
        // Botón derecha
        let rightButton = UIButton(frame: CGRect(
            x: (self.view.bounds.width - buttonSize) / 2 + 60,
            y: self.view.bounds.height - 150 - verticalOffset,
            width: buttonSize,
            height: buttonSize))
        rightButton.setImage(UIImage(named: "right"), for: .normal)
        rightButton.addTarget(self, action: #selector(startMovingRight), for: .touchDown)
        rightButton.addTarget(self, action: #selector(stopMoving), for: [.touchUpInside, .touchUpOutside])
        self.view.addSubview(rightButton)
        
        // Botón izquierda
        let leftButton = UIButton(frame: CGRect(
            x: (self.view.bounds.width - buttonSize) / 2 - 60,
            y: self.view.bounds.height - 150 - verticalOffset,
            width: buttonSize,
            height: buttonSize))
        leftButton.setImage(UIImage(named: "left"), for: .normal)
        leftButton.addTarget(self, action: #selector(startMovingLeft), for: .touchDown)
        leftButton.addTarget(self, action: #selector(stopMoving), for: [.touchUpInside, .touchUpOutside])
        self.view.addSubview(leftButton)
        
        // Botón arriba
        let upButton = UIButton(frame: CGRect(
            x: (self.view.bounds.width - buttonSize) / 2,
            y: self.view.bounds.height - 210 - verticalOffset,
            width: buttonSize,
            height: buttonSize))
        upButton.setImage(UIImage(named: "up"), for: .normal)
        upButton.addTarget(self, action: #selector(startMovingUp), for: .touchDown)
        upButton.addTarget(self, action: #selector(stopMoving), for: [.touchUpInside, .touchUpOutside])
        self.view.addSubview(upButton)
        
       
    }

    
    

    
    func setupRegenerateCoinsButton() {
        let regenerateButton = UIButton(frame: CGRect(x: self.view.bounds.width - 70, y: 40, width: 50, height: 50))
        regenerateButton.setImage(UIImage(named: "monedasinfondo"), for: .normal)
        regenerateButton.addTarget(self, action: #selector(regenerateCoins), for: .touchUpInside)
        self.view.addSubview(regenerateButton)
    }
    
    @objc func startMovingRight() {
        direction = CGPoint(x: movementSpeed, y: 0)
        currentDirectionSprites = rightSprites
        startMovement()
    }
    
    @objc func startMovingLeft() {
        direction = CGPoint(x: -movementSpeed, y: 0)
        currentDirectionSprites = leftSprites
        startMovement()
    }
    
    @objc func startMovingUp() {
        direction = CGPoint(x: 0, y: -movementSpeed)
        currentDirectionSprites = upSprites
        startMovement()
    }
    
    @objc func startMovingDown() {
        direction = CGPoint(x: 0, y: movementSpeed)
        currentDirectionSprites = downSprites
        startMovement()
    }
    
    
    
    
    
   
   
    
    
    func expandContentIfNeeded(forYPosition yPosition: CGFloat) {
        let expansionThreshold: CGFloat = 200.0
        
        // Expande hacia abajo cuando el personaje se acerca al borde inferior
        if yPosition > scrollView.contentSize.height - expansionThreshold {
            scrollView.contentSize.height += scrollLimitY
            containerView.frame.size.height = scrollView.contentSize.height
            
            // Añadir nuevas secciones de piso, carretera y elementos en la parte inferior
            addTiles(startingAt: scrollView.contentSize.height - scrollLimitY, direction: .down)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //var collectedCoins = 0
    var depositedCoins = 0
    
    var collectedCoinsLabel: UILabel!
    var depositedCoinsLabel: UILabel!
    
    var depositZone: UIImageView!
    
    //SISTEMA de Almacenar monedas
    func setupCollectedCoinsLabel() {
        collectedCoinsLabel = UILabel(frame: CGRect(x: 20, y: 40, width: 200, height: 40))
        //collectedCoinsLabel.text = "Monedas recogidas: \(collectedCoins)"
        collectedCoinsLabel.textColor = .black
        self.view.addSubview(collectedCoinsLabel)
    }
    
    func setupDepositedCoinsLabel() {
        depositedCoinsLabel = UILabel(frame: CGRect(x: 20, y: 80, width: 200, height: 40))
        //depositedCoinsLabel.text = "Monedas depositadas: \(depositedCoins)"
        depositedCoinsLabel.textColor = .black
        self.view.addSubview(depositedCoinsLabel)
    }
    
    // Arreglo para almacenar multiples zonas de deposito
    var depositZones: [UIImageView] = []
    
    // Tamaño de la zona de depósito
    let zoneSize: CGFloat = 100.0
    
    
    
    
    /*
     //Animación del sprite de la zona de depósito
     func startDepositZoneAnimation() {
     Timer.scheduledTimer(timeInterval: depositZoneSpriteSpeed, target: self, selector: #selector(updateDepositZoneSprite), userInfo: nil, repeats: true)
     }
     
     @objc func updateDepositZoneSprite() {
     depositZoneSpriteIndex = (depositZoneSpriteIndex + 1) % depositZoneSprites.count
     depositZone.image = depositZoneSprites[depositZoneSpriteIndex]
     }
     */
    
    
    
    
   
    
    
    @objc func stopMoving() {
        movementTimer?.invalidate()
    }
    
    @objc func regenerateCoins() {
        setupColectibles()
    }
    
    
    
    
    
    //Particulas
    //Sistema de particulas
    //Particulas
    //Particulas
    var particleTimer: Timer?
    
    //Array de PNG de hojas
    let leafImages: [UIImage] = [
        UIImage(named: "leaf1")!, //leaf1...
        UIImage(named: "leafs2")!,
        UIImage(named: "leafs3")!,
        UIImage(named: "leafs4")!
        
    ]
    
    func startLeafFallAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            for _ in 0..<3 {
                self.createFallingLeaf()
            }
        }
    }
    
    var activeLeaves: [UIImageView] = [] // hojas activas

    
    func createFallingLeaf() {
        let leafSize = CGSize(width: 30, height: 30)
        let startX = CGFloat.random(in: 0...self.view.bounds.width - leafSize.width)
        let leafImageView = UIImageView(frame: CGRect(x: startX, y: -leafSize.height, width: leafSize.width, height: leafSize.height))
        leafImageView.image = leafImages.randomElement()
        leafImageView.tag = 1001 // tag para identificar las hojas
        self.view.addSubview(leafImageView)
        activeLeaves.append(leafImageView) // Añadir al array de hojas activas

        // fall
        let totalDuration: TimeInterval = 8.0
        let numberOfZigzags = 4
        let zigzagDuration = totalDuration / Double(numberOfZigzags)

        var currentDirection: CGFloat = 1.0

        for i in 0..<numberOfZigzags {
            let nextX = currentDirection * CGFloat.random(in: 30...60)
            let nextY = CGFloat(i + 1) * (self.view.bounds.height / CGFloat(numberOfZigzags))
            let rotationAngle = CGFloat.random(in: -0.2...0.2) // Rotacion leve

            UIView.animate(withDuration: zigzagDuration, delay: zigzagDuration * Double(i), options: [.curveEaseInOut], animations: {
                leafImageView.center = CGPoint(x: leafImageView.center.x + nextX, y: nextY)
                leafImageView.transform = leafImageView.transform.rotated(by: rotationAngle)
            }, completion: nil)

            currentDirection *= -1.0
        }

        // Desvanecer y remover la hoja despues de la animacion
        UIView.animate(withDuration: totalDuration, animations: {
            leafImageView.alpha = 0
        }) { _ in
            if let index = self.activeLeaves.firstIndex(of: leafImageView) {
                self.activeLeaves.remove(at: index) // Remover del array cuando termine la animacion
            }
            leafImageView.removeFromSuperview()
        }
    }

    
    func stopLeafFallAnimation() {
        // Eliminar todas las hojas (subviews) del contenedor o vista principal
        self.view.subviews.forEach { subview in
            if subview.tag == 1001 { //tag unico para las hojas
                subview.removeFromSuperview()
            }
        }
    }

    
    
    //Particulas
    //Particulas
    //End
    
    //Deposit zones set up
    func setupDepositZones(numberOfZones: Int) {
        for _ in 0..<numberOfZones {
            let randomX = CGFloat.random(in: 0...(scrollLimitX - 50))
            let randomY = CGFloat.random(in: 0...(scrollLimitY - 50)) // Usa scrollLimitY
            let depositZone = UIImageView(frame: CGRect(x: randomX, y: randomY, width: 50, height: 50))
            depositZone.image = depositZoneSprites[0]
            //depositZone.layer.borderWidth = 2
            //depositZone.layer.borderColor = UIColor.red.cgColor
            //depositZone.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
            containerView.addSubview(depositZone)
            depositZones.append(depositZone)
        }
    }
    
    var panels: [UIImageView] = []

    
    func setupPanels(numberOfPanels: Int) {
        for _ in 0..<numberOfPanels {
            let randomX = CGFloat.random(in: 0...(scrollLimitX - 50))
            let randomY = CGFloat.random(in: 0...(scrollLimitY - 50))
            
            let panel = UIImageView(frame: CGRect(x: randomX, y: randomY, width: 50, height: 50))
            panel.image = UIImage(named: "panel")
            //panel.layer.borderWidth = 1
            //panel.layer.borderColor = UIColor.yellow.cgColor
            panel.backgroundColor = UIColor.clear
            
            containerView.addSubview(panel)
            panels.append(panel) // Guarda la referencia para detectar colisiones
        }
    }
    
    func checkCollisionWithPanels() {
        for (index, panel) in panels.enumerated() {
            if movingRectangle.frame.intersects(panel.frame) {
                // Recargar energía
                playerEnergy = min(100.0, playerEnergy + 20.0) // Incrementa la energía, máximo 100
                energyBar.progress = Float(playerEnergy / 100.0)
                print("Energía recargada a \(playerEnergy)%")

                // Elimina el panel del mapa
                panel.removeFromSuperview()
                panels.remove(at: index) // Elimina el panel de la lista
                print("Panel \(index + 1) usado y eliminado.")
                break
            }
        }
    }



    
    
    
    //IRRELEVANTES CON BUGS IRRELEVANTES CON BUGS IRRELEVANTES CON BUGS IRRELEVANTES CON BUGS
    //IRRELEVANTES CON BUGS IRRELEVANTES CON BUGS IRRELEVANTES CON BUGS IRRELEVANTES CON BUGS
    //IRRELEVANTES CON BUGS IRRELEVANTES CON BUGS IRRELEVANTES CON BUGS IRRELEVANTES CON BUGS
    
    



    
    // Manejar el movimiento de cada zona de depósito
    @objc func moveDepositZone(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: scrollView)
        if let view = gesture.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        gesture.setTranslation(.zero, in: scrollView)
    }
    
    
    //NUEVAS ZONAS PERO AUN NO LLEGAMOS A ESA PARTE NUEVAS ZONAS PERO AUN NO LLEGAMOS A ESA PARTE
    //NUEVAS ZONAS PERO AUN NO LLEGAMOS A ESA PARTE NUEVAS ZONAS PERO AUN NO LLEGAMOS A ESA PARTE
    //NUEVAS ZONAS PERO AUN NO LLEGAMOS A ESA PARTE NUEVAS ZONAS PERO AUN NO LLEGAMOS A ESA PARTE
    //NUEVAS ZONAS PERO AUN NO LLEGAMOS A ESA PARTE NUEVAS ZONAS PERO AUN NO LLEGAMOS A ESA PARTE
    
    
    
    func generateInitialSections() {
        let tileHeight = floorImages.first!.size.height
        let horizontalTiles = Int(scrollLimitX / tileHeight)
        var currentY: CGFloat = scrollLimitY * 4 //
        
        while currentY > 0 {
            let floorCount = Int.random(in: 3...5)
            for _ in 0..<floorCount {
                if currentY <= 0 { break }
                for i in 0..<horizontalTiles {
                    let randomFloorImage = floorImages.randomElement()!
                    let tileView = UIImageView(image: randomFloorImage)
                    tileView.contentMode = .scaleAspectFill
                    tileView.frame = CGRect(x: CGFloat(i) * tileHeight, y: currentY, width: tileHeight, height: tileHeight)
                    containerView.addSubview(tileView)
                }
                currentY -= tileHeight
            }
            
            let roadCount = Int.random(in: 4...7)
            columnsWithCars.removeAll()
            
            for _ in 0..<roadCount {
                if currentY <= 0 { break }
                for i in 0..<horizontalTiles {
                    let roadView = UIImageView(image: roadImage)
                    roadView.contentMode = .scaleAspectFill
                    roadView.frame = CGRect(x: CGFloat(i) * tileHeight, y: currentY, width: tileHeight, height: tileHeight)
                    roadContainerView.addSubview(roadView)
                    
                    if !columnsWithCars.contains(i) && Bool.random() {
                        let carPosition = CGPoint(x: CGFloat(i) * tileHeight, y: currentY + (tileHeight / 2) - (carSize.height / 2))
                        addCar(at: carPosition, column: i)
                        columnsWithCars.insert(i)
                    }
                }
                currentY -= tileHeight
            }
        }
    }
    
    
    
    func generateNewSectionsIfNeeded() {
        let tileHeight = floorImages.first!.size.height
        let currentOffsetY = scrollView.contentOffset.y
        
        // Si el jugador está cerca de la parte superior, generamos nuevas secciones en la parte superior
        if movingRectangle.frame.origin.y - currentOffsetY < scrollView.bounds.height / 2 {
            var currentY: CGFloat = containerView.frame.minY - tileHeight // Comienza en la parte superior de containerView
            
            while currentY > currentOffsetY - scrollView.bounds.height {
                // Generar secciones de piso
                let floorCount = Int.random(in: 3...5)
                for _ in 0..<floorCount {
                    if currentY <= currentOffsetY - scrollView.bounds.height { break }
                    for i in 0..<Int(scrollLimitX / tileHeight) {
                        let randomFloorImage = floorImages.randomElement()!
                        let tileView = UIImageView(image: randomFloorImage)
                        tileView.contentMode = .scaleAspectFill
                        tileView.frame = CGRect(x: CGFloat(i) * tileHeight, y: currentY, width: tileHeight, height: tileHeight)
                        containerView.addSubview(tileView)
                    }
                    currentY -= tileHeight
                }
                
                // Generar secciones de carretera
                let roadCount = Int.random(in: 4...7)
                columnsWithCars.removeAll() // Reiniciar las columnas ocupadas para la nueva sección completa
                
                for _ in 0..<roadCount {
                    if currentY <= currentOffsetY - scrollView.bounds.height { break }
                    for i in 0..<Int(scrollLimitX / tileHeight) {
                        let roadView = UIImageView(image: roadImage)
                        roadView.contentMode = .scaleAspectFill
                        roadView.frame = CGRect(x: CGFloat(i) * tileHeight, y: currentY, width: tileHeight, height: tileHeight)
                        roadContainerView.addSubview(roadView)
                        
                        // Añadir un coche en la carretera
                        if !columnsWithCars.contains(i) && Bool.random() {
                            let carPosition = CGPoint(x: CGFloat(i) * tileHeight, y: currentY + (tileHeight / 2) - (carSize.height / 2))
                            addCar(at: carPosition, column: i)
                            columnsWithCars.insert(i)
                        }
                    }
                    currentY -= tileHeight
                }
            }
        }
    }
    
    
    //NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN
    //NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN
    //NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN
    //NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN
    //NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN
    //NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN
    //NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN
    //NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN
    //NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN NO SE USAN
    
    //Uso para proyecto personal
    //Uso para proyecto personal
    //Uso para proyecto personal
    
    
    //Edificios
    //Edificios
    //Array de imagenes de edificios
    let buildingImages: [UIImage] = [
        UIImage(named: "building1")!,
        UIImage(named: "building2")!,
        UIImage(named: "building3")!,
        UIImage(named: "building4")!
    ]
    
    var placedElements: [CGRect] = [] //Array para guardar las posiciones de los elementos colocados
    //evitar choques entre ellos
    
    
    func setupBuildings() {
        // Ajusta el número de edificios según el límite en X
        let numberOfBuildings = max(1, Int(scrollLimitX / 200))
        let buildingSize = CGSize(width: 200, height: 200)
        
        // Verifica el limite
        guard scrollLimitX >= buildingSize.width else {
            print("demasiado pequeño para colocar edificios.")
            return
        }
        
        for _ in 0..<numberOfBuildings {
            var buildingFrame: CGRect
            var positionIsValid: Bool
            
            repeat {
                let randomX = CGFloat.random(in: 0...(scrollLimitX - buildingSize.width))
                let randomY = CGFloat.random(in: 0...(scrollView.bounds.height - buildingSize.height))
                buildingFrame = CGRect(x: randomX, y: randomY, width: buildingSize.width, height: buildingSize.height)
                
                //verificar choques
                positionIsValid = !placedElements.contains { $0.intersects(buildingFrame) }
                
            } while !positionIsValid
            
            let buildingImageView = UIImageView(frame: buildingFrame)
            buildingImageView.image = buildingImages.randomElement()
            scrollView.addSubview(buildingImageView)
            
            placedElements.append(buildingFrame)
        }
    }
    
    
    
    
    
    //Edificos
    //Edificios
    
    
    //Pasto
    //Pasto
    
    //radio de protección para el pasto
    let grassProtectionRadius: CGFloat = 50.0
    
    //funcion para colocar el pasto en el mapa
    func placeGrass(at position: CGPoint) {
        // Asegurarse de que no haya colisión con edificios
        
        for buildingFrame in placedElements {
            let distance = hypot(buildingFrame.midX - position.x, buildingFrame.midY - position.y)
            if distance < grassProtectionRadius {
                return // Colisión detectada, no colocar pasto aquí
            }
        }
        
        // Seleccionar una imagen de pasto aleatoriamente
        let grassImageName = "grass\(Int.random(in: 1...3)).png"
        let grassImageView = UIImageView(image: UIImage(named: grassImageName))
        grassImageView.frame = CGRect(x: position.x, y: position.y, width: 50, height: 50)
        
        // Añadir la vista de pasto al scrollView
        scrollView.addSubview(grassImageView)
    }
    
    
    
    
    func setupInventoryButton() {
        //boton para abrir el inventario
        let inventoryButton = UIButton(frame: CGRect(x: self.view.bounds.width - 120, y: self.view.bounds.height - 80, width: 100, height: 40))
        inventoryButton.setTitle("Inventario", for: .normal)
        inventoryButton.backgroundColor = .green
        inventoryButton.addTarget(self, action: #selector(abrirInventario), for: .touchUpInside)
        self.view.addSubview(inventoryButton)
    }
    
    @objc func abrirInventario() {
        //Crear una vista grande cuando se abra inventario
        let inventarioView = UIView(frame: CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height * 0.8))
        inventarioView.backgroundColor = .white
        inventarioView.layer.cornerRadius = 20
        self.view.addSubview(inventarioView)
        
        // Animar la aparición de la vista del inventario
        UIView.animate(withDuration: 0.3) {
            inventarioView.frame.origin.y = self.view.bounds.height * 0.2
        }
        
        // Añadir un botón de cerrar en la esquina superior derecha
        let closeButton = UIButton(frame: CGRect(x: inventarioView.bounds.width - 50, y: 20, width: 30, height: 30))
        closeButton.setImage(UIImage(named: "monedasinfondo.png"), for: .normal)
        closeButton.addTarget(self, action: #selector(cerrarInventario), for: .touchUpInside)
        inventarioView.addSubview(closeButton)
        
        // Mostrar los objetos del inventario con sus imágenes y permitir seleccionarlos
        for (index, objeto) in inventario.enumerated() {
            let objetoView = UIView(frame: CGRect(x: 20, y: 80 + index * 120, width: Int(inventarioView.bounds.width) - 40, height: 100))
            
            let objetoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            objetoImageView.image = objeto.imagen
            objetoImageView.contentMode = .scaleAspectFit
            objetoImageView.isUserInteractionEnabled = true
            objetoImageView.tag = index
            objetoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seleccionarObjeto(_:))))
            objetoView.addSubview(objetoImageView)
            
            let nombreLabel = UILabel(frame: CGRect(x: 110, y: 10, width: objetoView.bounds.width - 120, height: 40))
            nombreLabel.text = objeto.nombre
            nombreLabel.font = UIFont.boldSystemFont(ofSize: 20)
            objetoView.addSubview(nombreLabel)
            
            let precioLabel = UILabel(frame: CGRect(x: 110, y: 50, width: objetoView.bounds.width - 120, height: 40))
            precioLabel.text = "\(objeto.precio) monedas"
            precioLabel.textColor = .darkGray
            objetoView.addSubview(precioLabel)
            
            inventarioView.addSubview(objetoView)
        }
    }
    
    
    
    @objc func cerrarInventario() {
        //Buscar la vista del inventario
        for subview in self.view.subviews {
            if subview.backgroundColor == .white && subview.layer.cornerRadius == 20 {
                //Animar el cierre de la vista del inventario
                UIView.animate(withDuration: 0.3, animations: {
                    subview.frame.origin.y = self.view.bounds.height
                }) { _ in
                    subview.removeFromSuperview()
                }
                break
            }
        }
        
        //Ocultar el cursor si esta visible
        cursorImageView?.removeFromSuperview()
        cursorImageView = nil
        objetoSeleccionado = nil
    }
    
    @objc func seleccionarObjeto(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        let index = imageView.tag
        objetoSeleccionado = inventario[index]
        
        //se muestra cursor para colocar el objeto
        if cursorImageView == nil {
            cursorImageView = UIImageView(image: UIImage(named: "storelogo.png")) //
            cursorImageView?.frame.size = CGSize(width: 50, height: 50) // Tamaño del cursor
            cursorImageView?.contentMode = .scaleAspectFit
            cursorImageView?.isUserInteractionEnabled = true
            self.view.addSubview(cursorImageView!)
        }
        
        //Actualizar la posicion del cursor al hacer click
        let touchPoint = sender.location(in: self.view)
        cursorImageView?.center = touchPoint
    }
    
    @objc func colocarObjeto(_ sender: UITapGestureRecognizer) {
        guard let objeto = objetoSeleccionado else { return }
        
        //colocar el objetvo donde se dio click
        let touchPoint = sender.location(in: scrollView)
        let objectImageView = UIImageView(frame: CGRect(x: touchPoint.x - 20, y: touchPoint.y - 20, width: 40, height: 40))
        objectImageView.image = objeto.imagen
        scrollView.addSubview(objectImageView)
        
        //eliminar el objeto del inventario después de colocarlo en el mapa (opcional)
        if let index = inventario.firstIndex(where: { $0.nombre == objeto.nombre }) {
            inventario.remove(at: index)
        }
        //actualizarCoinLabel()
        
        //Ocultar el cursor y el objeto seleccionado
        cursorImageView?.removeFromSuperview()
        cursorImageView = nil
        objetoSeleccionado = nil
    }
    
    
    
    
    //Inventario
    
    //SISTEMA de tienda
    //TIENDA
    //Definicion de los objetos de la tienda
    struct TiendaObjeto {
        let nombre: String
        let precio: Int
        let imagen: UIImage
    }
    
    var objetosStore: [TiendaObjeto] = [
        TiendaObjeto(nombre: "Objeto 1", precio: 100, imagen: UIImage(named: "store1")!),
        TiendaObjeto(nombre: "Objeto 2", precio: 200, imagen: UIImage(named: "store2")!),
        TiendaObjeto(nombre: "Objeto 3", precio: 300, imagen: UIImage(named: "store3")!),
        TiendaObjeto(nombre: "Objeto 1", precio: 100, imagen: UIImage(named: "store4")!),
        TiendaObjeto(nombre: "Objeto 2", precio: 200, imagen: UIImage(named: "store5")!),
        TiendaObjeto(nombre: "Objeto 3", precio: 300, imagen: UIImage(named: "store6")!)
    ]
    
    //Variables globales
    var collectedCoins = 0 //Monedas iniciales - Pruebas de poder comprar
    //var inventario: [TiendaObjeto] = [] // Inventario del usuario
    
    func setupStoreButton() {
        //imagen/logo de la store
        let storeImageView = UIImageView(frame: CGRect(x: 20, y: 100, width: 100, height: 100))
        storeImageView.image = UIImage(named: "storelogo")
        storeImageView.isUserInteractionEnabled = true
        
        //añadir un gesto al click
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(abrirTienda))
        storeImageView.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(storeImageView)
    }
    
    @objc func abrirTienda() {
        //Crear vista de store
        let tiendaView = UIView(frame: CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height * 0.8))
        tiendaView.backgroundColor = .white
        tiendaView.layer.cornerRadius = 20
        
        //Scrollview dezplazamienta store
        let scrollView = UIScrollView(frame: tiendaView.bounds)
        scrollView.contentSize = CGSize(width: tiendaView.bounds.width, height: CGFloat(objetosStore.count * 120) + 80) // se ajusta el tamaño del contenido según la cantidad de objetos
        tiendaView.addSubview(scrollView)
        
        //boton cerrar tienda
        let closeButton = UIImageView(frame: CGRect(x: tiendaView.bounds.width - 50, y: 20, width: 30, height: 30))
        closeButton.image = UIImage(named: "exitbut") //imagten png para "X" de cerrar
        closeButton.isUserInteractionEnabled = true
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cerrarTienda)))
        tiendaView.addSubview(closeButton)
        
        //Mostrar los objetos de la tienda con su png, nombre y precio en el scrollView
        for (index, objeto) in objetosStore.enumerated() {
            let objetoView = UIView(frame: CGRect(x: 20, y: 80 + index * 120, width: Int(tiendaView.bounds.width) - 40, height: 100))
            
            let objetoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            objetoImageView.image = objeto.imagen
            objetoImageView.contentMode = .scaleAspectFit
            objetoImageView.isUserInteractionEnabled = true
            objetoImageView.tag = index
            objetoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(comprarObjeto(_:))))
            objetoView.addSubview(objetoImageView)
            
            let nombreLabel = UILabel(frame: CGRect(x: 110, y: 10, width: objetoView.bounds.width - 120, height: 40))
            nombreLabel.text = objeto.nombre
            nombreLabel.font = UIFont.boldSystemFont(ofSize: 20)
            objetoView.addSubview(nombreLabel)
            
            let precioLabel = UILabel(frame: CGRect(x: 110, y: 50, width: objetoView.bounds.width - 120, height: 40))
            precioLabel.text = "\(objeto.precio) monedas"
            precioLabel.textColor = .darkGray
            objetoView.addSubview(precioLabel)
            
            //boton para comprar
            let comprarImageView = UIImageView(frame: CGRect(x: objetoView.bounds.width - 50, y: 30, width: 40, height: 40))
            comprarImageView.image = UIImage(named: "storelogo")
            comprarImageView.isUserInteractionEnabled = true
            comprarImageView.tag = index
            comprarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(comprarObjeto(_:))))
            objetoView.addSubview(comprarImageView)
            
            scrollView.addSubview(objetoView)
        }
        
        self.view.addSubview(tiendaView)
        
        //animacion cuando se abra la tienda
        UIView.animate(withDuration: 0.3) {
            tiendaView.frame.origin.y = self.view.bounds.height * 0.2
        }
    }
    
    @objc func cerrarTienda() {
        //Buscar la vista de la tienda
        for subview in self.view.subviews {
            if subview.backgroundColor == .white && subview.layer.cornerRadius == 20 {
                //Animar el cierre de la vista de la tienda
                UIView.animate(withDuration: 0.3, animations: {
                    subview.frame.origin.y = self.view.bounds.height
                }) { _ in
                    subview.removeFromSuperview()
                }
                break
            }
        }
    }
    
    @objc func comprarObjeto(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        let index = imageView.tag
        let objeto = objetosStore[index]
        
        if collectedCoins >= objeto.precio {
            collectedCoins -= objeto.precio
            inventario.append(objeto)
            //actualizarCoinLabel()
            print("Compraste: \(objeto.nombre)")
        } else {
            print("No tienes suficientes monedas para comprar \(objeto.nombre)")
        }
    }
    
    
    
    //TIENDA
    
    //Agregar objetovs
    //Objetovs
    
    
    
    var objetos1: [UIImageView] = []
    
    func agregarObjetos() {
        let objetosImágenes: [UIImage] = [
            UIImage(named: "objeto1")!,
            UIImage(named: "objeto4")!
        ]
        
        let objectSize = CGSize(width: 40, height: 40)
        let protectionRadius: CGFloat = 30.0
        let numberOfObjects = max(1, Int(scrollLimitX / 50)) // Ajusta el número de objetos según el área en X disponible
        
        for _ in 0..<numberOfObjects {
            var objectFrame: CGRect
            var positionIsValid: Bool
            
            repeat {
                let randomX = CGFloat.random(in: 0...(scrollLimitX - objectSize.width))
                let randomY = CGFloat.random(in: 0...(scrollView.bounds.height - objectSize.height))
                objectFrame = CGRect(x: randomX, y: randomY, width: objectSize.width, height: objectSize.height)
                
                // Verificar si el objeto se superpone con otros elementos ya colocados
                positionIsValid = !placedElements.contains { elementFrame in
                    let protectedArea = elementFrame.insetBy(dx: -protectionRadius, dy: -protectionRadius)
                    return protectedArea.intersects(objectFrame)
                }
                
            } while !positionIsValid
            
            let objectImageView = UIImageView(frame: objectFrame)
            objectImageView.image = objetosImágenes.randomElement()
            scrollView.addSubview(objectImageView)
            
            placedElements.append(objectFrame)
            objetos1.append(objectImageView)
        }
    }
    
    
    
    //Objetos
    
    //Animal
    //Animal
    // Arrays para almacenar los sprites del animal/NPC en cada dirección
    enum Direction {
        case up, down, left, right
    }
    
    
    let NPCupSprites: [UIImage] = [
        UIImage(named: "dog_up1")!,
        UIImage(named: "dog_up2")!,
        //UIImage(named: "dog_up3")!!
    ]
    
    let NPCdownSprites: [UIImage] = [
        UIImage(named: "dog_down")!,
        UIImage(named: "dog_down2")!,
        //UIImage(named: "animal_down_3")!
    ]
    
    let NPCleftSprites: [UIImage] = [
        UIImage(named: "dog_left1")!,
        UIImage(named: "dog_left2")!,
        UIImage(named: "dog_left3")!
    ]
    
    let NPCrightSprites: [UIImage] = [
        UIImage(named: "dog_right1")!,
        UIImage(named: "dog_right2")!,
        UIImage(named: "dog_right3")!
    ]
    
    let numberOfAnimals = 10 //numero de NPCS
    
    func setupAnimals() {
        let animalSize: CGFloat = 40.0
        let movementInterval: TimeInterval = 1.0 //Intervalo para el movimiento (más lento)
        
        for _ in 0..<numberOfAnimals {
            let animalImageView = UIImageView(frame: CGRect(x: CGFloat.random(in: 0...(scrollView.bounds.width - animalSize)),
                                                            y: CGFloat.random(in: 0...(scrollView.bounds.height - animalSize)),
                                                            width: animalSize,
                                                            height: animalSize))
            animalImageView.image = NPCdownSprites.first //Imagen inicial
            scrollView.addSubview(animalImageView)
            
            var currentDirection: Direction = .down
            var currentSprites: [UIImage] = NPCdownSprites
            let spriteChangeInterval: TimeInterval = 0.2 //Intervalo para cambiar los sprites (mas lento)
            
            //Configuracion de la animación de sprites
            animalImageView.animationImages = currentSprites
            animalImageView.animationDuration = spriteChangeInterval * Double(currentSprites.count)
            animalImageView.startAnimating()
            
            //Temporizador para el movimiento del animal/NPC
            Timer.scheduledTimer(withTimeInterval: movementInterval, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                
                let direction = self.randomDirection()
                if direction != currentDirection {
                    currentDirection = direction
                    switch direction {
                    case .up:
                        currentSprites = self.NPCupSprites
                    case .down:
                        currentSprites = self.NPCdownSprites
                    case .left:
                        currentSprites = self.NPCleftSprites
                    case .right:
                        currentSprites = self.NPCrightSprites
                    }
                    
                    animalImageView.animationImages = currentSprites
                    animalImageView.animationDuration = spriteChangeInterval * Double(currentSprites.count)
                    animalImageView.startAnimating()
                }
                
                let speed: CGFloat = 20.0 //Distancia que se mueve en cada intervalo
                var newFrame = animalImageView.frame
                
                switch direction {
                case .up:
                    newFrame.origin.y -= speed
                case .down:
                    newFrame.origin.y += speed
                case .left:
                    newFrame.origin.x -= speed
                case .right:
                    newFrame.origin.x += speed
                }
                
                //no salir de limites
                newFrame.origin.x = max(0, min(self.scrollView.bounds.width - animalSize, newFrame.origin.x))
                newFrame.origin.y = max(0, min(self.scrollView.bounds.height - animalSize, newFrame.origin.y))
                
                //Animar el movimiento
                UIView.animate(withDuration: movementInterval) {
                    animalImageView.frame = newFrame
                }
            }
        }
    }
    
    func randomDirection() -> Direction {
        let directions: [Direction] = [.up, .down, .left, .right]
        return directions.randomElement()!
    }
    
    //NPC
    //Animal
    
    //ENEMIGOS
    //FOLLOWERS
    func setupFollower() {
        let followerSize: CGFloat = 30.0
        
        let followerView = UIView(frame: CGRect(x: 0, y: 0, width: followerSize, height: followerSize))
        followerView.backgroundColor = .red
        scrollView.addSubview(followerView)
        
        let followInterval: TimeInterval = 0.1
        
        Timer.scheduledTimer(withTimeInterval: followInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            //se obteniene la posicion actual del jugador
            let playerPosition = self.getPlayerPosition()
            
            // pathfinding simple
            let directionX = playerPosition.x - followerView.frame.origin.x
            let directionY = playerPosition.y - followerView.frame.origin.y
            
            //Normalizar el vector de direccion
            let magnitude = sqrt(directionX * directionX + directionY * directionY)
            let normalizedDirectionX = directionX / magnitude
            let normalizedDirectionY = directionY / magnitude
            
            //Mover el seguidor en la direccion calculada
            let speed: CGFloat = 2.0 // Velocidad del seguidor
            followerView.frame.origin.x += normalizedDirectionX * speed
            followerView.frame.origin.y += normalizedDirectionY * speed
        }
    }
    
    func getPlayerPosition() -> CGPoint {
        //Retorna la posicion actual del jugador
        
        //logica para obetener posicion jugador (Faltante)
        return CGPoint(x: 100, y: 100)
    }
    
    
    
    
    //FOLLOWERS
    
    //Pasto y sombra
    
    
    //LAGOS
    //LAGOS
    //Array de imágenes de lagos para el efecto de agua
    let lakeSprites: [UIImage] = [
        UIImage(named: "water1")!,
        UIImage(named: "water2")!,
        UIImage(named: "water3")!
    ]
    
    var lakeSpriteSpeed: TimeInterval = 0.3 //Velocidad de cambio de sprite para los lagos
    var lakeImageViews: [UIImageView] = [] //Array para almacenar las vistas de imagen de los lagos
    
    
    
    func setupLakes() {
        let lakeSize = CGSize(width: 80, height: 60)
        let protectionRadius: CGFloat = 30.0
        let numberOfLakes = max(1, Int(scrollLimitX / 100)) // Ajusta el número de lagos según el área en X disponible
        
        for _ in 0..<numberOfLakes {
            var lakeFrame: CGRect
            var positionIsValid: Bool
            
            repeat {
                let randomX = CGFloat.random(in: 0...(scrollLimitX - lakeSize.width))
                let randomY = CGFloat.random(in: 0...(scrollView.bounds.height - lakeSize.height))
                lakeFrame = CGRect(x: randomX, y: randomY, width: lakeSize.width, height: lakeSize.height)
                
                // Verificar si el lago se superpone con otros elementos ya colocados
                positionIsValid = !placedElements.contains { elementFrame in
                    let protectedArea = elementFrame.insetBy(dx: -protectionRadius, dy: -protectionRadius)
                    return protectedArea.intersects(lakeFrame)
                }
                
            } while !positionIsValid
            
            let lakeImageView = UIImageView(frame: lakeFrame)
            lakeImageView.image = lakeSprites[0]
            scrollView.addSubview(lakeImageView)
            
            placedElements.append(lakeFrame)
            lakeImageViews.append(lakeImageView)
        }
    }
    
    
    func startLakeAnimation() {
        Timer.scheduledTimer(timeInterval: lakeSpriteSpeed, target: self, selector: #selector(updateLakeSprites), userInfo: nil, repeats: true)
    }
    
    @objc func updateLakeSprites() {
        for lakeImageView in lakeImageViews {
            let currentSprite = lakeSprites.randomElement()!
            lakeImageView.image = currentSprite
        }
    }
    //LAGOS
    //LAGOS
    
    
    
    
    
    //RESET GAME
    //RESET GAME
    
    func resetParticles() {
        // Invalidate the particle timer
        particleTimer?.invalidate()
        particleTimer = nil
        
        // Remove all existing leaves
        self.view.subviews.forEach { subview in
            if let imageView = subview as? UIImageView, leafImages.contains(imageView.image!) {
                imageView.removeFromSuperview()
            }
        }
    
        
    }
    
}
