//
//  MantenedorPregAbiertasViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 29-02-16.
//  Copyright © 2016 Cristian Martinez Toledo. All rights reserved.
//

import UIKit
import ObjectMapper

class MantenedorPregAbiertasViewController: UIViewController, UIPageViewControllerDataSource {

    var pageViewController:UIPageViewController!
    var respuestas:NSArray!
    var preguntas:NSArray!
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
        if  prefs.valueForKey("resp\(rutEvaluador)\(rutEvaluador)") == nil{
            respuestasJson = Respuestas(rutEvaluador: rutEvaluador, rutEvaluado: rutEvaluado, respuestas: [])
            prefs.setObject(Mapper().toJSONString(respuestasJson, prettyPrint: false)!, forKey: "resp\(rutEvaluador)\(rutEvaluador)")
        }else{
            respuestasJson = Mapper<Respuestas>().map(prefs.valueForKey("resp\(rutEvaluador)\(rutEvaluador)") as! String)!
        }
        
        self.pageViewController.dataSource = self
        
        let initialContenViewController = self.preguntaAtIndex(respuestasJson.respuestas!.count) as FormatoEncuestaViewController
        
        let viewControllers = NSArray(object: initialContenViewController)
        
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height-10)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        //print(rutEvaluado)
        //print(codRelacionSel)
        // Do any additional setup after loading the view.


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
        prefs.setObject(Mapper().toJSONString(respuestasJson, prettyPrint: false)!, forKey: "resp\(rutEvaluador)\(rutEvaluador)")
        
        
        var index = index
        index++
        if(!(index == NSNotFound) && !(index == preguntas.count)){
            
            let viewControllers = NSArray(object: preguntaAtIndex(index))
            self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            
            //self.pageTutorialAtIndex(index)
        }else
        {
            let alertController =  UIAlertController(title: "Fin de la encuesta", message: "Ha finalizado la encuesta", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler:{(alert: UIAlertAction) in
                
                //IR AL FINAL DE LA ENCUESTA
                self.performSegueWithIdentifier("empezarPreguntasAbiertas", sender: nil)
                //self.performSegueWithIdentifier("unwindToMisEncuestas", sender: self)
                //self.navigationController?.popViewControllerAnimated(true)
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
        //        let alertController =  UIAlertController(title: "Mensaje", message: "Hola", preferredStyle: .Alert)
        //        alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
        //        self.presentViewController(alertController, animated: true, completion: nil)
    }


   

}
