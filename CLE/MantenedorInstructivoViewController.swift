//
//  MantenedorInstructivoViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 16-02-16.
//  Copyright © 2016 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class MantenedorInstructivoViewController: UIViewController, UIPageViewControllerDataSource {

    var pageViewController:UIPageViewController!
    //var encuesta:Encuesta!
    //var secciones:[Seccion]!
    var respuestas:NSArray!
    var preguntas:NSArray!
    var instructivos:[Instructivo] = []
    //Variables para el json
    var reponseError: NSError?
    var response: NSURLResponse?
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var preguntasJson:NSDictionary! = nil
    //Codigo de relacion para buscar la encuesta con los instructivos
    var codRelacionSel:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Salir", style: .Plain, target: self, action: "volverAtras")
        
        self.title = "Instructivos"
        preCargarDatos()
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        let initialContenViewController = self.instructivoAtIndex(0) as FormatoInstructViewController
        
        let viewControllers = NSArray(object: initialContenViewController)
        
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height-10)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        //print(rutEvaluado)
        //print(codRelacionSel)

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func volverAtras() {
        let alertController = UIAlertController(title: "Confirmación", message: "Al presionar si volverá al listado de encuestas pendientes, ¿Desea continuar?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Si", style: .Default, handler: {(alert: UIAlertAction) in
            self.navigationController?.popViewControllerAnimated(true)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        self.presentViewController((alertController), animated: true, completion: nil)
        
    }
    
    func preCargarDatos(){
        
        //preguntasJson? = (prefs.objectForKey("PREGUNTAS") as? NSDictionary)!
        
        if (prefs.objectForKey("PREGUNTAS\(codRelacionSel)") == nil) {
            cargarDatos()
        }else{
            preguntasJson = prefs.objectForKey("PREGUNTAS\(codRelacionSel)") as? NSDictionary
            preguntas =  preguntasJson.valueForKey("preguntas") as!  NSArray
            respuestas = preguntas.valueForKey("respuestas") as! NSArray
            instructivos.append(Instructivo(titulo: preguntasJson.valueForKey("titulo_introduccion") as! String, cuerpo: preguntasJson.valueForKey("introduccion") as! String))
            instructivos.append(Instructivo(titulo: preguntasJson.valueForKey("titulo_competencias") as! String, cuerpo: preguntasJson.valueForKey("competencias") as! String))
            instructivos.append(Instructivo(titulo: preguntasJson.valueForKey("titulo_atributos") as! String, cuerpo: preguntasJson.valueForKey("atributos") as! String))
        }
    }
    
    func cargarDatos(){
        
        let post:NSString = "relacion=\(codRelacionSel)"
        
        // mandamos al log para ir registrando lo que va pasando
        NSLog("PostData: %@",post);
        
        // llamamos a la URl donde está el json que se conectará con la BD
        let url:NSURL = NSURL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/ObtenerEncuestaRelacion?AspxAutoDetectCookieSupport=1")!
        
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
                
                preguntasJson = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers )) as! NSDictionary
                
                prefs.setObject(preguntasJson, forKey: "PREGUNTAS\(codRelacionSel)")
                prefs.synchronize()
                preguntas =  preguntasJson.valueForKey("preguntas") as!  NSArray //Agregar identificador
                respuestas = preguntas.valueForKey("respuestas") as! NSArray // agregar identificador unico
                instructivos.append(Instructivo(titulo: preguntasJson.valueForKey("titulo_introduccion") as! String, cuerpo: preguntasJson.valueForKey("introduccion") as! String))
                instructivos.append(Instructivo(titulo: preguntasJson.valueForKey("titulo_competencias") as! String, cuerpo: preguntasJson.valueForKey("competencias") as! String))
                instructivos.append(Instructivo(titulo: preguntasJson.valueForKey("titulo_atributos") as! String, cuerpo: preguntasJson.valueForKey("atributos") as! String))
                
                
                
                NSLog("Trae Datos");
                // guardamos en la caché
                //let registros:NSArray = jsonData.valueForKey("") as! NSArray
                print(preguntas)
                
                
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
    
    func instructivoAtIndex(index: Int) ->FormatoInstructViewController
    {
        
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FormatoInstructViewController") as! FormatoInstructViewController
        
        pageContentViewController.titulo =  instructivos[index].titulo
        pageContentViewController.cuerpo = instructivos[index].cuerpo
        pageContentViewController.pageIndex = index
        
        
        return pageContentViewController
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return instructivos.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    func btnSiguiente(index: Int){
        
        var index = index
        index++
        if(!(index == NSNotFound) && !(index == instructivos.count)){
            
            let viewControllers = NSArray(object: instructivoAtIndex(index))
            self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            
        }else
        {
            self.performSegueWithIdentifier("empezarEncuesta", sender: nil)

        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "empezarEncuesta" {
            let vc = segue.destinationViewController as! MantenedorEncuestaViewController
            vc.preguntasJson = preguntasJson
            //vc.rutEvaluado = self.rutSeleccionado
//            vc.codRelacionSel = self.codRelacionSel
//            print(codRelacionSel)
        }
    }

}
