//
//  FinEncuestaViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 19-02-16.
//  Copyright © 2016 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class FinEncuestaViewController: UIViewController {

    var reponseError: NSError?
    var response: URLResponse?
    var resp: NSDictionary!
    @IBOutlet weak var txtFinEncuesta: UITextView!
    var rutEvaluado:String!
    var rutEvaluador:String!
    let prefs:UserDefaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Fin de la encuesta"
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Salir", style: .plain, target: self, action: #selector(FinEncuestaViewController.volverAtras))
        
        rutEvaluador = prefs.value(forKey: "RUN") as! String
        print(rutEvaluado)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func volverAtras() {
        let alertController = UIAlertController(title: "Confirmación", message: "Al presionar Si guardará los cambios para continuar más tarde, ¿Desea continuar?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Si", style: .default, handler: {(alert: UIAlertAction) in
            self.performSegue(withIdentifier: "unwindToMisEncuestas", sender: self)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present((alertController), animated: true, completion: nil)
        
    }
    
    @IBAction func btnEnviarEncuesta(_ sender: AnyObject) {
        //
        let jsonFinal:String = prefs.value(forKey: "resp\(rutEvaluador)\(rutEvaluado)") as! String
        print(jsonFinal)
        
        if enviarResultados(jsonFinal){
            let alertController = UIAlertController(title: "Mensaje", message: "Se guardaron los datos con éxito", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler:{(alert: UIAlertAction) in
                
                self.performSegue(withIdentifier: "unwindToMisEncuestas", sender: self)
                
            }))
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func enviarResultados(_ jsonFinal:String) -> Bool {
        
        print(jsonFinal)
        return guardarSeleccionados(jsonFinal)
    }
    

    func guardarSeleccionados(_ jsonFinal:String) -> Bool{

        var guardo:Bool = false
        let post:NSString = "sJson=\(jsonFinal)" as NSString
        
        
        // mandamos al log para ir registrando lo que va pasando
        NSLog("PostData: %@",post);
        
        // llamamos a la URl donde está el json que se conectará con la BD
        let url:URL = URL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/GuardarPreguntas?AspxAutoDetectCookieSupport=1")!
        
        // codificamos lo que se envía
        let postData:Data = post.data(using: String.Encoding.utf8.rawValue)!
        
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
                
                resp = (try! JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
                
                if resp.value(forKey: "respuesta") as! String == "OK"{
                    
                    guardo = true
                    return guardo
                }else{
                    let alertController = UIAlertController(title: "Mensaje", message: "Ocurrió un error guardando los datos en el servidor", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler:nil))
                    self.present(alertController, animated: true, completion: nil)
                }
                
                NSLog("Trae Datos");
                
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
        return guardo
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToMisEncuestas" {
            let vc = segue.destination as! MisEncuestasViewController
            vc.cargarMisEncuestas()
        }
    }
}
