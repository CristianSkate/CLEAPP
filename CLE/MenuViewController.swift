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
    let menuOps:[String] = ["Home","Mis Encuestas","Misión","Organica","Doctrina","Mis Datos","Salir", "Acerca de"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 215.0/255.0, green: 23.0/255.0, blue: 41.0/255.0, alpha: 1.0)
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
            let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MisEncuestasViewController") as! MisEncuestasViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break
        case 2:
            //Misión
            let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MisionViewController") as! MisionViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break
        case 3:
            //Orgánica
            let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("OrganicaViewController") as! OrganicaViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break
        case 4:
            //Doctrina
            let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DoctrinaViewController") as! DoctrinaViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break
        case 5:
            //Mis Datos
            let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MisDatosViewController") as! MisDatosViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break
        case 6:
            //Cerrar Sesion
            let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InicioViewController") as! InicioViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            //Elimina Variable de sesion
            let appDomain = NSBundle.mainBundle().bundleIdentifier
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
            //Hacer el cambio de pantalla
            appDelegate.centerContainer!.centerViewController =  centerNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
        case 7:
            //Acerca de
            
            let alertController = UIAlertController(title: "Acerca de ...", message: "Esta aplicacion fue programada por Cristian Martínez y Elias Millachine\nVersión 1.0", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
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
