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
    var response: NSURLResponse?
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var encuestasPendientes:NSArray! = []
    var rutSeleccionado:String!
    var codRelacionSel:String!
    @IBOutlet weak var tblEncuestasPendientes: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mis Encuestas"
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Acualizar", style: .Plain, target: self, action: "cargarMisEncuestas")
        
        tblEncuestasPendientes.dataSource = self
        tblEncuestasPendientes.delegate = self
        tblEncuestasPendientes.rowHeight = UITableViewAutomaticDimension
        tblEncuestasPendientes.estimatedRowHeight =  50
        
        var image = UIImage(named: "Menu")
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "btnMenu:")

        preCargarEncuestas()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewDidAppear(animated: Bool) {
//        cargarMisEncuestas()
//    }
    
    @IBAction func btnMenu(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    func preCargarEncuestas(){
        
        encuestasPendientes = prefs.arrayForKey("ENCUESTASPENDIENTES")
        
        if (encuestasPendientes == nil) {
            cargarMisEncuestas()
        }
    }

    
    func cargarMisEncuestas(){
        
        //Variable prefs para obtener preferencias guardadas
        let rut:String = prefs.valueForKey("RUN") as! String
        let periodo:String = "0"
        
        
            // se mete el user y pass dentro de un string
            let post:NSString = "runEvaluador=\(rut)&periodo=\(periodo)"
            
            // mandamos al log para ir registrando lo que va pasando
            NSLog("PostData: %@",post);
            
            // llamamos a la URl donde está el json que se conectará con la BD
            let url:NSURL = NSURL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/ObtenerEvaluacionesJson?AspxAutoDetectCookieSupport=1")!
            
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
                    
                    encuestasPendientes = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers )) as! NSArray
                    prefs.setObject(encuestasPendientes, forKey: "ENCUESTASPENDIENTES")
                    prefs.synchronize()
                    self.tblEncuestasPendientes.reloadData()
                    
                    NSLog("Trae Datos");
                    // guardamos en la caché
                    //let registros:NSArray = jsonData.valueForKey("") as! NSArray
                    print(encuestasPendientes)
                    
                        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if encuestasPendientes == nil {
            encuestasPendientes = []
        }
        return encuestasPendientes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let mycell:CeldaMisEncuestasTableViewCell = tableView.dequeueReusableCellWithIdentifier("CeldaMisEncuestas", forIndexPath: indexPath) as! CeldaMisEncuestasTableViewCell
        
        mycell.txtNombreEncuestado.text = encuestasPendientes[indexPath.row].valueForKey("nombreEvaluado") as? String
        
        if encuestasPendientes[indexPath.row].valueForKey("estado") as? String == "Finalizada" {
            mycell.btnResponder.setTitle("Finalizado", forState: UIControlState.Normal)
            mycell.btnResponder.enabled = false
        }else{
            mycell.btnResponder.setTitle("Evaluar", forState: .Normal)
            mycell.btnResponder.tag = indexPath.row
            mycell.btnResponder.addTarget(self, action: "irAEncuesta:", forControlEvents: .TouchUpInside)
            mycell.btnResponder.enabled = true
        }
        
        return mycell
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func irAEncuesta(sender: UIButton) {
        rutSeleccionado = encuestasPendientes[sender.tag].valueForKey("runEvaluado") as? String
        codRelacionSel = encuestasPendientes[sender.tag].valueForKey("cod_relacion") as? String
        // Funcion para mostrar el segue de la encuesta.
        self.performSegueWithIdentifier("empezarInstructivo", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "empezarInstructivo" {
            let vc = segue.destinationViewController as! MantenedorInstructivoViewController
            vc.rutEvaluado = self.rutSeleccionado
            vc.codRelacionSel = self.codRelacionSel
            print(codRelacionSel)
        }
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    @IBAction func unwindToMisEncuestas(segue: UIStoryboardSegue) {
        
    }
}
