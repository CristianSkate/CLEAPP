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
    var respuestas:NSArray!
    var preguntas:NSArray!
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var preguntasJson:NSDictionary! = nil
    var respuestasJson:Respuestas = Respuestas(rutEvaluador: "", rutEvaluado: "", respuestas: [])
    var rutEvaluado:String!
    var rutEvaluador:String!
    
    var codResp:String!
    var respSel:String!
    var seleccion:Bool = false
    var indexPage:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Salir", style: .Plain, target: self, action: #selector(MantenedorEncuestaViewController.volverAtras))
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Siguiente", style: .Plain, target: self, action: #selector(MantenedorInstructivoViewController.btnSiguiente))
        
        self.title = "Encuesta"
        preCargarDatos()
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        rutEvaluador = prefs.valueForKey("RUN") as! String
        print (rutEvaluado)
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
     
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func volverAtras() {
        let alertController = UIAlertController(title: "Confirmación", message: "Al presionar Si guardará los cambios para continuar más tarde, ¿Desea continuar?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Si", style: .Default, handler: {(alert: UIAlertAction) in
            self.performSegueWithIdentifier("unwindToMisEncuestas", sender: self)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        self.presentViewController((alertController), animated: true, completion: nil)
        
    }
    func preCargarDatos(){
        
        preguntas =  preguntasJson.valueForKey("preguntas") as!  NSArray
        respuestas = preguntas.valueForKey("respuestas") as! NSArray

    }
    
    
    func preguntaAtIndex(index: Int) ->FormatoEncuestaViewController
    {
        
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FormatoEncuestaViewController") as! FormatoEncuestaViewController
        
        pageContentViewController.respuestas =  respuestas[index].valueForKey("respuesta") as! [String]
        pageContentViewController.pregunta = preguntas[index].valueForKey("pregunta") as! String
        pageContentViewController.codPregunta = preguntas[index].valueForKey("id") as! String
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
        return preguntas.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    func btnSiguiente(){ //(index: Int, codResp:String, respSel:String){
        
        
        if seleccion {
            //GUARDADO DE ERESPUESTAS
            respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: codResp, codRespuesta: respSel))
            prefs.setObject(Mapper().toJSONString(respuestasJson, prettyPrint: false)!, forKey: "resp\(rutEvaluador)\(rutEvaluado)")
        
        
            var index = indexPage
            index += 1
            if(!(index == NSNotFound) && !(index == preguntas.count)){
            
                let viewControllers = NSArray(object: preguntaAtIndex(index))
                self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            
            }else
            {
                //IR A PREGUNTAS ABIERTAS
                self.performSegueWithIdentifier("empezarPreguntasAbiertas", sender: nil)
            
            }
        }else{
            let AlertController = UIAlertController(title: "Mensaje", message: "Debes seleccionar una respuesta para avanzar", preferredStyle: .Alert)
            AlertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
            self.presentViewController(AlertController, animated: true, completion: nil)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "empezarPreguntasAbiertas" {
            let vc = segue.destinationViewController as! MantenedorPregAbiertasViewController
            vc.rutEvaluado = self.rutEvaluado
        }
    }


}
