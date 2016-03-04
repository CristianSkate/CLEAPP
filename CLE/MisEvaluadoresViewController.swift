//
//  BuscarEncuestadoresViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 28-12-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class MisEvaluadoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate {

    var reponseError: NSError?
    var response: NSURLResponse?
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var misEvaluadores:NSArray! = []
    var cargados:Bool = false
    
    
    @IBOutlet weak var btnFinal: UIButton!
    @IBOutlet weak var tblSeleccion: UITableView!
    
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
        self.tblSeleccion.rowHeight = UITableViewAutomaticDimension;
        self.tblSeleccion.estimatedRowHeight = 44.0;
        
        //Mostrar evaluadores de las preferencias
        //cargarDatosPrevios()
        //Validar cantidades para subir al server
        //validarBotonFinalizar()
        
        
        
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
        
        }else{
            buscarEnBD()
            cargados = true
        }
    }

    
    override func viewDidAppear(animated: Bool) {
        print("paso")
        //buscarEnBD()
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
        //Variable prefs para obtener preferencias guardadas
        let rut:String = prefs.valueForKey("RUN") as! String
        let superior = sup.rut
        let par1 = par[0].rut
        let par2 = par[1].rut
        let par3 = par[2].rut
        let sub1 = sub[0].rut
        let sub2 = sub[1].rut
        let sub3 = sub[2].rut
        let sub4 = sub[3].rut
        let sub5 = sub[4].rut
        var par4 = ""
        var par5 = ""
        var sub6 = ""
        var sub7 = ""
        if par.count > 3 {
            par4 = par[3].rut
            if par.count > 4 {
                par5 = par[4].rut
            }
        }
        if sub.count > 5 {
            sub6 = sub[5].rut
            if sub.count > 6{
                sub7 = sub[6].rut
            }
        }
        
        let post:NSString = "run_evaluado=\(rut)&sup=\(superior)&par1=\(par1)&par2=\(par2)&par3=\(par3)&par4=\(par4)&par5=\(par5)&sub1=\(sub1)&sub2=\(sub2)&sub3=\(sub3)&sub4=\(sub4)&sub5=\(sub5)&sub6=\(sub6)&sub7=\(sub7)"
        
        
        // mandamos al log para ir registrando lo que va pasando
        NSLog("PostData: %@",post);
        
        // llamamos a la URl donde está el json que se conectará con la BD
        let url:NSURL = NSURL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/guardarEvaluadores?AspxAutoDetectCookieSupport=1")!
        
        // codificamos lo que se envía
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        // se determina el largo del string
        let postLength:NSString = String( postData.length )
        
        // componemos la URL con una var request y un NSMutableURLRequest y le pasamos como parámetros las vars
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        // hacemos la conexion
        var urlData: NSData?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
        } catch let error as NSError {
            reponseError = error
            urlData = nil
        }
        
        // se valida
        if ( urlData != nil ) {
            let res = response as! NSHTTPURLResponse!;
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                
                NSLog("Response ==> %@", responseData);
                

                if responseData == "true"{
                
                   let alertController = UIAlertController(title: "Mensaje", message: "Se guardaron los datos con éxito", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler:{(alert: UIAlertAction) in
                        self.buscarEnBD()
                        
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                
                
                NSLog("Trae Datos");
                // guardamos en la caché
                //let registros:NSArray = jsonData.valueForKey("") as! NSArray
                print(misEvaluadores)
                if misEvaluadores.count > 1 {
                    self.navigationItem.rightBarButtonItem?.enabled = false
                }
                
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "¡Ups!", message: "Hubo un problema conectando al servidor", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        } else {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Acceso incorrecto"
            alertView.message = "Conneción Fallida"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        print("Se envía la seleccion a la base de datos\n\(sup.rut)\n\(par.count)\n\(sub.count)")
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
    
   // func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.Delete {
//            
//                seleccion.removeAtIndex(indexPath.row)
//                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//                
//
//            cargarDatosPrevios()
//            self.tblSeleccion.reloadData()
//        }
    //}
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if cargados {
            return nil
        }else{
            let deleteAction = UITableViewRowAction(style: .Default, title: "Eliminar") {action in
                //handle delete
                self.tblSeleccion.beginUpdates()
                self.seleccion.removeAtIndex(indexPath.row)
                //actualizar array en preferencias
                let guardar = NSKeyedArchiver.archivedDataWithRootObject(self.seleccion)
                self.prefs.setObject(guardar, forKey: "seleccionados")
                self.tblSeleccion.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.tblSeleccion.endUpdates()
            }
        
            return [deleteAction]
        }
    }
    
    func buscarEnBD() {
            
        //Variable prefs para obtener preferencias guardadas
        let rut:String = prefs.valueForKey("RUN") as! String
        //let periodo:String = "0"
        
            
        // se mete el user y pass dentro de un string
        let post:NSString = "run=\(rut)"
        
        // mandamos al log para ir registrando lo que va pasando
        NSLog("PostData: %@",post);
        
        // llamamos a la URl donde está el json que se conectará con la BD
        let url:NSURL = NSURL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/listaEvaluadores?AspxAutoDetectCookieSupport=1")!
            
        // codificamos lo que se envía
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
        // se determina el largo del string
        let postLength:NSString = String( postData.length )
        
        // componemos la URL con una var request y un NSMutableURLRequest y le pasamos como parámetros las vars
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
            
        // hacemos la conexion
        var urlData: NSData?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
        } catch let error as NSError {
            reponseError = error
                urlData = nil
        }
            
        // se valida
        if ( urlData != nil ) {
            let res = response as! NSHTTPURLResponse!;
                
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                NSLog("Response ==> %@", responseData);
                    
                //var error: NSError?
                    
                misEvaluadores = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers )) as! NSArray
                if misEvaluadores.count > 0 {
                    prefs.setObject(misEvaluadores, forKey: "seleccionados")
                    prefs.synchronize()
                    seleccion.removeAll()
                    for seleccionado in misEvaluadores{
                        seleccion.append(Evaluador(rut: (seleccionado.valueForKey("run_evaluador") as! String), nombre: (seleccionado.valueForKey("nombre_evaluador") as! String), relacion: seleccionado.valueForKey("relacion") as! String))
                    }
                }
                self.tblSeleccion.reloadData()
                    
                NSLog("Trae Datos");
                // guardamos en la caché
                //let registros:NSArray = jsonData.valueForKey("") as! NSArray
                print(misEvaluadores)
                if misEvaluadores.count > 1 {
                    self.navigationItem.rightBarButtonItem?.enabled = false
                }
                    
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "¡Ups!", message: "Hubo un problema conectando al servidor", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
                
        } else {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Acceso incorrecto"
            alertView.message = "Conneción Fallida"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        
    }

}