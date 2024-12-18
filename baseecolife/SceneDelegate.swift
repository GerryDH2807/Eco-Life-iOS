//
//  SceneDelegate.swift
//  baseecolife
//
//  Created by Administrador on 02/09/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    
    
    class SceneDelegate: UIResponder, UIWindowSceneDelegate, UITabBarControllerDelegate { // Agrega UITabBarControllerDelegate

        var window: UIWindow?

        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            
            // Configura el Tab Bar Controller
            let tabBarController = UITabBarController()
            tabBarController.delegate = self // Asigna el delegado al SceneDelegate
            
            // Pestaña Home
            let homeVC = UIViewController()
            homeVC.view.backgroundColor = .white
            homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
            
            // Pestaña Juego (GameViewController)
            let gameVC = ScrollingViewController() // Tu controlador de juego
            gameVC.tabBarItem = UITabBarItem(title: "Juego", image: UIImage(systemName: "gamecontroller"), tag: 1)
            
            // Configurar las pestañas del Tab Bar Controller
            tabBarController.viewControllers = [homeVC, gameVC]
            
            // Configura la ventana principal con el Tab Bar Controller
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = tabBarController
            self.window = window
            window.makeKeyAndVisible()
        }
        
        

        
        func sceneDidDisconnect(_ scene: UIScene) {
            // Called as the scene is being released by the system.
            // This occurs shortly after the scene enters the background, or when its session is discarded.
            // Release any resources associated with this scene that can be re-created the next time the scene connects.
            // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        }
        
        func sceneDidBecomeActive(_ scene: UIScene) {
            // Called when the scene has moved from an inactive state to an active state.
            // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        }
        
        func sceneWillResignActive(_ scene: UIScene) {
            // Called when the scene will move from an active state to an inactive state.
            // This may occur due to temporary interruptions (ex. an incoming phone call).
        }
        
        func sceneWillEnterForeground(_ scene: UIScene) {
            // Called as the scene transitions from the background to the foreground.
            // Use this method to undo the changes made on entering the background.
        }
        
        func sceneDidEnterBackground(_ scene: UIScene) {
            // Called as the scene transitions from the foreground to the background.
            // Use this method to save data, release shared resources, and store enough scene-specific state information
            // to restore the scene back to its current state.
        }
    
}


// Implementa el delegado del Tab Bar
   func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       // Detectar si el usuario está en el juego
       if let gameVC = tabBarController.viewControllers?[1] as? ScrollingViewController,
          tabBarController.selectedViewController == gameVC, // Verificar que está en el juego
          viewController != gameVC { // Verificar que intenta cambiar de pestaña
           // Finalizar el juego
           gameVC.endGame(reason: "Se entró a otro menú")
           return false // Evitar el cambio de pestaña inmediatamente
       }
       return true // Permitir el cambio de pestaña
   }
}

