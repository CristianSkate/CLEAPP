//
//  ViewController.swift
//  Centro de Liderazgo Ejercito de Chile
//
//  Created by Cristian Martinez Toledo on 30-09-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, NSXMLParserDelegate {

    
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imgLogo: UIImageView!
    
    var urlData:NSData!
    var parser = NSXMLParser()
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
    var response: NSURLResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarView = UIView(frame: CGRectMake(0, 0, 500, 22))
        statusBarView.backgroundColor = UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.view.addSubview(statusBarView)
        self.preferredStatusBarStyle()
        imgLogo.image =  UIImage(named: "Logo")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


    @IBAction func btnIniciarSesion(sender: AnyObject) {
        iniciarSesion()
    }
    
    
    @IBAction func cancelar(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func iniciarSesion() {
        
        let user:NSString = txtUsuario.text!
        let pass: NSString = txtPassword.text!
        
        if(user == "") || (pass == "") {
            
            let alertController = UIAlertController(title: "¡Ups!", message: "Debe ingresar run sin puntos y contraseña", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }else{
            
            let url:NSURL = NSURL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/Login?AspxAutoDetectCookieSupport=1")! // llamamos a la URl donde está el ws que se conectará con la BD
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url) // componemos la URL con una var request y un NSMutableURLRequest y le pasamos como parámetros las vars
            request.HTTPMethod = "POST"
            let post:NSString = "run=\(user)&pass=\(pass)" // se mete el user y pass dentro de un string
            NSLog("PostData: %@",post) // mandamos al log para ir registrando lo que va pasando
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)! // codificamos lo que se envía
            let postLength:NSString = String( postData.length ) // se determina el largo del string
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("cle.ejercito.cl", forHTTPHeaderField: "Host")
            
            // hacemos la conexion
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
            } catch let error as NSError {
                self.responseError = error
                urlData = nil
            }
            
            // se valida
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
          
                NSLog("Response code: %ld", res.statusCode)
                if res.statusCode == 500 && intento == 1 {
                    intento += 1
                    iniciarSesion()
                    return
                    
                }
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    let responseData:NSString  = NSString(data:urlData!, encoding: NSUTF8StringEncoding)!
                   
                    NSLog("Response ==> %@", responseData);
                    
                    
                    // obtenemos de json el valor success y lo tratamos cono int
                    var success:NSInteger = 0
                    
                    parsearXML()
                    if (resp.isEqualToString("Error")){
                       success = 0
                    }else{
                       success = 1
                    }
                    
                    if(success == 1)
                    {
                        NSLog("Login Correcto");
                        // guardamos en la caché
                        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        // tomamos el nombre de usuario y lo guardamos
                        prefs.setObject(user, forKey: "RUN")
                        // también si está logeado
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        // se sincroniza
                        prefs.setValue(apellidoMaterno, forKey: "APELLIDOMATERNO")
                        prefs.setValue(apellidoPaterno, forKey: "APELLIDOPATERNO")
                        prefs.setValue(nombre, forKey: "NOMBRE")
                        prefs.synchronize()
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        let error_msg:NSString = "Run o Password incorrectos"
                        
                        let alertController = UIAlertController(title: "¡Ups!", message: error_msg as String, preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    
                } else {
                    let alertController = UIAlertController(title: "¡Ups!", message: "Conexión fallida", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                let alertController = UIAlertController(title: "¡Ups!", message: "Conexión fallida", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                
                if let error = responseError {
                    alertController.message = (error.localizedDescription)
                }
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // funcion que la que limpiamos los campos de texto
    
    @IBAction func limpiar(sender: UIButton) {
        
        let user:NSString = txtUsuario.text!
        let pass: NSString = txtPassword.text!
        
        if((user != "") || (pass != "")){
            
            txtUsuario.text = ""
            txtPassword.text = ""
        }
    }
    
    //funciones para parsear la respuesta XML
    func parsearXML() {
        posts = []
        parser =  NSXMLParser(data: urlData!)
        parser.delegate =  self
        parser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element =  elementName
        if(elementName=="paterno" || elementName=="materno" || elementName=="nombres" || elementName == "resp")
        {
            passData=true;
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        element="";
        if(elementName=="paterno" || elementName=="materno" || elementName=="nombres" || elementName == "resp")
        {
            passData=false;
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if (passData) {
            
            if element.isEqualToString("paterno"){
                apellidoPaterno = string
                NSLog("Apellido paterno ==> %@", string)
            }else if element.isEqualToString("materno") {
                apellidoMaterno = string
                NSLog("Apellido materno ==> %@", string)
            }else if element.isEqualToString("nombres"){
                nombre = string
                NSLog("Nombres ==> %@", string)
            }else if element.isEqualToString("resp"){
                resp = string
                NSLog("Error ==> %@", string)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

