//
//  MenuViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 06-10-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //@IBOutlet weak var tblMenu: UITableView!
    @IBOutlet var tblMenu: UITableView!
    @IBOutlet weak var imgLogo: UIImageView!
    var menuOps:[String] = ["Inicio"        //0
        ,"MML"                              //1
//        ,"Mis Evaluados"                    //2
//        ,"Mis Evaluaciones"                 //3
        ,"CLE"                              //4
//        ,"Misión"                           //5
//        ,"Orgánica"                         //6
//        ,"Doctrina"                         //7
//        ,"Artículos"                        //8
//        ,"Noticias"                         //9
//        ,"Fortalécete"                      //10
//        ,"Fortalece tu Unidad"              //11
        ,"Ayuda"                            //12
//        ,"Preguntas Frecuentes"             //13
//        ,"Videos Tutoriales"                //14
//        ,"Instructivo"                      //15
        ,"Configuración"                    //16
//        ,"Acerca de"                        //17
    //    ,"Cerrar Sesión"
    ]                   //18
    
    var imgMenu:[UIImage] = [UIImage(named: "ic_home")! //Inicio
        ,UIImage(named: "ic_supervisor_account_black_48dp")! // MML
//        ,UIImage(named: "ic_supervisor_account_black_48dp")! // Mis Evaluados
//        ,UIImage(named: "ic_supervisor_account_black_48dp")! // Mis Evaluaciones
        ,UIImage(named: "ic_domain_black_48dp")! // CLE
//        ,UIImage(named: "ic_thumb_up_black_48dp")! //Mision
//        ,UIImage(named: "ic_domain_black_48dp")! // Organica
//        ,UIImage(named: "ic_school_black_48dp")! // Doctrina
//        ,UIImage(named: "ic_note_48pt")! // Articulos
//        ,UIImage(named: "ic_chrome_reader_mode_48pt")! // Noticias
//        ,UIImage(named: "ic_accessibility_48pt")! // Fortalecete
//        ,UIImage(named: "ic_supervisor_account_black_48dp")! // Fortalece tu unidad
        ,UIImage(named: "ic_action_about")! // Ayuda
//        ,UIImage(named: "ic_question_answer_48pt")! // Preguntas Frecuentes
//        ,UIImage(named: "ic_video_library_48pt")! // Videos Tutoriales
//        ,UIImage(named: "ic_insert_drive_file_48pt")! // Instructivo
        ,UIImage(named: "ic_settings_black_48dp")! // Configuracion
//        ,UIImage(named: "ic_person_pin_black_48dp")! // Acerca de
        //,UIImage(named: "ic_lock_power_off")!
    ] // Cerrar Sesion
    
    var vez = 0
    var mmlExp = 0
    var cleExp = 0
    var ayudaExp = 0
    var confExp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 128.0/255.0, green: 80.0/255.0, blue: 04.0/255.0, alpha: 1.0)
        self.view.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barStyle = .black
        imgLogo.image = UIImage(named: "Logo")
        tblMenu.delegate = self
        tblMenu.dataSource =  self
        
//        let prefs:UserDefaults = UserDefaults.standard
//        // generamos una constante de tipo int leyendo de NSUserDefaults ISLOGGEDIN
//        let isLoggedIn:Int = prefs.integer(forKey: "ISLOGGEDIN") as Int
//        
//        // si está logueado agrega cerrar sesion al final, si no se asegura que no esté
//        if (isLoggedIn != 1) {
//            if menuOps[menuOps.count - 1] == "Cerrar Sesión"{
//                
//                menuOps.removeLast()
//                imgMenu.removeLast()
//                self.tblMenu.beginUpdates()
//                self.tblMenu.deleteRows(at: [IndexPath.init(row: menuOps.count, section: 0)] , with: .automatic)
//                self.tblMenu.endUpdates()
//            }
//            
//        } else {
//            
//            menuOps.append("Cerrar Sesión")
//            //imgMenu.insert(UIImage(named: "ic_supervisor_account_black_48dp")!, at: indexPath.row + 1)
//            imgMenu.append(UIImage(named: "ic_lock_power_off")!)
//            self.tblMenu.beginUpdates()
//            self.tblMenu.insertRows(at: [IndexPath.init(row: menuOps.count - 1 , section: 0)], with: .automatic)
//            self.tblMenu.endUpdates()
//            
//        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("paso")
        
        let prefs:UserDefaults = UserDefaults.standard
        // generamos una constante de tipo int leyendo de NSUserDefaults ISLOGGEDIN
        let isLoggedIn:Int = prefs.integer(forKey: "ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            if menuOps[menuOps.count - 1] == "Cerrar Sesión"{
                
                menuOps.removeLast()
                imgMenu.removeLast()
                self.tblMenu.beginUpdates()
                self.tblMenu.deleteRows(at: [IndexPath.init(row: menuOps.count, section: 0)] , with: .automatic)
                self.tblMenu.endUpdates()
            }
            
        } else {
            
            if menuOps[menuOps.count - 1] == "Cerrar Sesión" {
                
            } else {
            
            menuOps.append("Cerrar Sesión")
            //imgMenu.insert(UIImage(named: "ic_supervisor_account_black_48dp")!, at: indexPath.row + 1)
            imgMenu.append(UIImage(named: "ic_lock_power_off")!)
            self.tblMenu.beginUpdates()
            self.tblMenu.insertRows(at: [IndexPath.init(row: menuOps.count - 1 , section: 0)], with: .automatic)
            self.tblMenu.endUpdates()
            }
        }

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
        
        
        //switch((indexPath as NSIndexPath).row){
        switch(menuOps[(indexPath as NSIndexPath).row]){
        case "Inicio":
            //Home
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "InicioViewController") as! InicioViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            
            break
        case "MML":
            //MML
            
            if mmlExp == 0{
                
                
                menuOps.insert("Mis Evaluados", at: indexPath.row + 1)
                //imgMenu.insert(UIImage(named: "ic_supervisor_account_black_48dp")!, at: indexPath.row + 1)
                imgMenu.insert(UIImage(), at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.insertRows(at: [IndexPath.init(row: indexPath.row + 1 , section: 0)], with: .automatic)
                self.tblMenu.endUpdates()
                
                menuOps.insert("Mis Evaluaciones", at: indexPath.row + 1)
//                imgMenu.insert(UIImage(named: "ic_supervisor_account_black_48dp")!, at: indexPath.row + 1)
                imgMenu.insert(UIImage(), at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.insertRows(at: [IndexPath.init(row: indexPath.row + 1 , section: 0)], with: .automatic)
                self.tblMenu.endUpdates()
                mmlExp = 1
                
            }
            else{
                menuOps.remove(at: indexPath.row + 1)
                imgMenu.remove(at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.deleteRows(at: [IndexPath.init(row: indexPath.row + 1, section: 0)] , with: .automatic)
                self.tblMenu.endUpdates()
                menuOps.remove(at: indexPath.row + 1)
                imgMenu.remove(at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.deleteRows(at: [IndexPath.init(row: indexPath.row + 1, section: 0)] , with: .automatic)
                self.tblMenu.endUpdates()

                mmlExp = 0
            }
            
            
            break
        case "Mis Evaluados":
            //Mis Evaluados
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
        case "Mis Evaluaciones":
            //Mis Evaluaciones
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
        case "CLE":
            //CLE
            
            if cleExp == 0{
                
                menuOps.insert("Fortalece tu Unidad", at: indexPath.row + 1)
                //imgMenu.insert(UIImage(named: "ic_supervisor_account_black_48dp")!, at: indexPath.row + 1)
                imgMenu.insert(UIImage(), at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.insertRows(at: [IndexPath.init(row: indexPath.row + 1 , section: 0)], with: .automatic)
                self.tblMenu.endUpdates()
                
                menuOps.insert("Fortalécete", at: indexPath.row + 1)
                //imgMenu.insert(UIImage(named: "ic_accessibility_48pt")!, at: indexPath.row + 1)
                imgMenu.insert(UIImage(), at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.insertRows(at: [IndexPath.init(row: indexPath.row + 1 , section: 0)], with: .automatic)
                self.tblMenu.endUpdates()
                
                menuOps.insert("Noticias", at: indexPath.row + 1)
                //imgMenu.insert(UIImage(named: "ic_chrome_reader_mode_48pt")!, at: indexPath.row + 1)
                imgMenu.insert(UIImage(), at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.insertRows(at: [IndexPath.init(row: indexPath.row + 1 , section: 0)], with: .automatic)
                self.tblMenu.endUpdates()
                
                menuOps.insert("Artículos", at: indexPath.row + 1)
                //imgMenu.insert(UIImage(named: "ic_note_48pt")!, at: indexPath.row + 1)
                imgMenu.insert(UIImage(), at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.insertRows(at: [IndexPath.init(row: indexPath.row + 1 , section: 0)], with: .automatic)
                self.tblMenu.endUpdates()
                
                menuOps.insert("Doctrina", at: indexPath.row + 1)
                //imgMenu.insert(UIImage(named: "ic_school_black_48dp")!, at: indexPath.row + 1)
                imgMenu.insert(UIImage(), at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.insertRows(at: [IndexPath.init(row: indexPath.row + 1 , section: 0)], with: .automatic)
                self.tblMenu.endUpdates()
                
                menuOps.insert("Orgánica", at: indexPath.row + 1)
                //imgMenu.insert(UIImage(named: "ic_domain_black_48dp")!, at: indexPath.row + 1)
                imgMenu.insert(UIImage(), at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.insertRows(at: [IndexPath.init(row: indexPath.row + 1 , section: 0)], with: .automatic)
                self.tblMenu.endUpdates()
                
                menuOps.insert("Misión", at: indexPath.row + 1)
                //imgMenu.insert(UIImage(named: "ic_thumb_up_black_48dp")!, at: indexPath.row + 1)
                imgMenu.insert(UIImage(), at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.insertRows(at: [IndexPath.init(row: indexPath.row + 1 , section: 0)], with: .automatic)
                self.tblMenu.endUpdates()
                
                cleExp = 1
            }else{
                
                menuOps.remove(at: indexPath.row + 1)
                imgMenu.remove(at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.deleteRows(at: [IndexPath.init(row: indexPath.row + 1, section: 0)] , with: .automatic)
                self.tblMenu.endUpdates()
                menuOps.remove(at: indexPath.row + 1)
                imgMenu.remove(at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.deleteRows(at: [IndexPath.init(row: indexPath.row + 1, section: 0)] , with: .automatic)
                self.tblMenu.endUpdates()
                menuOps.remove(at: indexPath.row + 1)
                imgMenu.remove(at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.deleteRows(at: [IndexPath.init(row: indexPath.row + 1, section: 0)] , with: .automatic)
                self.tblMenu.endUpdates()
                menuOps.remove(at: indexPath.row + 1)
                imgMenu.remove(at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.deleteRows(at: [IndexPath.init(row: indexPath.row + 1, section: 0)] , with: .automatic)
                self.tblMenu.endUpdates()
                menuOps.remove(at: indexPath.row + 1)
                imgMenu.remove(at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.deleteRows(at: [IndexPath.init(row: indexPath.row + 1, section: 0)] , with: .automatic)
                self.tblMenu.endUpdates()
                menuOps.remove(at: indexPath.row + 1)
                imgMenu.remove(at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.deleteRows(at: [IndexPath.init(row: indexPath.row + 1, section: 0)] , with: .automatic)
                self.tblMenu.endUpdates()
                menuOps.remove(at: indexPath.row + 1)
                imgMenu.remove(at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.deleteRows(at: [IndexPath.init(row: indexPath.row + 1, section: 0)] , with: .automatic)
                self.tblMenu.endUpdates()
                
                cleExp = 0
            }
            
            //tblMenu.reloadData()
            break
        case "Misión":
            //Misión
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "MisionViewController") as! MisionViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break
        case "Orgánica":
            //Orgánica
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "OrganicaViewController") as! OrganicaViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break
        case "Doctrina":
            //Doctrina
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "DoctrinaViewController") as! DoctrinaViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break

            
        case "Articulos":
            //Articulos
            break
        case "Noticias":
            //Noticias
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "InicioViewController") as! InicioViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break
        case "Fortalécete":
            //Fortalecete
            
            UIApplication.shared.openURL(URL(string: "https://cle.ejercito.cl/web/fortalecete.aspx")!)
            
            break
        case "Fortalece tu Unidad":
            //Fortalece tu unidad
            
            UIApplication.shared.openURL(URL(string: "https://cle.ejercito.cl/Cursos.aspx")!)
            
            break
        case "Ayuda":
            //Ayuda
            
            if ayudaExp == 0 {
                
                menuOps.insert("reguntas Frecuentes", at: indexPath.row + 1)
                //imgMenu.insert(UIImage(named: "ic_question_answer_48pt")!, at: indexPath.row + 1)
                imgMenu.insert(UIImage(), at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.insertRows(at: [IndexPath.init(row: indexPath.row + 1 , section: 0)], with: .automatic)
                self.tblMenu.endUpdates()

                menuOps.insert("Videos Tutoriales", at: indexPath.row + 1)
                //imgMenu.insert(UIImage(named: "ic_video_library_48pt")!, at: indexPath.row + 1)
                imgMenu.insert(UIImage(), at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.insertRows(at: [IndexPath.init(row: indexPath.row + 1 , section: 0)], with: .automatic)
                self.tblMenu.endUpdates()

                menuOps.insert("Instructivo", at: indexPath.row + 1)
                //imgMenu.insert(UIImage(named: "ic_insert_drive_file_48pt")!, at: indexPath.row + 1)
                imgMenu.insert(UIImage(), at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.insertRows(at: [IndexPath.init(row: indexPath.row + 1 , section: 0)], with: .automatic)
                self.tblMenu.endUpdates()

                ayudaExp = 1
                
            }else{
                
                menuOps.remove(at: indexPath.row + 1)
                imgMenu.remove(at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.deleteRows(at: [IndexPath.init(row: indexPath.row + 1, section: 0)] , with: .automatic)
                self.tblMenu.endUpdates()
                menuOps.remove(at: indexPath.row + 1)
                imgMenu.remove(at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.deleteRows(at: [IndexPath.init(row: indexPath.row + 1, section: 0)] , with: .automatic)
                self.tblMenu.endUpdates()
                menuOps.remove(at: indexPath.row + 1)
                imgMenu.remove(at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.deleteRows(at: [IndexPath.init(row: indexPath.row + 1, section: 0)] , with: .automatic)
                self.tblMenu.endUpdates()
                
                ayudaExp = 0
                
            }
            
            break
        case "Preguntas Frecuentes":
            //Preguntas Frecuentes
            
            break
        case "Videos Tutoriales":
            //Videos Tutoriales
            
            break
        case "Instructivo":
            //Instructivo
            
            break
        case "Configuración":
            //Configuración
            
            if confExp == 0 {
                
                menuOps.insert("Acerca de", at: indexPath.row + 1)
                //imgMenu.insert(UIImage(named: "ic_person_pin_black_48dp")!, at: indexPath.row + 1)
                imgMenu.insert(UIImage(), at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.insertRows(at: [IndexPath.init(row: indexPath.row + 1 , section: 0)], with: .automatic)
                self.tblMenu.endUpdates()
                
                confExp = 1
            }
            else {
                
                menuOps.remove(at: indexPath.row + 1)
                imgMenu.remove(at: indexPath.row + 1)
                self.tblMenu.beginUpdates()
                self.tblMenu.deleteRows(at: [IndexPath.init(row: indexPath.row + 1, section: 0)] , with: .automatic)
                self.tblMenu.endUpdates()
                
                confExp = 0
            }
            
            break
        case "Acerca de":
            //Acerca de
            
            let alertController = UIAlertController(title: "Acerca de ...", message: "Esta aplicacion fue desarrollada a medida para el Ejército de Chile por CMT y Mprz\ncmartinezt.91@gmail.com\nVersión 1.0", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            break
        case "Cerrar Sesión":
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
                        if self.menuOps[self.menuOps.count - 1] == "Cerrar Sesión"{
                            
                            self.menuOps.removeLast()
                            self.imgMenu.removeLast()
                            self.tblMenu.beginUpdates()
                            self.tblMenu.deleteRows(at: [IndexPath.init(row: self.menuOps.count, section: 0)] , with: .automatic)
                            self.tblMenu.endUpdates()
                        }
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

    //        case 6:
    //            //Herramientas
    //            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "HerramientasViewController") as! HerramientasViewController
    //            let centerNavController = UINavigationController(rootViewController: centerViewController)
    //            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    //
    //            appDelegate.centerContainer!.centerViewController =  centerNavController
    //            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    //            break

}
