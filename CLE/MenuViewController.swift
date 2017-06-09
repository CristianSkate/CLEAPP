//
//  MenuViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 06-10-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var imgLogo: UIImageView!
    let menuOps:[String] = ["Inicio"
        ,"MML"
        ,"Mis Evaluados"
        ,"Mis Evaluaciones"
        ,"CLE"
        ,"Misión"
        ,"Orgánica"
        ,"Doctrina"
        ,"Artículos"
        ,"Noticias"
        ,"Fortalécete"
        ,"Fortalece tu Unidad"
        ,"Ayuda"
        ,"Preguntas Frecuentes"
        ,"Videos Tutoriales"
        ,"Instructivo"
        ,"Configuracion"
        ,"Acerca de"
        ,"Cerrar Sesión"]
    
    let imgMenu:[UIImage] = [UIImage(named: "ic_home")! //Inicio
        ,UIImage() // MML
        ,UIImage(named: "ic_supervisor_account_black_48dp")! // Mis Evaluados
        ,UIImage(named: "ic_supervisor_account_black_48dp")! // Mis Evaluaciones
        ,UIImage() // CLE
        ,UIImage(named: "ic_thumb_up_black_48dp")! //Mision
        ,UIImage(named: "ic_domain_black_48dp")! // Organica
        ,UIImage(named: "ic_school_black_48dp")! // Doctrina
        ,UIImage(named: "ic_note_48pt")! // Articulos
        ,UIImage(named: "ic_chrome_reader_mode_48pt")! // Noticias
        ,UIImage(named: "ic_accessibility_48pt")! // Fortalecete
        ,UIImage(named: "ic_supervisor_account_black_48dp")! // Fortalece tu unidad
        ,UIImage() // Ayuda
        ,UIImage(named: "ic_question_answer_48pt")! // Preguntas Frecuentes
        ,UIImage(named: "ic_video_library_48pt")! // Videos Tutoriales
        ,UIImage(named: "ic_insert_drive_file_48pt")! // Instructivo
        ,UIImage() // Configuracion
        ,UIImage(named: "ic_person_pin_black_48dp")! // Acerca de
        ,UIImage(named: "ic_lock_power_off")!] // Cerrar Sesion
    
    var vez = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        //self.view.backgroundColor = UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 128.0/255.0, green: 80.0/255.0, blue: 04.0/255.0, alpha: 1.0)
        self.view.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barStyle = .black
        imgLogo.image = UIImage(named: "Logo")
        tblMenu.delegate = self
        tblMenu.dataSource =  self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mycell = tableView.dequeueReusableCell(withIdentifier: "celdaMenu", for: indexPath) as! CeldaMenuTableViewCell
        
        
            mycell.txtTituloOp.text = menuOps[indexPath.row]
            mycell.imgMenu.image =  imgMenu[indexPath.row]
       
//    if menuOps[indexPath.row] == "MML" || menuOps[indexPath.row] == "CLE" || menuOps[indexPath.row] == "Ayuda" || menuOps[indexPath.row] == "Configuración" {
//    
//            let border = CALayer()
//            let width = CGFloat(2.0)
//            border.borderColor = UIColor.lightGray.cgColor
//            border.frame = CGRect(x: 0, y: width - mycell.frame.size.height, width: mycell.frame.size.width, height: mycell.frame.size.height)
//            
//            border.borderWidth = width
//            mycell.layer.addSublayer(border)
//            mycell.layer.masksToBounds = true
//        
//            //mycell.imgMenu.removeFromSuperview()
//            mycell.txtTituloOp.text = "  " + menuOps[(indexPath as NSIndexPath).row]
//      
//    }
        
        return mycell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch((indexPath as NSIndexPath).row){
        case 0:
            //Home
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "InicioViewController") as! InicioViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            
            break
            
        case 2:
            //Mis Encuestas
            let prefs:UserDefaults = UserDefaults.standard
            // generamos una constante de tipo int leyendo de NSUserDefaults ISLOGGEDIN
            let isLoggedIn:Int = prefs.integer(forKey: "ISLOGGEDIN") as Int
            
            // si no está logeado, envía a la vista de login, sino muestra el nombre de usuario, leido de la caché
            if (isLoggedIn != 1) {
                
                self.performSegue(withIdentifier: "irALogin", sender: self)
            } else {
                let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "MisEncuestasViewController") as! MisEncuestasViewController
                let centerNavController = UINavigationController(rootViewController: centerViewController)
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                appDelegate.centerContainer!.centerViewController =  centerNavController
                appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            }
            
            break
        case 3:
            //MisEvaluadores
            let prefs:UserDefaults = UserDefaults.standard
            // generamos una constante de tipo int leyendo de NSUserDefaults ISLOGGEDIN
            let isLoggedIn:Int = prefs.integer(forKey: "ISLOGGEDIN") as Int
            
            // si no está logeado, envía a la vista de login, sino muestra el nombre de usuario, leido de la caché
            if (isLoggedIn != 1) {
                
                self.performSegue(withIdentifier: "irALogin", sender: self)
            } else {
                let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "MisEvaluadoresViewController") as! MisEvaluadoresViewController
                let centerNavController = UINavigationController(rootViewController: centerViewController)
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.centerContainer!.centerViewController =  centerNavController
                appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            }
            break
            
            //break
        case 5:
            
            //Misión
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "MisionViewController") as! MisionViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break
        case 6:
            //Orgánica
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "OrganicaViewController") as! OrganicaViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break
        case 7:
            //Doctrina
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "DoctrinaViewController") as! DoctrinaViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break
        case 6:
            //Herramientas
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "HerramientasViewController") as! HerramientasViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break
        case 17:
            //Acerca de
            
            let alertController = UIAlertController(title: "Acerca de ...", message: "Esta aplicacion fue desarrollada a medida para el Ejército de Chile por CMT y Mprz\ncmartinezt.91@gmail.com\nVersión 1.0", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            break
        case 18:
            //Cerrar Sesion
            //Elimina Variable de sesion
            
                let alertController = UIAlertController(title: "Confirmación", message: "Al cerrar sesión eliminará todo el progreso en las encuestas que no haya enviado a nuestra base de datos", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Si", style: .default, handler: {(alert: UIAlertAction) in
                    //Accion del boton si
                    let appDomain = Bundle.main.bundleIdentifier
                    UserDefaults.standard.removePersistentDomain(forName: appDomain!)
                    //Hacer el cambio de pantalla
                    //creamos un objeto de tipo NSUserDefaults prefs (caché) que guardará si el usuario está logueado o no
                    let prefs:UserDefaults = UserDefaults.standard
                    // generamos una constante de tipo int leyendo de NSUserDefaults ISLOGGEDIN
                    let isLoggedIn:Int = prefs.integer(forKey: "ISLOGGEDIN") as Int
                    // si no está logeado, envía a la vista de login, sino muestra el nombre de usuario, leido de la caché
                    if (isLoggedIn != 1) {
                        self.performSegue(withIdentifier: "irALogin", sender: self)
                    }
                }))
                alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                self.present((alertController), animated: true, completion: nil)
                
            
            
            
            break
            
        default:
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "InicioViewController") as! InicioViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            
            break
            
        }
        
        
        
        tblMenu.deselectRow(at: indexPath, animated: true)
        
    }

    

}
