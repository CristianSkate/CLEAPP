//
//  InicioViewController.swift
//  Centro de Liderazgo Ejercito de Chile
//
//  Created by Cristian Martinez Toledo on 30-09-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit
import ObjectMapper

class InicioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblNoticias: UITableView!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    var image:UIImage!
    var noticias:[Noticia] = []
    var noticiaSeleccionada:Noticia!
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var reponseError: NSError?
    var response: NSURLResponse?
    var respNoticias:NSArray! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Noticias"
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Actualizar", style: .Plain, target: self, action: #selector(InicioViewController.cargarNoticias))

        var image = UIImage(named: "Menu")
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(InicioViewController.btnMenu(_:)))
        tblNoticias.dataSource = self
        tblNoticias.delegate = self
        //cargarNoticias()
        preCargarNoticias()
        
        //PRUEBA DE PARSING DE JSON
//        let respuestas:Respuestas = Respuestas(rutEvaluador: "11111111-1", rutEvaluado: "11111111-1", respuestas: [Respuestas.respuestasFin(codPregunta: "ABC_123", codRespuesta: "1"), Respuestas.respuestasFin(codPregunta: "ASD_321", codRespuesta: "2")])
//        let jsonString:String = Mapper().toJSONString(respuestas, prettyPrint: false)!
//            
//        print(jsonString)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewDidAppear(animated: Bool) {
    
    }
    
    @IBAction func btnMenu(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticias.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let mycell:CeldaNoticiasTableViewCell = tableView.dequeueReusableCellWithIdentifier("CeldaNoticias", forIndexPath: indexPath) as! CeldaNoticiasTableViewCell
        
        mycell.txtTitulo.text = noticias[indexPath.row].txtTitulo
        mycell.txtResumen.text = noticias[indexPath.row].txtNoticia
        mycell.txtResumen.textAlignment = .Justified
        let url = NSURL(string: "http://cle.ejercito.cl/upload/_\(noticias[indexPath.row].urlImagen)")
        
        if let image = url?.cachedImage{
            mycell.imgImagen.image = image
            mycell.imgImagen.alpha = 1
        }else {
            mycell.imgImagen.alpha = 0
            url!.fetchImage { image in
            mycell.imgImagen.image = image
            UIView.animateWithDuration(0.3) {
            mycell.imgImagen.alpha = 1
                }
            }
        }
        
        return mycell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        noticiaSeleccionada = noticias[indexPath.row]
        self.performSegueWithIdentifier("detalleNoticia", sender: nil)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detalleNoticia"){
            let vc = segue.destinationViewController as! DetalleNoticiaViewController
            vc.noticia = noticiaSeleccionada
        }
    }
    
    func preCargarNoticias(){
            
        respNoticias = prefs.arrayForKey("NOTICIAS")
        
        if (respNoticias == nil) {
            cargarNoticias()
        }else{
            noticias.removeAll()
            for noticia in respNoticias{
                noticias.append(Noticia(urlImagen: (noticia.valueForKey("Imagen") as? String)!, txtTitulo: (noticia.valueForKey("Titulo") as? String)!, txtResumen: (noticia.valueForKey("Resumen") as? String)!, txtNoticia: (noticia.valueForKey("Completa") as? String)!))
            }
        }
    }
    
    func cargarNoticias(){
        
        let post:NSString = ""
        
        // mandamos al log para ir registrando lo que va pasando
        NSLog("PostData: %@",post);
        
        // llamamos a la URl donde está el json que se conectará con la BD
        let url:NSURL = NSURL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/noticiasJson?AspxAutoDetectCookieSupport=1")!
        
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
                
                respNoticias = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers )) as! NSArray
                noticias.removeAll()
                prefs.setValue(respNoticias, forKeyPath: "NOTICIAS")
                for noticia in respNoticias{
                    noticias.append(Noticia(urlImagen: (noticia.valueForKey("Imagen") as? String)!, txtTitulo: (noticia.valueForKey("Titulo") as? String)!, txtResumen: (noticia.valueForKey("Resumen") as? String)!, txtNoticia: (noticia.valueForKey("Completa") as? String)!))
                }
                
                self.tblNoticias.reloadData()
                
                NSLog("Trae Datos");
                
                print(respNoticias)
                
                
                self.dismissViewControllerAnimated(true, completion: nil)
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
