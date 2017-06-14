//
//  Paso2RegistrarseViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 12-06-17.
//  Copyright © 2017 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class Paso2RegistrarseViewController: UIViewController {

    
    @IBOutlet var txtTituloPaso2: UITextView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var txtApellidoPaterno: UITextField!
    @IBOutlet var txtApellidoMaterno: UITextField!
    @IBOutlet var txtNombres: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtConfirmEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtConfirmPassword: UITextField!
    @IBOutlet var txtPregSecreta: UITextField!
    @IBOutlet var txtRespuesta: UITextField!
    
    var run = ""
    var codPregunta:String = ""
    var nombres:NSString = ""
    var apellidoPaterno:NSString = ""
    var apellidoMaterno:NSString = ""
    //Variables para webservice
    var urlData:Data!
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var passData =  false
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

        
        txtTituloPaso2.text = "Revise y confirme sus datos para completar el registro"
        configureScrollView()
        
        scrollView.keyboardDismissMode = .onDrag
        //scrollView.keyboardDismissMode = .interactive
        
        txtApellidoPaterno.text = apellidoPaterno as String
        txtApellidoMaterno.text = apellidoMaterno as String
        txtNombres.text = nombres as String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    func textViewDidChange(_ textView: UITextView) {
        
        if textView == txtTituloPaso2 {
            let contentSize = textView.sizeThatFits(textView.bounds.size)
            var frame = textView.frame
            frame.size.height = contentSize.height
            textView.frame = frame
            
            let aspectRatioViewConstraint = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: textView, attribute: .width, multiplier: textView.bounds.height/textView.bounds.width, constant: 1)
            textView.addConstraint(aspectRatioViewConstraint)
            
        }
    }
    
    func configureScrollView(){
        
        let contentSize = scrollView.sizeThatFits(scrollView.bounds.size)
        var frame = scrollView.frame
        frame.size.height = contentSize.height
        scrollView.contentSize.height = frame.size.height
        
    }
    
    @IBAction func VolverAtras(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bntEnviar(_ sender: AnyObject) {
        //Grabar en webservice
        
        if txtNombres.text != "" && txtApellidoMaterno.text != "" && self.codPregunta != "" && txtNombres.text != "" && txtEmail.text != "" && txtRespuesta.text != "" && txtPassword.text != "" && txtConfirmEmail.text != "" && txtConfirmPassword.text != ""{
        
            if txtEmail.text == txtConfirmEmail.text{
                if txtPassword.text == txtConfirmPassword.text{
                    
                    guardarRegistro()
                    
                }else{
                    let alertController = UIAlertController(title: "¡Ups!", message: "Las contraseñas no coinciden", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                
            }else{
                let alertController = UIAlertController(title: "¡Ups!", message: "Las direcciones de correo electrónico no coinciden", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        
        }
        else{
            let alertController = UIAlertController(title: "¡Ups!", message: "Debe rellenar todos los campos", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func btnSeleccionPregunta(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Selección de pregunta", message: "Seleccione una pregunta secreta", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Lugar de nacimiento de la madre", style: .default, handler: {(alert: UIAlertAction) in
            
           self.txtPregSecreta.text = "Lugar de nacimiento de la madre"
            self.codPregunta = "1"
        }))
        alertController.addAction(UIAlertAction(title: "Primera mascota", style: .default, handler: {(alert: UIAlertAction) in
           self.txtPregSecreta.text = "Primera mascota"
            self.codPregunta = "2"
        }))
        alertController.addAction(UIAlertAction(title: "Nombre de abuela", style: .default, handler: {(alert: UIAlertAction) in
            self.txtPregSecreta.text = "Nombre de abuela"
            self.codPregunta = "3"
        }))
        alertController.addAction(UIAlertAction(title: "Canción preferida", style: .default, handler: {(alert: UIAlertAction) in
            self.txtPregSecreta.text = "Canción preferida"
            self.codPregunta = "4"
        }))
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present((alertController), animated: true, completion: nil)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self.scrollView.keyboardDismissMode
        //self.view.endEditing(true)
        
    }
    
    func guardarRegistro(){
        
        let run:String = self.run as String
        let correo: String = txtEmail.text!
        let contrasena:String = txtPassword.text!
        let codPregunta:String = (self.codPregunta ) as String
        let respuesta:String = txtRespuesta.text!
        
        
        
            let url:URL = URL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/registroPaso2?AspxAutoDetectCookieSupport=1")! // llamamos a la URl donde está el ws que se conectará con la BD
            let request:NSMutableURLRequest = NSMutableURLRequest(url: url) // componemos la URL con una var request y un NSMutableURLRequest y le pasamos como parámetros las vars
            request.httpMethod = "POST"
            let post:NSString = "run=\(run)&correo=\(correo)&contrasena=\(contrasena)&cod_pregunta=\(codPregunta)&respuesta=\(respuesta)" as NSString // se mete el user y pass dentro de un string
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
                        
                        let alertController = UIAlertController(title: "Confirmación", message: "Se realizó el registro con éxito, se ha enviado un mensaje al mail indicado para validar la cuenta", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {(alert: UIAlertAction) in
                            
                            self.dismiss(animated: true, completion: nil)
                            
                            
                        }))
                        
                        
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                    } else {
                        let error_msg:NSString = "Run o Password incorrectos"
                        
                        let alertController = UIAlertController(title: "¡Ups!", message: error_msg as String, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                } else {
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
