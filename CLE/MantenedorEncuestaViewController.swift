//
//  MantenedorEncuestaViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 18-11-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class MantenedorEncuestaViewController: UIViewController, UIPageViewControllerDataSource{

    var pageViewController:UIPageViewController!
    var encuesta:Encuesta!
    var secciones:[Seccion]!
    var respuestas:[String]!
    var preguntas:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Salir", style: .Plain, target: self, action: "volverAtras")
        self.title = "Encuesta"
        cargarDatos()
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        let initialContenViewController = self.preguntaAtIndex(0) as FormatoEncuestaViewController
        
        let viewControllers = NSArray(object: initialContenViewController)
        
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height-10)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func volverAtras() {
        let alertController = UIAlertController(title: "Confirmación", message: "Al presionar Si guardará los cambios para continuar más tarde, ¿Desea continuar?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Si", style: .Default, handler: {(alert: UIAlertAction) in
            self.navigationController?.popViewControllerAnimated(true)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        self.presentViewController((alertController), animated: true, completion: nil)
        
    }
    
    func cargarDatos(){
        
        self.preguntas =  ["Actúo en concordancia con las normas institucionales.","Cumplo con mis tareas de acuerdo a lo establecido.","Privilegio el interés del Ejército sobre el propio."]
        self.respuestas =  ["Insuficiente","Básico","Adecueado","Influyente"]
        self.secciones = [Seccion(titulo: "Compromiso", instructivo: "En esta sección, usted encontrará una serie de frases o afirmaciones referentes a diversos aspectos relacionados con las conductas y habilidades que forman parte del MILE, las cuales le solicitamos leer cuidadosamente. Frente a cada frase, usted debe marcar la alternativa que mejor represente su opinión de acuerdo a 4 opciones de respuesta que expresan los siguientes niveles para la evaluación:\nINSUFICIENTE: la conducta o habilidad se manifiesta casi nunca o nunca.\nBÁSICO: la conducta o habilidad se manifiesta ocasionalmente o en forma irregular.\nADECUADO: la conducta o habilidad se manifiesta en forma regular o consistente.\nINFLUYENTE: la conducta o habilidad se manifiesta en forma regular o consistente y además la persona es un ejemplo o modelo para otros.\nPor ejemplo, si usted considera que el evaluado(a) manifiesta la habilidad de manera consistente y además es un modelo a seguir, usted debería marcar en el casillero que indica el nivel 'Influyente'.", preguntas: self.preguntas, respuestas: self.respuestas)]
        
        self.encuesta =  Encuesta(secciones: self.secciones, version: 1)
        
    }
    
    func preguntaAtIndex(index: Int) ->FormatoEncuestaViewController
    {
        
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FormatoEncuestaViewController") as! FormatoEncuestaViewController
        
        pageContentViewController.respuestas =  respuestas
        pageContentViewController.pregunta = preguntas[index]
        pageContentViewController.tituloSeccion = secciones[0].titulo
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
        
        return nil //self.preguntaAtIndex(index)
    }
    
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return preguntas.count
    }
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    func btnSiguiente(index: Int){
        
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
                self.navigationController?.popViewControllerAnimated(true)
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
        //        let alertController =  UIAlertController(title: "Mensaje", message: "Hola", preferredStyle: .Alert)
        //        alertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
        //        self.presentViewController(alertController, animated: true, completion: nil)
    }


}
