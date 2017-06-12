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
    var respuestas:NSArray!
    var preguntas:NSArray!
    var instructivos:[Instructivo] = []
    //Variables para el json
    var reponseError: NSError?
    var response: URLResponse?
    let prefs:UserDefaults = UserDefaults.standard
    var preguntasJson:NSDictionary! = nil
    //Codigo de relacion para buscar la encuesta con los instructivos
    var codRelacionSel:String = ""
    var rutEvaluado:String!
    var indexPage:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Salir", style: .plain, target: self, action: #selector(MantenedorInstructivoViewController.volverAtras))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Siguiente", style: .plain, target: self, action: #selector(MantenedorInstructivoViewController.btnSiguiente))
        
        self.title = "Instructivos"
        preCargarDatos()
        
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        let initialContenViewController = self.instructivoAtIndex(0) as FormatoInstructViewController
        
        let viewControllers = NSArray(object: initialContenViewController)
        
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: self.view.frame.size.height-10)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func volverAtras() {
        let alertController = UIAlertController(title: "Confirmación", message: "Al presionar si volverá al listado de encuestas pendientes, ¿Desea continuar?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Si", style: .default, handler: {(alert: UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present((alertController), animated: true, completion: nil)
        
    }
    
    func preCargarDatos(){
        
        if (prefs.object(forKey: "PREGUNTAS\(codRelacionSel)") == nil) {
            cargarDatos()
        }else{
            let urlData = prefs.object(forKey: "PREGUNTAS\(codRelacionSel)") as? Data
            preguntasJson = (try! JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
            preguntas =  preguntasJson.value(forKey: "preguntas") as!  NSArray
            respuestas = preguntas.value(forKey: "respuestas") as! NSArray
            instructivos.append(Instructivo(titulo: preguntasJson.value(forKey: "titulo_introduccion") as! String, cuerpo: preguntasJson.value(forKey: "introduccion") as! String))
            instructivos.append(Instructivo(titulo: preguntasJson.value(forKey: "titulo_competencias") as! String, cuerpo: preguntasJson.value(forKey: "competencias") as! String))
            //instructivos.append(Instructivo(titulo: preguntasJson.value(forKey: "titulo_atributos") as! String, cuerpo: preguntasJson.value(forKey: "atributos") as! String))
            instructivos.append(Instructivo(titulo: "", cuerpo: "Presione el boton Siguiente para empezar la encuesta"))
        }
    }
    
    func cargarDatos(){
        
        let post:NSString = "relacion=\(codRelacionSel)" as NSString
        
        // mandamos al log para ir registrando lo que va pasando
        NSLog("PostData: %@",post);
        
        // llamamos a la URl donde está el json que se conectará con la BD
        let url:URL = URL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/ObtenerEncuestaRelacion?AspxAutoDetectCookieSupport=1")!
        
        // codificamos lo que se envía
        let postData:Data = post.data(using: String.Encoding.ascii.rawValue)!
        
        // se determina el largo del string
        let postLength:NSString = String( postData.count ) as NSString
        
        // componemos la URL con una var request y un NSMutableURLRequest y le pasamos como parámetros las vars
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        // hacemos la conexion
        var urlData: Data?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
        } catch let error as NSError {
            reponseError = error
            urlData = nil
        }
        
        // se valida
        if ( urlData != nil ) {
            let res = response as! HTTPURLResponse!;
            
            //NSLog("Response code: %ld", res?.statusCode);
            
            if ((res?.statusCode)! >= 200 && (res?.statusCode)! < 300)
            {
                let responseData:NSString  = NSString(data:urlData!, encoding:String.Encoding.utf8.rawValue)!
                
                NSLog("Response ==> %@", responseData);
                
                //var error: NSError?
               
                
                preguntasJson = (try! JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
                
                prefs.set(urlData, forKey: "PREGUNTAS\(codRelacionSel)")
                prefs.synchronize()
                preguntas =  preguntasJson.value(forKey: "preguntas") as!  NSArray //Agregar identificador
                respuestas = preguntas.value(forKey: "respuestas") as! NSArray // agregar identificador unico
                instructivos.append(Instructivo(titulo: preguntasJson.value(forKey: "titulo_introduccion") as! String, cuerpo: preguntasJson.value(forKey: "introduccion") as! String))
                instructivos.append(Instructivo(titulo: preguntasJson.value(forKey: "titulo_competencias") as! String, cuerpo: preguntasJson.value(forKey: "competencias") as! String))
                //instructivos.append(Instructivo(titulo: preguntasJson.value(forKey: "titulo_atributos") as! String, cuerpo: preguntasJson.value(forKey: "atributos") as! String))
                instructivos.append(Instructivo(titulo: "", cuerpo: "Presione el boton Siguiente para empezar la encuesta"))
                
                
                
                NSLog("Trae Datos");
                print(preguntas)
                
                
                self.dismiss(animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "¡Ups!", message: "Hubo un problema conectando al servidor", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
        } else {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Acceso incorrecto"
            alertView.message = "Conneción Fallida"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
        }
        
    }
    
    func instructivoAtIndex(_ index: Int) ->FormatoInstructViewController
    {
        
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "FormatoInstructViewController") as! FormatoInstructViewController
        
        pageContentViewController.titulo =  instructivos[index].titulo
        pageContentViewController.cuerpo = instructivos[index].cuerpo
        pageContentViewController.pageIndex = index
        indexPage = index
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
        return instructivos.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    func btnSiguiente(){
        
        var index = indexPage
        index += 1
        if(!(index == NSNotFound) && !(index == instructivos.count)){
            
            let viewControllers = NSArray(object: instructivoAtIndex(index))
            self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            
        }else
        {
            self.performSegue(withIdentifier: "empezarEncuesta", sender: nil)

        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "empezarEncuesta" {
            let vc = segue.destination as! MantenedorEncuestaViewController
            vc.preguntasJson = preguntasJson
            vc.rutEvaluado = self.rutEvaluado

        }
    }

}
