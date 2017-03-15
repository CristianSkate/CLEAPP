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
    let prefs:UserDefaults = UserDefaults.standard
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Salir", style: .plain, target: self, action: #selector(MantenedorEncuestaViewController.volverAtras))
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Siguiente", style: .plain, target: self, action: #selector(MantenedorInstructivoViewController.btnSiguiente))
        
        self.title = "Encuesta"
        preCargarDatos()
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        
        rutEvaluador = prefs.value(forKey: "RUN") as! String
        print (rutEvaluado)
        //INICIALIZACION DE RESPUESTAS
//        respuestasJson = (prefs.valueForKey("resp\(rutEvaluador)\(rutEvaluador)") as? Respuestas)!
        if  prefs.value(forKey: "resp\(rutEvaluador)\(rutEvaluado)") == nil{
            respuestasJson = Respuestas(rutEvaluador: rutEvaluador, rutEvaluado: rutEvaluado, respuestas: [])
            prefs.set(Mapper().toJSONString(respuestasJson, prettyPrint: false)!, forKey: "resp\(rutEvaluador)\(rutEvaluado)")
        }else{
            respuestasJson = Mapper<Respuestas>().map(prefs.value(forKey: "resp\(rutEvaluador)\(rutEvaluado)") as! String)!
        }
        
        self.pageViewController.dataSource = self
        if respuestasJson.respuestas!.count < 100 {
            let initialContenViewController = self.preguntaAtIndex(respuestasJson.respuestas!.count) as FormatoEncuestaViewController
        
            let viewControllers = NSArray(object: initialContenViewController)
            self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }else{
            self.performSegue(withIdentifier: "empezarPreguntasAbiertas", sender: nil)
        }
        
        
        
        self.pageViewController.view.frame = CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: self.view.frame.size.height-10)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
     
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func volverAtras() {
        let alertController = UIAlertController(title: "Confirmación", message: "Al presionar Si guardará los cambios para continuar más tarde, ¿Desea continuar?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Si", style: .default, handler: {(alert: UIAlertAction) in
            self.performSegue(withIdentifier: "unwindToMisEncuestas", sender: self)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present((alertController), animated: true, completion: nil)
        
    }
    func preCargarDatos(){
        
        preguntas =  preguntasJson.value(forKey: "preguntas") as!  NSArray
        respuestas = preguntas.value(forKey: "respuestas") as! NSArray

    }
    
    
    func preguntaAtIndex(_ index: Int) ->FormatoEncuestaViewController
    {
        
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "FormatoEncuestaViewController") as! FormatoEncuestaViewController
        
        pageContentViewController.respuestas =  (respuestas[index] as AnyObject).value(forKey: "respuesta") as! [String]
        pageContentViewController.pregunta = (preguntas[index] as AnyObject).value(forKey: "pregunta") as! String
        pageContentViewController.codPregunta = (preguntas[index] as AnyObject).value(forKey: "id") as! String
        pageContentViewController.pageIndex = index
        
        
        return pageContentViewController
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return preguntas.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    func btnSiguiente(){ //(index: Int, codResp:String, respSel:String){
        
        
        if seleccion {
            //GUARDADO DE ERESPUESTAS
            respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: codResp, codRespuesta: respSel))
            prefs.set(Mapper().toJSONString(respuestasJson, prettyPrint: false)!, forKey: "resp\(rutEvaluador)\(rutEvaluado)")
        
        
            var index = indexPage
            index += 1
            if(!(index == NSNotFound) && !(index == preguntas.count)){
            
                let viewControllers = NSArray(object: preguntaAtIndex(index))
                self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            
            }else
            {
                //IR A PREGUNTAS ABIERTAS
                self.performSegue(withIdentifier: "empezarPreguntasAbiertas", sender: nil)
            
            }
        }else{
            let AlertController = UIAlertController(title: "Mensaje", message: "Debes seleccionar una respuesta para avanzar", preferredStyle: .alert)
            AlertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(AlertController, animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "empezarPreguntasAbiertas" {
            let vc = segue.destination as! MantenedorPregAbiertasViewController
            vc.rutEvaluado = self.rutEvaluado
        }
    }


}
