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
    var response: URLResponse?
    var resp:NSDictionary!
    let prefs:UserDefaults = UserDefaults.standard
    var misEvaluadores:NSArray! = []
    var cargados:Bool = false
    
    
    @IBOutlet weak var btnFinal: UIButton!
    @IBOutlet weak var tblSeleccion: UITableView!
    
    var seleccion:[Evaluador] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Mis evaluadores"
        //self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 128.0/255.0, green: 80.0/255.0, blue: 04.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barStyle = .black

        var image = UIImage(named: "Menu")
        
        tblSeleccion.delegate = self
        tblSeleccion.dataSource = self
        btnFinal.isEnabled = false
        
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(MisEvaluadoresViewController.btnMenu(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MisEvaluadoresViewController.btnBuscar(_:)))
        self.tblSeleccion.rowHeight = UITableViewAutomaticDimension;
        self.tblSeleccion.estimatedRowHeight = 44.0;
        
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
        
        if (sup >= 1) && (par >= 2 && par <= 3) && (sub >= 2 && sub <= 3){
            btnFinal.isEnabled = true
        }
        
    }
    
    func cargarDatosPrevios() {
        let encuestadores = self.prefs.object(forKey: "seleccionados") as? Data
        
        if let encuestadores = encuestadores {
        self.seleccion = (NSKeyedUnarchiver.unarchiveObject(with: encuestadores) as? [Evaluador])!
        
        }else{
            buscarEnBD()
            cargados = true
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
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
    
    @IBAction func btnMenu(_ sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(.left, animated: true, completion: nil)
    }
    
    @IBAction func btnBuscar(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "BuscarEvaluadores", sender: nil)
        
    }
    
    @IBAction func btnFinalizar(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Confirmación", message: "Luego de confirmar la selección no se podrán realizar cambios\n¿Desea confirmar la selección?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Si", style: .default, handler: {(alert: UIAlertAction) in
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
            
            if self.guardarSeleccionados(sup, par: par, sub: sub){
                let alertController = UIAlertController(title: "Mensaje", message: "Se guardaron los datos con éxito", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler:{(alert: UIAlertAction) in
                    self.buscarEnBD()
                    
                }))
                self.present(alertController, animated: true, completion: nil)
            }
            
            
            }))
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func guardarSeleccionados(_ sup:Evaluador, par:[Evaluador], sub:[Evaluador]) -> Bool{
        //Variable prefs para obtener preferencias guardadas
        let rut:String = prefs.value(forKey: "RUN") as! String
        let superior = sup.rut
        let par1 = par[0].rut
        let par2 = par[1].rut
        //let par3 = par[2].rut
        let sub1 = sub[0].rut
        let sub2 = sub[1].rut
        //let sub3 = sub[2].rut
        //let sub4 = sub[3].rut
        //let sub5 = sub[4].rut
        //var par4 = ""
        var par3 = ""
        var sub3 = ""
        //var par5 = ""
        //var sub6 = ""
        //var sub7 = ""
        if par.count > 2 {
            par3 = par[2].rut
            //if par.count > 4 {
            //    par5 = par[4].rut
            //}
        }
        if sub.count > 2 {
            sub3 = sub[2].rut
            //if sub.count > 6{
            //    sub7 = sub[6].rut
            //}
        }
        
        let post:NSString = "run_evaluado=\(rut)&sup=\(superior)&par1=\(par1)&par2=\(par2)&par3=\(par3)&sub1=\(sub1)&sub2=\(sub2)&sub3=\(sub3)" as NSString
        
        
        // mandamos al log para ir registrando lo que va pasando
        NSLog("PostData: %@",post);
        
        // llamamos a la URl donde está el json que se conectará con la BD
        let url:URL = URL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/guardarEvaluadores?AspxAutoDetectCookieSupport=1")!
        
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
            
            //NSLog("Response code: %@", res?.statusCode ?? "");
            
            if ((res?.statusCode)! >= 200 && (res?.statusCode)! < 300)
            {
                let responseData:NSString  = NSString(data:urlData!, encoding:String.Encoding.utf8.rawValue)!
                
                NSLog("Response ==> %@", responseData);
                
                if responseData == "true"{
                
                    prefs.set(nil, forKey: "seleccionados")
                    prefs.synchronize()
                   return true
                    
                }
                
                
                NSLog("Trae Datos");

                print(misEvaluadores)
                if misEvaluadores.count > 1 {
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                }
                
                self.dismiss(animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "¡Ups!", message: "Hubo un problema conectando al servidor", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
        } else {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Acceso incorrecto"
            alertView.message = "Conneción Fallida"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
        }
        print("Se envía la seleccion a la base de datos\n\(sup.rut)\n\(par.count)\n\(sub.count)")
        return false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seleccion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mycell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "celdaEvaluadores", for: indexPath)
        
        mycell.textLabel?.text = ("\(seleccion[(indexPath as NSIndexPath).row].nombre)\n\(seleccion[(indexPath as NSIndexPath).row].rut)")
        mycell.textLabel?.numberOfLines = 0
        
        return mycell
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if cargados {
            return nil
        }else{
            let deleteAction = UITableViewRowAction(style: .default, title: "Eliminar") {action in
                //maneja el delete
                self.tblSeleccion.beginUpdates()
                self.seleccion.remove(at: (indexPath as NSIndexPath).row)
                //actualizar array en preferencias
                let guardar = NSKeyedArchiver.archivedData(withRootObject: self.seleccion)
                self.prefs.set(guardar, forKey: "seleccionados")
                self.tblSeleccion.deleteRows(at: [indexPath], with: .fade)
                self.tblSeleccion.endUpdates()
            }
        
            return [deleteAction]
        }
    }
    
    func buscarEnBD() {
            
        //Variable prefs para obtener preferencias guardadas
        let rut:String = prefs.value(forKey: "RUN") as! String
        
        let post:NSString = "run=\(rut)" as NSString
        
        // mandamos al log para ir registrando lo que va pasando
        NSLog("PostData: %@",post);
        
        // llamamos a la URl donde está el json que se conectará con la BD
        let url:URL = URL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/listaEvaluadores?AspxAutoDetectCookieSupport=1")!
            
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
                    
                misEvaluadores = (try! JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSArray
                if misEvaluadores.count > 0 {
                    prefs.set(misEvaluadores, forKey: "seleccionados")
                    prefs.synchronize()
                    seleccion.removeAll()
                    for seleccionado in misEvaluadores{
                        seleccion.append(Evaluador(rut: ((seleccionado as AnyObject).value(forKey: "run_evaluador") as! String), nombre: ((seleccionado as AnyObject).value(forKey: "nombre_evaluador") as! String), relacion: (seleccionado as AnyObject).value(forKey: "relacion") as! String, cantidad: ""))
                    }
                }
                self.tblSeleccion.reloadData()
                    
                NSLog("Trae Datos");

                print(misEvaluadores)
                if misEvaluadores.count > 1 {
                    self.btnFinal.isEnabled = false
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                }
                    
                self.dismiss(animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "¡Ups!", message: "Hubo un problema conectando al servidor", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
                
        } else {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Acceso incorrecto"
            alertView.message = "Conneción Fallida"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
        }
        
    }

}
