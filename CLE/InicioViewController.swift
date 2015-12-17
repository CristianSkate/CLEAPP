//
//  InicioViewController.swift
//  Centro de Liderazgo Ejercito de Chile
//
//  Created by Cristian Martinez Toledo on 30-09-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class InicioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblNoticias: UITableView!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    var image:UIImage!
    var noticias:[Noticia] = []
    
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

        var image = UIImage(named: "Menu")
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "btnMenu:")
        
        cargarNoticias()
        for var i = 0; i < 5 ; i = i + 1  {
          //  noticias.append(Noticia(imagen: UIImage(named: "noticia1")!, txtTitulo: "MILE EJECUTA TALLERES EN UNIDADES DE LA FUERZA TERRESTRE", txtResumen: "Los integrantes del proyecto “Modelo Integral de Liderazgo del Ejército” (MILE), efectuaron talleres de desarrollo de liderazgo con las unidades de la Fuerza Terrestre, ubicadas en las ciudades de Temuco, Osorno y Valdivia.", txtNoticia: "asd"))
        }
        
        // asignar datasource y delegate a la tabla
        tblNoticias.dataSource = self
        tblNoticias.delegate = self
        //tblNoticias.rowHeight = UITableViewAutomaticDimension
        //tblNoticias.estimatedRowHeight =  50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        //mycell.imgImagen.image = noticias[indexPath.row].imagen
        mycell.txtResumen.text = noticias[indexPath.row].txtNoticia
        let url = NSURL(string: "http://cle.ejercito.cl/upload/_\(noticias[indexPath.row].urlImagen)")
        let data = NSData(contentsOfURL : url!)
        let image = UIImage(data : data!)
        mycell.imgImagen.image = image
        
        return mycell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func cargarNoticias(){
        
        //Variable prefs para obtener preferencias guardadas
        
        // se mete el user y pass dentro de un string
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
                
                //var error: NSError?
                
                respNoticias = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers )) as! NSArray
                
                for noticia in respNoticias{
                    noticias.append(Noticia(urlImagen: (noticia.valueForKey("Imagen") as? String)!, txtTitulo: (noticia.valueForKey("Titulo") as? String)!, txtResumen: (noticia.valueForKey("Resumen") as? String)!, txtNoticia: (noticia.valueForKey("Completa") as? String)!))
                }
                
                
                
                NSLog("Trae Datos");
                // guardamos en la caché
                //let registros:NSArray = jsonData.valueForKey("") as! NSArray
                print(respNoticias)
                
                
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
        
    }

}
