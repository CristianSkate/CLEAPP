//
//  MisEncuestasViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 06-10-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class MisEncuestasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var reponseError: NSError?
    var response: URLResponse?
    let prefs:UserDefaults = UserDefaults.standard
    var encuestasPendientes:NSArray! = []
    var rutSeleccionado:String!
    var codRelacionSel:String!
    @IBOutlet weak var tblEncuestasPendientes: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mis Encuestas"
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Acualizar", style: .plain, target: self, action: #selector(MisEncuestasViewController.cargarMisEncuestas))
        
        tblEncuestasPendientes.dataSource = self
        tblEncuestasPendientes.delegate = self
        tblEncuestasPendientes.rowHeight = UITableViewAutomaticDimension
        tblEncuestasPendientes.estimatedRowHeight =  50
        
        var image = UIImage(named: "Menu")
        
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(MisEncuestasViewController.btnMenu(_:)))

        preCargarEncuestas()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    @IBAction func btnMenu(_ sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(.left, animated: true, completion: nil)
    }
    func preCargarEncuestas(){
        
        encuestasPendientes = prefs.array(forKey: "ENCUESTASPENDIENTES") as NSArray!
        
        if (encuestasPendientes == nil) {
            cargarMisEncuestas()
        }
    }

    
    func cargarMisEncuestas(){
        
        //Variable prefs para obtener preferencias guardadas
        let rut:String = prefs.value(forKey: "RUN") as! String
        let periodo:String = "0"
        
        
            // se mete el user y pass dentro de un string
            let post:NSString = "runEvaluador=\(rut)&periodo=\(periodo)" as NSString
            
            // mandamos al log para ir registrando lo que va pasando
            NSLog("PostData: %@",post);
            
            // llamamos a la URl donde está el json que se conectará con la BD
            let url:URL = URL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/ObtenerEvaluacionesJson?AspxAutoDetectCookieSupport=1")!
            
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
                    
                    encuestasPendientes = (try! JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSArray
                    prefs.set(encuestasPendientes, forKey: "ENCUESTASPENDIENTES")
                    prefs.synchronize()
                    self.tblEncuestasPendientes.reloadData()
                    
                    NSLog("Trae Datos");
                    
                    print(encuestasPendientes)
                    
                        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if encuestasPendientes == nil {
            encuestasPendientes = []
        }
        return encuestasPendientes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mycell:CeldaMisEncuestasTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CeldaMisEncuestas", for: indexPath) as! CeldaMisEncuestasTableViewCell
        
        mycell.txtNombreEncuestado.text = (encuestasPendientes[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "nombreEvaluado") as? String
        
        if (encuestasPendientes[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "estado") as? String == "Finalizada" {
            mycell.btnResponder.setTitle("Finalizado", for: UIControlState())
            mycell.btnResponder.isEnabled = false
        }else{
            mycell.btnResponder.setTitle("Evaluar", for: UIControlState())
            mycell.btnResponder.tag = (indexPath as NSIndexPath).row
            mycell.btnResponder.addTarget(self, action: #selector(MisEncuestasViewController.irAEncuesta(_:)), for: .touchUpInside)
            mycell.btnResponder.isEnabled = true
        }
        
        return mycell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func irAEncuesta(_ sender: UIButton) {
        rutSeleccionado = (encuestasPendientes[sender.tag] as AnyObject).value(forKey: "runEvaluado") as? String
        codRelacionSel = (encuestasPendientes[sender.tag] as AnyObject).value(forKey: "cod_relacion") as? String
        // Funcion para mostrar el segue de la encuesta.
        self.performSegue(withIdentifier: "empezarInstructivo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "empezarInstructivo" {
            let vc = segue.destination as! MantenedorInstructivoViewController
            vc.rutEvaluado = self.rutSeleccionado
            vc.codRelacionSel = self.codRelacionSel
            print(codRelacionSel)
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    @IBAction func unwindToMisEncuestas(_ segue: UIStoryboardSegue) {
        
    }
}
