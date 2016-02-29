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
    let menuOps:[String] = ["Home","Mis Encuestas","Mis Evaluadores","Misión","Orgánica","Doctrina","Herramientas","Acerca de", "Cerrar Sesión"]
    let imgMenu:[UIImage] = [UIImage(named: "ic_home")!,UIImage(named: "ic_supervisor_account_black_48dp")!,UIImage(named: "ic_supervisor_account_black_48dp")!,UIImage(named: "ic_thumb_up_black_48dp")!,UIImage(named: "ic_domain_black_48dp")!,UIImage(named: "ic_school_black_48dp")!,UIImage(named: "ic_settings_black_48dp")!,UIImage(named: "ic_action_about")!,UIImage(named: "ic_lock_power_off")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.view.backgroundColor = UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Black
        imgLogo.image = UIImage(named: "Logo")
        tblMenu.delegate = self
        tblMenu.dataSource =  self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOps.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mycell = tableView.dequeueReusableCellWithIdentifier("celdaMenu", forIndexPath: indexPath) as! CeldaMenuTableViewCell
        
        mycell.txtTituloOp.text = menuOps[indexPath.row]
        mycell.imgMenu.image =  imgMenu[indexPath.row]
        
        return mycell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch(indexPath.row){
        case 0:
            //Home
            let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InicioViewController") as! InicioViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
            
        case 1:
            //Mis Encuestas
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            // generamos una constante de tipo int leyendo de NSUserDefaults ISLOGGEDIN
            let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
            
            // si no está logeado, envía a la vista de login, sino muestra el nombre de usuario, leido de la caché
            if (isLoggedIn != 1) {
                
                self.performSegueWithIdentifier("irALogin", sender: self)
            } else {
                let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MisEncuestasViewController") as! MisEncuestasViewController
                let centerNavController = UINavigationController(rootViewController: centerViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.centerContainer!.centerViewController =  centerNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            }
            
            break
        case 2:
            //MisEvaluadores
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            // generamos una constante de tipo int leyendo de NSUserDefaults ISLOGGEDIN
            let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
            
            // si no está logeado, envía a la vista de login, sino muestra el nombre de usuario, leido de la caché
            if (isLoggedIn != 1) {
                
                self.performSegueWithIdentifier("irALogin", sender: self)
            } else {
                let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MisEvaluadoresViewController") as! MisEvaluadoresViewController
                let centerNavController = UINavigationController(rootViewController: centerViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.centerContainer!.centerViewController =  centerNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            }
            break
            
            //break
        case 3:
            
            //Misión
            let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MisionViewController") as! MisionViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break
        case 4:
            //Orgánica
            let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("OrganicaViewController") as! OrganicaViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break
        case 5:
            //Doctrina
            let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DoctrinaViewController") as! DoctrinaViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break
        case 6:
            //Herramientas
            let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HerramientasViewController") as! HerramientasViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break
        case 7:
            //Acerca de
            
            let alertController = UIAlertController(title: "Acerca de ...", message: "Esta aplicacion fue programada por Cristian Martínez y Elias Millachine\nVersión 1.0", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            break
        case 8:
            //Cerrar Sesion
            //Elimina Variable de sesion
            
                let alertController = UIAlertController(title: "Confirmación", message: "Al cerrar sesión eliminará todo el progreso en las encuestas que no haya enviado a nuestra base de datos", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Si", style: .Default, handler: {(alert: UIAlertAction) in
                    //Accion del boton si
                    let appDomain = NSBundle.mainBundle().bundleIdentifier
                    NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
                    //Hacer el cambio de pantalla
                    //creamos un objeto de tipo NSUserDefaults prefs (caché) que guardará si el usuario está logueado o no
                    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    // generamos una constante de tipo int leyendo de NSUserDefaults ISLOGGEDIN
                    let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
                    // si no está logeado, envía a la vista de login, sino muestra el nombre de usuario, leido de la caché
                    if (isLoggedIn != 1) {
                        self.performSegueWithIdentifier("irALogin", sender: self)
                    }
                }))
                alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
                self.presentViewController((alertController), animated: true, completion: nil)
                
            
            
            
            break
            
        default:
            let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InicioViewController") as! InicioViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
            
        }
        
        
        tblMenu.deselectRowAtIndexPath(indexPath, animated: true)
        
    }

    

}
