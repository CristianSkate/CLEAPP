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
    let prefs:UserDefaults = UserDefaults.standard
    var reponseError: NSError?
    var response: URLResponse?
    var respEvaluadores:NSArray! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Buscar Evaluadores"
        //self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 128.0/255.0, green: 80.0/255.0, blue: 04.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barStyle = .black
        
        searchEvaluadores.delegate = self

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Volver", style: .plain, target: self, action: #selector(BuscarEvaluadoresViewController.volverAtras))
        
        tblBusqueda.delegate = self
        tblBusqueda.dataSource = self
        self.tblBusqueda.rowHeight = UITableViewAutomaticDimension;
        self.tblBusqueda.estimatedRowHeight = 44.0;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func volverAtras() {
        
            self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evaluadores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mycell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "celdaBusqueda", for: indexPath)
        
        mycell.textLabel?.text = ("\(evaluadores[(indexPath as NSIndexPath).row].nombre)\n\(evaluadores[(indexPath as NSIndexPath).row].rut)")
        mycell.textLabel?.numberOfLines = 0
        
        return mycell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let alertController = UIAlertController(title: "Confirmación", message: "\(evaluadores[(indexPath as NSIndexPath).row].nombre) es:", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Superior", style: .default, handler: {(alert: UIAlertAction) in
            //Agregar al susodicho al listado de los seleccionados
        
            //Cargar lista anterior
            let encuestadores = self.prefs.object(forKey: "seleccionados") as? Data
            
            if let encuestadores = encuestadores {
                self.seleccionados = (NSKeyedUnarchiver.unarchiveObject(with: encuestadores) as? [Evaluador])!
                
            }
            //Modificar nuevo Array
            var sup:Int = 0
            for seleccionado in self.seleccionados{
                if seleccionado.relacion == "1"{
                    sup = sup + 1
                }
            }
            if sup < 1 { //Validacion de limite para ingreso de evaluadores superiores
                var repetido:Bool = true
                for eval in self.seleccionados {
                    if eval.rut == self.evaluadores[(indexPath as NSIndexPath).row].rut {
                        repetido = false
                    }
                }
                if repetido{
                    self.seleccionados.append(Evaluador(rut: self.evaluadores[(indexPath as NSIndexPath).row].rut, nombre: self.evaluadores[(indexPath as NSIndexPath).row].nombre, relacion: "1"))
                    //Guardar en preferencias
                    let guardar = NSKeyedArchiver.archivedData(withRootObject: self.seleccionados)
                    self.prefs.set(guardar, forKey: "seleccionados")
                    //postpopover
                    self.parent?.viewDidAppear(true)
                
                    self.navigationController?.popViewController(animated: true)
                }else{
                    let alertController = UIAlertController(title: "Mensaje", message: "Esta persona ya está seleccionada", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }else{ //Mensaje de que ya llegaron al limite
                let alertController = UIAlertController(title: "Mensaje", message: "Ya has ingresado todos los Superiores", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Par", style: .default, handler: {(alert: UIAlertAction) in
            //Agregar al susodicho al listado de los seleccionados
            
            //Cargar lista anterior
            let encuestadores = self.prefs.object(forKey: "seleccionados") as? Data
            
            if let encuestadores = encuestadores {
                self.seleccionados = (NSKeyedUnarchiver.unarchiveObject(with: encuestadores) as? [Evaluador])!
                
            }
            //Modificar nuevo Array
            var par:Int = 0
            for seleccionado in self.seleccionados{
                if seleccionado.relacion == "2"{
                    par = par + 1
                }
            }
            if par < 3 {//Validacion de limite para ingreso de evaluadores pares
                var repetido:Bool = true
                for eval in self.seleccionados {
                    if eval.rut == self.evaluadores[(indexPath as NSIndexPath).row].rut {
                        repetido = false
                    }
                }
                if repetido{
                    self.seleccionados.append(Evaluador(rut: self.evaluadores[(indexPath as NSIndexPath).row].rut, nombre: self.evaluadores[(indexPath as NSIndexPath).row].nombre, relacion: "2"))
                    //Guardar en preferencias
                    let guardar = NSKeyedArchiver.archivedData(withRootObject: self.seleccionados)
                    self.prefs.set(guardar, forKey: "seleccionados")
                    //postpopover
                    self.parent?.viewDidAppear(true)
                
                    self.navigationController?.popViewController(animated: true)
                }else{
                    let alertController = UIAlertController(title: "Mensaje", message: "Esta persona ya está seleccionada", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }else{
            let alertController = UIAlertController(title: "Mensaje", message: "Ya has ingresado todos los Pares", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Subalterno", style: .default, handler: {(alert: UIAlertAction) in
            //Agregar al susodicho al listado de los seleccionados
            
            //Cargar lista anterior
            let encuestadores = self.prefs.object(forKey: "seleccionados") as? Data
            
            if let encuestadores = encuestadores {
                self.seleccionados = (NSKeyedUnarchiver.unarchiveObject(with: encuestadores) as? [Evaluador])!
                
            }
            //Modificar nuevo Array
            var sub:Int = 0
            for seleccionado in self.seleccionados{
                if seleccionado.relacion == "3"{
                    sub = sub + 1
                }
            }
            if sub < 3 { //Validacion de limite para ingreso de evaluadores subalternos
                var repetido:Bool = true
                for eval in self.seleccionados {
                    if eval.rut == self.evaluadores[(indexPath as NSIndexPath).row].rut {
                        repetido = false
                    }
                }
                if repetido{
                    self.seleccionados.append(Evaluador(rut: self.evaluadores[(indexPath as NSIndexPath).row].rut, nombre: self.evaluadores[(indexPath as NSIndexPath).row].nombre, relacion: "3"))
                    //Guardar en preferencias
                    let guardar = NSKeyedArchiver.archivedData(withRootObject: self.seleccionados)
                    self.prefs.set(guardar, forKey: "seleccionados")
                    //postpopover
                    self.parent?.viewDidAppear(true)
                
                    self.navigationController?.popViewController(animated: true)
                }else{
                    let alertController = UIAlertController(title: "Mensaje", message: "Esta persona ya está seleccionada", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }else{
                let alertController = UIAlertController(title: "Mensaje", message: "Ya has ingresado todos los Subordinados", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present((alertController), animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        btnBuscar()
        searchEvaluadores.endEditing(true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchEvaluadores.endEditing(true)
    }
    
    func btnBuscar() {
        
        let textoBuscar:String = searchEvaluadores.text! //prefs.valueForKey("RUN") as! String
        
        
        // se mete el user y pass dentro de un string
        let post:NSString = "q=\(textoBuscar)" as NSString
        
        // mandamos al log para ir registrando lo que va pasando
        NSLog("PostData: %@",post);
        
        // llamamos a la URl donde está el json que se conectará con la BD
        let url:URL = URL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/ObtenerNombres?AspxAutoDetectCookieSupport=1")!
        
        // codificamos lo que se envía
        let postData:Data = post.data(using: String.Encoding.ascii.rawValue)!
        
        // se determina el largo del string
        let postLength:NSString = String( postData.count ) as NSString
        
        // componemos la URL con una var request y un NSMutableURLRequest y le pasamos como parámetros las vars
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        // hacemos la conexion
        var urlData: Data?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
        } catch let error as NSError {
            reponseError = error
            urlData = nil
        }
        
        // se valida
        if ( urlData != nil ) {
            let res = response as! HTTPURLResponse!;
            
            //NSLog("Response code: %ld", res?.statusCode);
            
            if ((res?.statusCode)! >= 200 && (res?.statusCode)! < 300)
            {
                let responseData:NSString  = NSString(data:urlData!, encoding:String.Encoding.utf8.rawValue)!
                
                NSLog("Response ==> %@", responseData);
                
                //var error: NSError?
                evaluadores.removeAll()
                respEvaluadores = (try! JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSArray
                    for evaluador in respEvaluadores{
                    
                        evaluadores.append(Evaluador(rut: ((evaluador as AnyObject).value(forKey: "id")) as! String, nombre:     ((evaluador as AnyObject).value(forKey: "text")) as! String, relacion: "1"))
                    }
                
                if evaluadores.count < 1 {
                    let alertController = UIAlertController(title: "¡Ups!", message: "No se encontraron personas con este nombre", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                    present(alertController, animated: true, completion: nil)
                }
                
                self.tblBusqueda.reloadData()
                
                
                NSLog("Trae Datos");
                
                print(respEvaluadores)
                
            } else {
                let alertController = UIAlertController(title: "¡Ups!", message: "Hubo un problema conectando al servidor", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
        } else {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Mensaje"
            alertView.message = "No se pudo conectar con el servidor, asegurese de que tiene conexión a internet"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
        }
        
    }

}
