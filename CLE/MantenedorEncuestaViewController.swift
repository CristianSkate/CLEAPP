//
//  MantenedorEncuestaViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 18-11-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit
import ObjectMapper

class MantenedorEncuestaViewController: UIViewController, UIPageViewControllerDataSource{

    var pageViewController:UIPageViewController!
//    var encuesta:Encuesta!
//    var secciones:[Seccion]!
    var respuestas:NSArray!
    var preguntas:NSArray!
    // Variables para el json
//    var reponseError: NSError?
//    var response: NSURLResponse?
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var preguntasJson:NSDictionary! = nil
    var respuestasJson:Respuestas = Respuestas(rutEvaluador: "", rutEvaluado: "", respuestas: [])
    var rutEvaluado:String!
    var rutEvaluador:String!
//    var codRelacionSel:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Salir", style: .Plain, target: self, action: "volverAtras")
        self.title = "Encuesta"
        preCargarDatos()
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        rutEvaluador = prefs.valueForKey("RUN") as! String
        
        //INICIALIZACION DE RESPUESTAS
//        respuestasJson = (prefs.valueForKey("resp\(rutEvaluador)\(rutEvaluador)") as? Respuestas)!
        if  prefs.valueForKey("resp\(rutEvaluador)\(rutEvaluado)") == nil{
            respuestasJson = Respuestas(rutEvaluador: rutEvaluador, rutEvaluado: rutEvaluado, respuestas: [])
            prefs.setObject(Mapper().toJSONString(respuestasJson, prettyPrint: false)!, forKey: "resp\(rutEvaluador)\(rutEvaluado)")
        }else{
            respuestasJson = Mapper<Respuestas>().map(prefs.valueForKey("resp\(rutEvaluador)\(rutEvaluado)") as! String)!
        }
        
        self.pageViewController.dataSource = self
        if respuestasJson.respuestas!.count < 100 {
            let initialContenViewController = self.preguntaAtIndex(respuestasJson.respuestas!.count) as FormatoEncuestaViewController
        
            let viewControllers = NSArray(object: initialContenViewController)
            self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        }else{
            self.performSegueWithIdentifier("empezarPreguntasAbiertas", sender: nil)
        }
        
        
        
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
        let alertController = UIAlertController(title: "Confirmación", message: "Al presionar Si guardará los cambios para continuar más tarde, ¿Desea continuar?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Si", style: .Default, handler: {(alert: UIAlertAction) in
            self.performSegueWithIdentifier("unwindToMisEncuestas", sender: self)
//          self.navigationController?.popViewControllerAnimated(true)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        self.presentViewController((alertController), animated: true, completion: nil)
        
    }
    func preCargarDatos(){
        
//        //preguntasJson? = (prefs.objectForKey("PREGUNTAS") as? NSDictionary)!
//        
//        if (prefs.objectForKey("PREGUNTAS\(codRelacionSel)") == nil) {
//            cargarDatos()
//        }else{
            //preguntasJson = prefs.objectForKey("PREGUNTAS\(codRelacionSel)") as? NSDictionary
            preguntas =  preguntasJson.valueForKey("preguntas") as!  NSArray
            respuestas = preguntas.valueForKey("respuestas") as! NSArray
//        }
    }
    
//    func cargarDatos(){
//        
//        //Variable prefs para obtener preferencias guardadas
//        //let id:String = "1" //runEvaluador, runEvaluado
//        
//        
//        // se mete el user y pass dentro de un string
//        //let post:NSString = "run_evaluador=\(rutEvaluador)&run_evaluado=\(rutEvaluado)"//"id=\(id)"
//        
//        let post:NSString = "relacion=\(codRelacionSel)"
//        
//        // mandamos al log para ir registrando lo que va pasando
//        NSLog("PostData: %@",post);
//        
//        // llamamos a la URl donde está el json que se conectará con la BD
//        let url:NSURL = NSURL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/ObtenerEncuestaRelacion?AspxAutoDetectCookieSupport=1")!
//        
//        // codificamos lo que se envía
//        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
//        
//        // se determina el largo del string
//        let postLength:NSString = String( postData.length )
//        
//        // componemos la URL con una var request y un NSMutableURLRequest y le pasamos como parámetros las vars
//        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
//        request.HTTPMethod = "POST"
//        request.HTTPBody = postData
//        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        
//        
//        // hacemos la conexion
//        var urlData: NSData?
//        do {
//            urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
//        } catch let error as NSError {
//            reponseError = error
//            urlData = nil
//        }
//        
//        // se valida
//        if ( urlData != nil ) {
//            let res = response as! NSHTTPURLResponse!;
//            
//            NSLog("Response code: %ld", res.statusCode);
//            
//            if (res.statusCode >= 200 && res.statusCode < 300)
//            {
//                let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
//                
//                NSLog("Response ==> %@", responseData);
//                
//                //var error: NSError?
//                
//                preguntasJson = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers )) as! NSDictionary
//
//                prefs.setObject(preguntasJson, forKey: "PREGUNTAS\(codRelacionSel)")
//                prefs.synchronize()
//                preguntas =  preguntasJson.valueForKey("preguntas") as!  NSArray //Agregar identificador
//                respuestas = preguntas.valueForKey("respuestas") as! NSArray // agregar identificador unico
//                
//                
//                
//                
//                NSLog("Trae Datos");
//                // guardamos en la caché
//                //let registros:NSArray = jsonData.valueForKey("") as! NSArray
//                print(preguntas)
//                
//                
//                self.dismissViewControllerAnimated(true, completion: nil)
//            } else {
//                let alertController = UIAlertController(title: "¡Ups!", message: "Hubo un problema conectando al servidor", preferredStyle: .Alert)
//                alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
//                self.presentViewController(alertController, animated: true, completion: nil)
//            }
//            
//        } else {
//            let alertView:UIAlertView = UIAlertView()
//            alertView.title = "Acceso incorrecto"
//            alertView.message = "Conneción Fallida"
//            alertView.delegate = self
//            alertView.addButtonWithTitle("OK")
//            alertView.show()
//        }
//        
//        
//        
////        self.preguntas =  ["Actúo en concordancia con las normas institucionales.","Cumplo con mis tareas de acuerdo a lo establecido.","Privilegio el interés del Ejército sobre el propio."]
////        self.respuestas =  ["Insuficiente","Básico","Adecueado","Influyente"]
////        self.secciones = [Seccion(titulo: "Compromiso", instructivo: "En esta sección, usted encontrará una serie de frases o afirmaciones referentes a diversos aspectos relacionados con las conductas y habilidades que forman parte del MILE, las cuales le solicitamos leer cuidadosamente. Frente a cada frase, usted debe marcar la alternativa que mejor represente su opinión de acuerdo a 4 opciones de respuesta que expresan los siguientes niveles para la evaluación:\nINSUFICIENTE: la conducta o habilidad se manifiesta casi nunca o nunca.\nBÁSICO: la conducta o habilidad se manifiesta ocasionalmente o en forma irregular.\nADECUADO: la conducta o habilidad se manifiesta en forma regular o consistente.\nINFLUYENTE: la conducta o habilidad se manifiesta en forma regular o consistente y además la persona es un ejemplo o modelo para otros.\nPor ejemplo, si usted considera que el evaluado(a) manifiesta la habilidad de manera consistente y además es un modelo a seguir, usted debería marcar en el casillero que indica el nivel 'Influyente'.", preguntas: self.preguntas, respuestas: self.respuestas)]
////        
////        self.encuesta =  Encuesta(secciones: self.secciones, version: 1)
//        
//    }
    
    func preguntaAtIndex(index: Int) ->FormatoEncuestaViewController
    {
        
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FormatoEncuestaViewController") as! FormatoEncuestaViewController
        
        pageContentViewController.respuestas =  respuestas[index].valueForKey("respuesta") as! [String]
        pageContentViewController.pregunta = preguntas[index].valueForKey("pregunta") as! String
        pageContentViewController.codPregunta = preguntas[index].valueForKey("id") as! String
        //pageContentViewController.tituloSeccion = secciones[0].titulo
        pageContentViewController.pageIndex = index
        
        
        return pageContentViewController
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        //        let viewController = viewController as! HolderViewController
        //        var index = viewController.pageIndex as Int
        //
        //        if(index == 0 || index == NSNotFound)
        //        {
        //            return nil
        //        }
        //
        //        index--
        
        return nil//self.pageTutorialAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
//                let viewController = viewController as! FormatoEncuestaViewController
//                var index = viewController.pageIndex as Int
//        
//                if((index == NSNotFound))
//                {
//                    return nil
//                }
//        
//                index++
//        
//                if(index == preguntas.count)
//                {
//                    return nil
//                }
        
        return nil//self.preguntaAtIndex(index)
    }
    
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return preguntas.count
    }
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    func btnSiguiente(index: Int, codResp:String, respSel:String){
        
        //GUARDADO DE ERESPUESTAS
        respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: codResp, codRespuesta: respSel))
        prefs.setObject(Mapper().toJSONString(respuestasJson, prettyPrint: false)!, forKey: "resp\(rutEvaluador)\(rutEvaluado)")
        
        
        var index = index
        index++
        if(!(index == NSNotFound) && !(index == preguntas.count)){
            
            let viewControllers = NSArray(object: preguntaAtIndex(index))
            self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            
            //self.pageTutorialAtIndex(index)
        }else
        {
//            let alertController =  UIAlertController(title: "Fin de la encuesta", message: "Ha finalizado la encuesta", preferredStyle: .Alert)
//            alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler:{(alert: UIAlertAction) in
            
                //IR A PREGUNTAS ABIERTAS
                self.performSegueWithIdentifier("empezarPreguntasAbiertas", sender: nil)
                //self.performSegueWithIdentifier("unwindToMisEncuestas", sender: self)
                //self.navigationController?.popViewControllerAnimated(true)
//            }))
            
//            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
        //        let alertController =  UIAlertController(title: "Mensaje", message: "Hola", preferredStyle: .Alert)
        //        alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
        //        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "empezarPreguntasAbiertas" {
            let vc = segue.destinationViewController as! MantenedorPregAbiertasViewController
            //vc.preguntasJson = preguntasJson
            vc.rutEvaluado = self.rutEvaluado
            //vc.rutEvaluado = self.rutSeleccionado
            //            vc.codRelacionSel = self.codRelacionSel
            //            print(codRelacionSel)
        }
    }


}
