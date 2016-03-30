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
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var preguntasJson:NSDictionary! = nil
    var respuestasJson:Respuestas = Respuestas(rutEvaluador: "", rutEvaluado: "", respuestas: [])
    var rutEvaluado:String!
    var rutEvaluador:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Salir", style: .Plain, target: self, action: "volverAtras")
        self.title = "Encuesta"

        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        rutEvaluador = prefs.valueForKey("RUN") as! String
        print(rutEvaluado)
        
        //INICIALIZACION DE RESPUESTAS
        if  prefs.valueForKey("resp\(rutEvaluador)\(rutEvaluado)") == nil{
            respuestasJson = Respuestas(rutEvaluador: rutEvaluador, rutEvaluado: rutEvaluado, respuestas: [])
            prefs.setObject(Mapper().toJSONString(respuestasJson, prettyPrint: false)!, forKey: "resp\(rutEvaluador)\(rutEvaluado)")
        }else{
            respuestasJson = Mapper<Respuestas>().map(prefs.valueForKey("resp\(rutEvaluador)\(rutEvaluado)") as! String)!
        }
        
        self.pageViewController.dataSource = self
        if respuestasJson.respuestas!.count < 107 {
        
            let initialContenViewController = self.preguntaAtIndex(0) as FormatoPregAbiertaViewController
            let viewControllers = NSArray(object: initialContenViewController)
            self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)

        }else{
            self.performSegueWithIdentifier("irAFinDeEncuesta", sender: nil)
        }
        self.pageViewController.view.frame = CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height-10)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func volverAtras() {
        let alertController = UIAlertController(title: "Confirmación", message: "Al presionar Si guardará los cambios para continuar más tarde, ¿Desea continuar?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Si", style: .Default, handler: {(alert: UIAlertAction) in
            self.performSegueWithIdentifier("unwindToMisEncuestas", sender: self)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        self.presentViewController((alertController), animated: true, completion: nil)
        
    }
    
    func preguntaAtIndex(index: Int) ->FormatoPregAbiertaViewController
    {
        
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FormatoPregAbiertaViewController") as! FormatoPregAbiertaViewController
        
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
        return 1
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    func btnSiguiente(index: Int, resp1a:String, resp1b:String, resp1c:String, resp2a:String, resp2b:String, resp2c:String, resp3:String){
        
        //GUARDADO DE ERESPUESTAS
        respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: "fortaleza1", codRespuesta: resp1a))
        respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: "fortaleza2", codRespuesta: resp1b))
        respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: "fortaleza3", codRespuesta: resp1c))
        respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: "mejora1", codRespuesta: resp2a))
        respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: "mejora2", codRespuesta: resp2b))
        respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: "mejora3", codRespuesta: resp2c))
        respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: "comentario", codRespuesta: resp3))

        prefs.setObject(Mapper().toJSONString(respuestasJson, prettyPrint: false)!, forKey: "resp\(rutEvaluador)\(rutEvaluado)")
        print(Mapper().toJSONString(respuestasJson, prettyPrint: false)!)
        
        
        var index = index
        index++
        if(!(index == NSNotFound) && !(index == 1)){
            
            let viewControllers = NSArray(object: preguntaAtIndex(index))
            self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            
        }else
        {
            //IR AL FINAL DE LA ENCUESTA
            self.performSegueWithIdentifier("irAFinDeEncuesta", sender: nil)
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "irAFinDeEncuesta"{
            let vc = segue.destinationViewController as! FinEncuestaViewController
            vc.rutEvaluado = rutEvaluado
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
   

}
