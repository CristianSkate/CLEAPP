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
    let prefs:UserDefaults = UserDefaults.standard
    var preguntasJson:NSDictionary! = nil
    var respuestasJson:Respuestas = Respuestas(rutEvaluador: "", rutEvaluado: "", respuestas: [])
    var rutEvaluado:String!
    var rutEvaluador:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Salir", style: .plain, target: self, action: #selector(MantenedorPregAbiertasViewController.volverAtras))
        self.title = "Encuesta"

        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        
        rutEvaluador = prefs.value(forKey: "RUN") as! String
        print(rutEvaluado)
        
        //INICIALIZACION DE RESPUESTAS
        if  prefs.value(forKey: "resp\(rutEvaluador)\(rutEvaluado)") == nil{
            respuestasJson = Respuestas(rutEvaluador: rutEvaluador, rutEvaluado: rutEvaluado, respuestas: [])
            prefs.set(Mapper().toJSONString(respuestasJson, prettyPrint: false)!, forKey: "resp\(rutEvaluador)\(rutEvaluado)")
        }else{
            respuestasJson = Mapper<Respuestas>().map(prefs.value(forKey: "resp\(rutEvaluador)\(rutEvaluado)") as! String)!
        }
        
        self.pageViewController.dataSource = self
        if respuestasJson.respuestas!.count < 107 {
        
            let initialContenViewController = self.preguntaAtIndex(0) as FormatoPregAbiertaViewController
            let viewControllers = NSArray(object: initialContenViewController)
            self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)

        }else{
            self.performSegue(withIdentifier: "irAFinDeEncuesta", sender: nil)
        }
        self.pageViewController.view.frame = CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: self.view.frame.size.height-10)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func volverAtras() {
        let alertController = UIAlertController(title: "Confirmación", message: "Al presionar Si guardará los cambios para continuar más tarde, ¿Desea continuar?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Si", style: .default, handler: {(alert: UIAlertAction) in
            self.performSegue(withIdentifier: "unwindToMisEncuestas", sender: self)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present((alertController), animated: true, completion: nil)
        
    }
    
    func preguntaAtIndex(_ index: Int) ->FormatoPregAbiertaViewController
    {
        
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "FormatoPregAbiertaViewController") as! FormatoPregAbiertaViewController
        
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
        return 1
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    func btnSiguiente(_ index: Int, resp1a:String, resp1b:String, resp1c:String, resp2a:String, resp2b:String, resp2c:String, resp3:String){
        
        //GUARDADO DE ERESPUESTAS
        respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: "fortaleza1", codRespuesta: resp1a))
        respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: "fortaleza2", codRespuesta: resp1b))
        respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: "fortaleza3", codRespuesta: resp1c))
        respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: "mejora1", codRespuesta: resp2a))
        respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: "mejora2", codRespuesta: resp2b))
        respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: "mejora3", codRespuesta: resp2c))
        respuestasJson.respuestas?.append(Respuestas.respuestasFin(codPregunta: "comentario", codRespuesta: resp3))

        prefs.set(Mapper().toJSONString(respuestasJson, prettyPrint: false)!, forKey: "resp\(rutEvaluador)\(rutEvaluado)")
        print(Mapper().toJSONString(respuestasJson, prettyPrint: false)!)
        
        
        var index = index
        index += 1
        if(!(index == NSNotFound) && !(index == 1)){
            
            let viewControllers = NSArray(object: preguntaAtIndex(index))
            self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            
        }else
        {
            //IR AL FINAL DE LA ENCUESTA
            self.performSegue(withIdentifier: "irAFinDeEncuesta", sender: nil)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irAFinDeEncuesta"{
            let vc = segue.destination as! FinEncuestaViewController
            vc.rutEvaluado = rutEvaluado
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   

}
