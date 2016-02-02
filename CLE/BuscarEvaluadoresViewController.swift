//
//  BuscarEncuestadoresViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 02-01-16.
//  Copyright © 2016 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class BuscarEvaluadoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tblBusqueda: UITableView!
    @IBOutlet weak var searchEvaluadores: UISearchBar!
    
    var evaluadores:[Evaluador] = []
    var seleccionados:[Evaluador] = []
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var reponseError: NSError?
    var response: NSURLResponse?
    var respEvaluadores:NSArray! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Buscar Evaluadores"
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Black
        
        //var image = UIImage(named: "Menu")
        searchEvaluadores.delegate = self
        //image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Volver", style: .Plain, target: self, action: "volverAtras")
        
        tblBusqueda.delegate = self
        tblBusqueda.dataSource = self
        self.tblBusqueda.rowHeight = UITableViewAutomaticDimension;
        self.tblBusqueda.estimatedRowHeight = 44.0;
        
        //evaluadores.append(Evaluador(rut: "11111111-1", nombre: "Felipe Valenzuela", relacion: "0"))

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func volverAtras() {
        
            self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evaluadores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let mycell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("celdaBusqueda", forIndexPath: indexPath)
        
        mycell.textLabel?.text = ("\(evaluadores[indexPath.row].nombre)\n\(evaluadores[indexPath.row].rut)")
        mycell.textLabel?.numberOfLines = 0
        //mycell.imgImagen.image = noticias[indexPath.row].imagen
        //mycell.txtResumen.text = noticias[indexPath.row].txtNoticia
        
        return mycell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        let alertController = UIAlertController(title: "Confirmación", message: "\(evaluadores[indexPath.row].nombre) es:", preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "Superior", style: .Default, handler: {(alert: UIAlertAction) in
            //Agregar al susodicho al listado de los seleccionados
        
            //Cargar lista anterior
            let encuestadores = self.prefs.objectForKey("seleccionados") as? NSData
            
            if let encuestadores = encuestadores {
                self.seleccionados = (NSKeyedUnarchiver.unarchiveObjectWithData(encuestadores) as? [Evaluador])!
                
            }
            //Modificar nuevo Array
            var sup:Int = 0
            for seleccionado in self.seleccionados{
                if seleccionado.relacion == "1"{
                    sup = sup + 1
                }
            }
            if sup < 1 {
                var repetido:Bool = true
                for eval in self.seleccionados {
                    if eval.rut == self.evaluadores[indexPath.row].rut {
                        repetido = false
                    }
                }
                if repetido{
                    self.seleccionados.append(Evaluador(rut: self.evaluadores[indexPath.row].rut, nombre: self.evaluadores[indexPath.row].nombre, relacion: "1"))
                    //Guardar en preferencias
                    let guardar = NSKeyedArchiver.archivedDataWithRootObject(self.seleccionados)
                    self.prefs.setObject(guardar, forKey: "seleccionados")
                    //postpopover
                    self.parentViewController?.viewDidAppear(true)
                
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    let alertController = UIAlertController(title: "Mensaje", message: "Esta persona ya está seleccionada", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }else{
                let alertController = UIAlertController(title: "Mensaje", message: "Ya has ingresado todos los Superiores", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Par", style: .Default, handler: {(alert: UIAlertAction) in
            //Agregar al susodicho al listado de los seleccionados
            
            //Cargar lista anterior
            let encuestadores = self.prefs.objectForKey("seleccionados") as? NSData
            
            if let encuestadores = encuestadores {
                self.seleccionados = (NSKeyedUnarchiver.unarchiveObjectWithData(encuestadores) as? [Evaluador])!
                
            }
            //Modificar nuevo Array
            var par:Int = 0
            for seleccionado in self.seleccionados{
                if seleccionado.relacion == "2"{
                    par = par + 1
                }
            }
            if par < 5 {
                var repetido:Bool = true
                for eval in self.seleccionados {
                    if eval.rut == self.evaluadores[indexPath.row].rut {
                        repetido = false
                    }
                }
                if repetido{
                    self.seleccionados.append(Evaluador(rut: self.evaluadores[indexPath.row].rut, nombre: self.evaluadores[indexPath.row].nombre, relacion: "2"))
                    //Guardar en preferencias
                    let guardar = NSKeyedArchiver.archivedDataWithRootObject(self.seleccionados)
                    self.prefs.setObject(guardar, forKey: "seleccionados")
                    //postpopover
                    self.parentViewController?.viewDidAppear(true)
                
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    let alertController = UIAlertController(title: "Mensaje", message: "Esta persona ya está seleccionada", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }else{
            let alertController = UIAlertController(title: "Mensaje", message: "Ya has ingresado todos los Pares", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Subalterno", style: .Default, handler: {(alert: UIAlertAction) in
            //Agregar al susodicho al listado de los seleccionados
            
            //Cargar lista anterior
            let encuestadores = self.prefs.objectForKey("seleccionados") as? NSData
            
            if let encuestadores = encuestadores {
                self.seleccionados = (NSKeyedUnarchiver.unarchiveObjectWithData(encuestadores) as? [Evaluador])!
                
            }
            //Modificar nuevo Array
            var sub:Int = 0
            for seleccionado in self.seleccionados{
                if seleccionado.relacion == "3"{
                    sub = sub + 1
                }
            }
            if sub < 5 {
                var repetido:Bool = true
                for eval in self.seleccionados {
                    if eval.rut == self.evaluadores[indexPath.row].rut {
                        repetido = false
                    }
                }
                if repetido{
                    self.seleccionados.append(Evaluador(rut: self.evaluadores[indexPath.row].rut, nombre: self.evaluadores[indexPath.row].nombre, relacion: "3"))
                    //Guardar en preferencias
                    let guardar = NSKeyedArchiver.archivedDataWithRootObject(self.seleccionados)
                    self.prefs.setObject(guardar, forKey: "seleccionados")
                    //postpopover
                    self.parentViewController?.viewDidAppear(true)
                
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    let alertController = UIAlertController(title: "Mensaje", message: "Esta persona ya está seleccionada", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }else{
                let alertController = UIAlertController(title: "Mensaje", message: "Ya has ingresado todos los Subordinados", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        self.presentViewController((alertController), animated: true, completion: nil)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
   
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        btnBuscar()
        searchEvaluadores.endEditing(true)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.searchEvaluadores.endEditing(true)
    }
    
    func btnBuscar() {
        
        let textoBuscar:String = searchEvaluadores.text! //prefs.valueForKey("RUN") as! String
        
        
        // se mete el user y pass dentro de un string
        let post:NSString = "q=\(textoBuscar)"
        
        // mandamos al log para ir registrando lo que va pasando
        NSLog("PostData: %@",post);
        
        // llamamos a la URl donde está el json que se conectará con la BD
        let url:NSURL = NSURL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/ObtenerNombres?AspxAutoDetectCookieSupport=1")!
        
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
                evaluadores.removeAll()
                respEvaluadores = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers )) as! NSArray
                    for evaluador in respEvaluadores{
                    
                        evaluadores.append(Evaluador(rut: (evaluador.valueForKey("id")) as! String, nombre:     (evaluador.valueForKey("text")) as! String, relacion: "1"))
                    }
                
                if evaluadores.count < 1 {
                    let alertController = UIAlertController(title: "¡Ups!", message: "No se encontraron personas con este nombre", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                    presentViewController(alertController, animated: true, completion: nil)
                }
                
                self.tblBusqueda.reloadData()
                
                
                NSLog("Trae Datos");
                // guardamos en la caché
                //let registros:NSArray = jsonData.valueForKey("") as! NSArray
                print(respEvaluadores)
                
                
                //self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "¡Ups!", message: "Hubo un problema conectando al servidor", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        } else {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Mensaje"
            alertView.message = "No se pudo conectar con el servidor, asegurese de que tiene conexión a internet"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        
    }

}
