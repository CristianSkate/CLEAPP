//
//  InicioViewController.swift
//  Centro de Liderazgo Ejercito de Chile
//
//  Created by Cristian Martinez Toledo on 30-09-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class InicioViewController: UIViewController {

    @IBOutlet weak var txtMensaje: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Inicio"
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 215.0/255.0, green: 23.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Black
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(animated: Bool) {
        
        // creamos un objeto de tipo NSUserDefaults prefs (caché) que guardará si el usuario está logueado o no
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        // generamos una constante de tipo int leyendo de NSUserDefaults ISLOGGEDIN
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        
        // si no está logeado, envía a la vista de login, sino muestra el nombre de usuario, leido de la caché
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("irALogin", sender: self)
        } else {
            let mensaje = "Bienvenido " + (prefs.valueForKey("NOMBRE") as? String)! + " " + (prefs.valueForKey("APELLIDOPATERNO") as? String)! + " " + (prefs.valueForKey("APELLIDOMATERNO") as? String)! + " estamos trabajando para usted"
            self.txtMensaje.text =  mensaje
        }
        
    }
    // La función cerrar borrar todos los datos de la caché y devuelve al login
    
    @IBAction func cerrar(sender: UIButton) {
        
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("irALogin", sender: self)
        
    }

}
