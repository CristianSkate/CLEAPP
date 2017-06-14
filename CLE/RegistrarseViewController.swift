//
//  RegistrarseViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 12-06-17.
//  Copyright © 2017 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class RegistrarseViewController: UIViewController {

    
    @IBOutlet var txtRUN: UITextField!
    @IBOutlet var txtClaveUnidad: UITextField!
    //variables webservice
    var urlData:Data!
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var passData =  false
    var nombres:NSString = ""
    var apellidoPaterno:NSString = ""
    var apellidoMaterno:NSString = ""
    var resp:NSString = ""
    var responseError:NSError?
    var response: URLResponse?
    var respRegistro:NSDictionary! = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 22))
        //statusBarView.backgroundColor = UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        statusBarView.backgroundColor = UIColor(red: 128.0/255.0, green: 80.0/255.0, blue: 04.0/255.0, alpha: 1.0)
        self.view.addSubview(statusBarView)
        self.preferredStatusBarStyle

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    

    @IBAction func volverAtras(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSiguiente(_ sender: AnyObject) {
        //enviar datos al ws y pasar a la siguiente pantalla.
        comenzarRegistro()
        
        //Luego de enviar, recibir y guardar los datos se pasa al segundo paso
        self.performSegue(withIdentifier: "irASiguienteRegistro", sender: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irASiguienteRegistro"{
            let vc = segue.destination as! Paso2RegistrarseViewController
            vc.apellidoPaterno = apellidoPaterno
            vc.apellidoMaterno = apellidoMaterno
            vc.nombres = nombres
            vc.run = txtRUN.text!
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    
    func comenzarRegistro() {
        
        let run:NSString = txtRUN.text! as NSString
        let claveUnidad: NSString = txtClaveUnidad.text! as NSString
        
        if(run == "") || (claveUnidad == "") {
            
            let alertController = UIAlertController(title: "¡Ups!", message: "Debe ingresar run sin puntos y contraseña", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            
            let url:URL = URL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/registroPaso1?AspxAutoDetectCookieSupport=1")! // llamamos a la URl donde está el ws que se conectará con la BD
            let request:NSMutableURLRequest = NSMutableURLRequest(url: url) // componemos la URL con una var request y un NSMutableURLRequest y le pasamos como parámetros las vars
            request.httpMethod = "POST"
            let post:NSString = "run=\(run)&clave_seguridad=\(claveUnidad)" as NSString // se mete el user y pass dentro de un string
            NSLog("PostData: %@",post) // mandamos al log para ir registrando lo que va pasando
            let postData:Data = post.data(using: String.Encoding.ascii.rawValue)! // codificamos lo que se envía
            let postLength:NSString = String( postData.count ) as NSString // se determina el largo del string
            request.httpBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("cle.ejercito.cl", forHTTPHeaderField: "Host")
            
            // hacemos la conexion
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
            } catch let error as NSError {
                self.responseError = error
                urlData = nil
            }
            
            // se valida
            if ( urlData != nil ) {
                let res = response as! HTTPURLResponse!;
                
                //NSLog("Response code: %ld", res?.statusCode)
                if ((res?.statusCode)! >= 200 && (res?.statusCode)! < 300)
                {
                    let responseData:NSString  = NSString(data:urlData!, encoding: String.Encoding.utf8.rawValue)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    respRegistro = (try! JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
                    
                    if(respRegistro.value(forKey: "respuesta") as! String == "OK")
                    {
                        NSLog("Solicitud Correcta");
                        // Se guardan las variables para la proxima pantalla
                        
                        apellidoPaterno = respRegistro!.value(forKey: "paterno") as! NSString
                        apellidoMaterno = respRegistro!.value(forKey: "materno") as! NSString
                        nombres = respRegistro.value(forKey: "nombres") as! NSString
                        
                        
                    } else{
                        if (respRegistro.value(forKey: "respuesta") as! String == "Usuario ya registrado") {
                            let error_msg:NSString = "Usuario ya registrado"
                            
                            let alertController = UIAlertController(title: "¡Ups!", message: error_msg as String, preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }else {
                            if (respRegistro.value(forKey: "respuesta") as! String == "Clave de seguridad incorrecta") {
                                let error_msg:NSString = "RUN o Clave de seguridad incorrectos"
                                
                                let alertController = UIAlertController(title: "¡Ups!", message: error_msg as String, preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                }else {
                    let alertController = UIAlertController(title: "¡Ups!", message: "Conexión fallida", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            } else {
                let alertController = UIAlertController(title: "¡Ups!", message: "Conexión fallida", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                
                if let _ = responseError {
                    alertController.message = "No se pudo conectar con el servidor, asegurese de que tiene conexión a internet"//(error.localizedDescription)
                }
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }


}
