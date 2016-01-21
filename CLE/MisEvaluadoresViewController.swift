//
//  BuscarEncuestadoresViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 28-12-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class MisEvaluadoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate {

    
    @IBOutlet weak var btnFinal: UIButton!
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
        btnFinal.enabled = false
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "btnMenu:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "btnBuscar:")
        
        //Mostrar evaluadores de las preferencias
        cargarDatosPrevios()
        //Validar cantidades para subir al server
        validarBotonFinalizar()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func validarBotonFinalizar(){
        var sup:Int = 0
        var par:Int = 0
        var sub:Int = 0
        for evaluador in seleccion {
            switch evaluador.relacion {
            case "1":
                sup = sup + 1
                break
            case "2":
                par = par + 1
                break
            case "3":
                sub = sub + 1
                break
            default:
                return
            }
        }
        print(sup)
        print(par)
        print(sub)
        
        if (sup >= 1) && (par >= 3 && par <= 5) && (sub >= 3 && sub <= 5){
            btnFinal.enabled = true
        }
        
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
        validarBotonFinalizar()
        self.btnFinal.reloadInputViews()
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
            var sup:Evaluador!
            var par:[Evaluador] = []
            var sub:[Evaluador] = []
            for seleccionado in self.seleccion {
                switch seleccionado.relacion{
                    case "1":
                        sup = seleccionado
                    break
                    case "2":
                        par.append(seleccionado)
                    break
                    case "3":
                        sub.append(seleccionado)
                    break
                default:
                    return
                }
                
            }
            
            self.guardarSeleccionados(sup, par: par, sub: sub)
            
            
            }))
        alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func guardarSeleccionados(sup:Evaluador, par:[Evaluador], sub:[Evaluador]){
        print("Se envía la seleccion a la base de datos")
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
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.Delete {
//            
//                seleccion.removeAtIndex(indexPath.row)
//                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//                
//
//            cargarDatosPrevios()
//            self.tblSeleccion.reloadData()
//        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Eliminar") {action in
            //handle delete
            self.tblSeleccion.beginUpdates()
            self.seleccion.removeAtIndex(indexPath.row)
            //actualizar array en preferencias
            self.tblSeleccion.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tblSeleccion.endUpdates()
        }
        
        return [deleteAction]
    }

}
