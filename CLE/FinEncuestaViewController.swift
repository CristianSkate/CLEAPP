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
    var response: NSURLResponse?
    @IBOutlet weak var txtFinEncuesta: UITextView!
    var rutEvaluado:String!
    var rutEvaluador:String!
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Fin de la encuesta"
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Black
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Salir", style: .Plain, target: self, action: "volverAtras")
        
        rutEvaluador = prefs.valueForKey("RUN") as! String
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func volverAtras() {
        let alertController = UIAlertController(title: "Confirmación", message: "Al presionar Si guardará los cambios para continuar más tarde, ¿Desea continuar?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Si", style: .Default, handler: {(alert: UIAlertAction) in
            self.performSegueWithIdentifier("unwindToMisEncuestas", sender: self)
            //          self.navigationController?.popViewControllerAnimated(true)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        self.presentViewController((alertController), animated: true, completion: nil)
        
    }
    
    @IBAction func btnEnviarEncuesta(sender: AnyObject) {
        
        let jsonFinal:String = prefs.valueForKey("resp\(rutEvaluador)\(rutEvaluador)") as! String
        if enviarResultados(jsonFinal){
            self.performSegueWithIdentifier("unwindToMisEncuestas", sender: self)
        }
        
        
    }
    
    func enviarResultados(jsonFinal:String) -> Bool {
        
        
        print(jsonFinal)
        
        return guardarSeleccionados(jsonFinal)
    }
    

    func guardarSeleccionados(jsonFinal:String) -> Bool{
        //Variable prefs para obtener preferencias guardadas
        var guardo:Bool = false
        
        let post:NSString = "sJson=\(jsonFinal)"
        
        
        // mandamos al log para ir registrando lo que va pasando
        NSLog("PostData: %@",post);
        
        // llamamos a la URl donde está el json que se conectará con la BD
        let url:NSURL = NSURL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/GuardarPreguntas?AspxAutoDetectCookieSupport=1")!
        
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
                        
                        guardo = true
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                
                
                NSLog("Trae Datos");
                // guardamos en la caché
                //let registros:NSArray = jsonData.valueForKey("") as! NSArray
                
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
        return guardo
    }
}
