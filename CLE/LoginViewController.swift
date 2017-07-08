//
//  ViewController.swift
//  Centro de Liderazgo Ejercito de Chile
//
//  Created by Cristian Martinez Toledo on 30-09-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, XMLParserDelegate {

    
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imgLogo: UIImageView!
    
    var urlData:Data!
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var passData =  false
    var nombre:NSString = ""
    var apellidoPaterno:NSString = ""
    var apellidoMaterno:NSString = ""
    var resp:NSString = ""
    var responseError:NSError?
    var intento = 1
    var response: URLResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 22))
        //statusBarView.backgroundColor = UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        statusBarView.backgroundColor = UIColor(red: 128.0/255.0, green: 80.0/255.0, blue: 04.0/255.0, alpha: 1.0)
        self.view.addSubview(statusBarView)
        self.preferredStatusBarStyle
        imgLogo.image =  UIImage(named: "Logo")
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


    @IBAction func btnIniciarSesion(_ sender: AnyObject) {
        iniciarSesion()
    }
    
    
    @IBAction func cancelar(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func iniciarSesion() {
        
        let user:NSString = txtUsuario.text! as NSString
        let pass: NSString = txtPassword.text! as NSString
        
        if(user == "") || (pass == "") {
            
            let alertController = UIAlertController(title: "¡Ups!", message: "Debe ingresar run sin puntos y contraseña", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            
            let url:URL = URL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/Login?AspxAutoDetectCookieSupport=1")! // llamamos a la URl donde está el ws que se conectará con la BD
            let request:NSMutableURLRequest = NSMutableURLRequest(url: url) // componemos la URL con una var request y un NSMutableURLRequest y le pasamos como parámetros las vars
            request.httpMethod = "POST"
            let post:NSString = "run=\(user)&pass=\(pass)" as NSString // se mete el user y pass dentro de un string
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
                if res?.statusCode == 500 && intento == 1 {
                    intento += 1
                    iniciarSesion()
                    return
                    
                }
                
                if ((res?.statusCode)! >= 200 && (res?.statusCode)! < 300)
                {
                    let responseData:NSString  = NSString(data:urlData!, encoding: String.Encoding.utf8.rawValue)!
                   
                    NSLog("Response ==> %@", responseData);
                    
                    
                    // obtenemos de json el valor success y lo tratamos cono int
                    var success:NSInteger = 0
                    
                    parsearXML()
                    if (resp.isEqual(to: "Error")){
                       success = 0
                    }else{
                       success = 1
                    }
                    
                    if(success == 1)
                    {
                        NSLog("Login Correcto");
                        // guardamos en la caché
                        let prefs:UserDefaults = UserDefaults.standard
                        // tomamos el nombre de usuario y lo guardamos
                        prefs.set(user, forKey: "RUN")
                        // también si está logeado
                        prefs.set(1, forKey: "ISLOGGEDIN")
                        // se sincroniza
                        prefs.setValue(apellidoMaterno, forKey: "APELLIDOMATERNO")
                        prefs.setValue(apellidoPaterno, forKey: "APELLIDOPATERNO")
                        prefs.setValue(nombre, forKey: "NOMBRE")
                        prefs.synchronize()
                        
                        
                        
                        self.dismiss(animated: true, completion: nil)
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
    
    // funcion que la que limpiamos los campos de texto
    
    @IBAction func limpiar(_ sender: UIButton) {
        
        let user:NSString = txtUsuario.text! as NSString
        let pass: NSString = txtPassword.text! as NSString
        
        if((user != "") || (pass != "")){
            
            txtUsuario.text = ""
            txtPassword.text = ""
        }
    }
    
    
    @IBAction func btnRegistrarse(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "irARegistrarse", sender: nil)
        
    }
    
    
    //funciones para parsear la respuesta XML
    func parsearXML() {
        posts = []
        parser =  XMLParser(data: urlData!)
        parser.delegate =  self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element =  elementName as NSString
        if(elementName=="paterno" || elementName=="materno" || elementName=="nombres" || elementName == "resp")
        {
            passData=true;
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        element="";
        if(elementName=="paterno" || elementName=="materno" || elementName=="nombres" || elementName == "resp")
        {
            passData=false;
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (passData) {
            
            if element.isEqual(to: "paterno"){
                apellidoPaterno = string as NSString
                NSLog("Apellido paterno ==> %@", string)
            }else if element.isEqual(to: "materno") {
                apellidoMaterno = string as NSString
                NSLog("Apellido materno ==> %@", string)
            }else if element.isEqual(to: "nombres"){
                nombre = string as NSString
                NSLog("Nombres ==> %@", string)
            }else if element.isEqual(to: "resp"){
                resp = string as NSString
                NSLog("Error ==> %@", string)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
}

