//
//  BuscarEncuestadoresViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 28-12-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class MisEvaluadoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate {

    
    @IBOutlet weak var tblSeleccion: UITableView!
    
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var seleccion:[Evaluador] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Mis evaluadores"
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Black

        var image = UIImage(named: "Menu")
        
        tblSeleccion.delegate = self
        tblSeleccion.dataSource = self
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "btnMenu:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "btnBuscar:")
        
        //Mostrar evaluadores de las preferencias
        cargarDatosPrevios()
        
        // Do any additional setup after loading the view.
    }
    
    func cargarDatosPrevios() {
        let encuestadores = self.prefs.objectForKey("seleccionados") as? NSData
        
        if let encuestadores = encuestadores {
            self.seleccion = (NSKeyedUnarchiver.unarchiveObjectWithData(encuestadores) as? [Evaluador])!
            
        }
    }

    
    override func viewDidAppear(animated: Bool) {
        print("paso")
        cargarDatosPrevios()
        self.tblSeleccion.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnMenu(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    @IBAction func btnBuscar(sender: AnyObject) {
        
        self.performSegueWithIdentifier("BuscarEvaluadores", sender: nil)
        
    }
    
    @IBAction func btnFinalizar(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Confirmación", message: "Luego de confirmar la selección no se podrán realizar cambios\n¿Desea confirmar la selección?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Si", style: .Default, handler: {(alert: UIAlertAction) in
            
            print("Se envía la seleccion a la base de datos")
            
            }))
        alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seleccion.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let mycell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("celdaEvaluadores", forIndexPath: indexPath)
        
        mycell.textLabel?.text = ("\(seleccion[indexPath.row].nombre)\n\(seleccion[indexPath.row].rut)")
        mycell.textLabel?.numberOfLines = 0
        //mycell.imgImagen.image = noticias[indexPath.row].imagen
        //mycell.txtResumen.text = noticias[indexPath.row].txtNoticia
        
        return mycell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
