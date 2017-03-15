//
//  InicioViewController.swift
//  Centro de Liderazgo Ejercito de Chile
//
//  Created by Cristian Martinez Toledo on 30-09-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit
import ObjectMapper

class InicioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblNoticias: UITableView!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    var image:UIImage!
    var noticias:[Noticia] = []
    var noticiaSeleccionada:Noticia!
    let prefs:UserDefaults = UserDefaults.standard
    var reponseError: NSError?
    var response: URLResponse?
    var respNoticias:NSArray! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Noticias"
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Actualizar", style: .plain, target: self, action: #selector(InicioViewController.cargarNoticias))

        var image = UIImage(named: "Menu")
        
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(InicioViewController.btnMenu(_:)))
        tblNoticias.dataSource = self
        tblNoticias.delegate = self
        //cargarNoticias()
        preCargarNoticias()
        
        //PRUEBA DE PARSING DE JSON
//        let respuestas:Respuestas = Respuestas(rutEvaluador: "11111111-1", rutEvaluado: "11111111-1", respuestas: [Respuestas.respuestasFin(codPregunta: "ABC_123", codRespuesta: "1"), Respuestas.respuestasFin(codPregunta: "ASD_321", codRespuesta: "2")])
//        let jsonString:String = Mapper().toJSONString(respuestas, prettyPrint: false)!
//            
//        print(jsonString)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewDidAppear(_ animated: Bool) {
    
    }
    
    @IBAction func btnMenu(_ sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(.left, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mycell:CeldaNoticiasTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CeldaNoticias", for: indexPath) as! CeldaNoticiasTableViewCell
        
        mycell.txtTitulo.text = noticias[(indexPath as NSIndexPath).row].txtTitulo
        mycell.txtResumen.text = noticias[(indexPath as NSIndexPath).row].txtNoticia
        mycell.txtResumen.textAlignment = .justified
        let url = URL(string: "http://cle.ejercito.cl/upload/_\(noticias[(indexPath as NSIndexPath).row].urlImagen)")
        
        if let image = url?.cachedImage{
            mycell.imgImagen.image = image
            mycell.imgImagen.alpha = 1
        }else {
            mycell.imgImagen.alpha = 0
            url!.fetchImage { image in
            mycell.imgImagen.image = image
            UIView.animate(withDuration: 0.3, animations: {
            mycell.imgImagen.alpha = 1
                }) 
            }
        }
        
        return mycell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noticiaSeleccionada = noticias[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: "detalleNoticia", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detalleNoticia"){
            let vc = segue.destination as! DetalleNoticiaViewController
            vc.noticia = noticiaSeleccionada
        }
    }
    
    func preCargarNoticias(){
            
        respNoticias = prefs.array(forKey: "NOTICIAS") as NSArray!
        
        if (respNoticias == nil) {
            cargarNoticias()
        }else{
            noticias.removeAll()
            for noticia in respNoticias{
                noticias.append(Noticia(urlImagen: ((noticia as AnyObject).value(forKey: "Imagen") as? String)!, txtTitulo: ((noticia as AnyObject).value(forKey: "Titulo") as? String)!, txtResumen: ((noticia as AnyObject).value(forKey: "Resumen") as? String)!, txtNoticia: ((noticia as AnyObject).value(forKey: "Completa") as? String)!))
            }
        }
    }
    
    func cargarNoticias(){
        
        let post:NSString = ""
        
        // mandamos al log para ir registrando lo que va pasando
        NSLog("PostData: %@",post);
        
        // llamamos a la URl donde está el json que se conectará con la BD
        let url:URL = URL(string: "http://cle.ejercito.cl/ServiciosCle.asmx/noticiasJson?AspxAutoDetectCookieSupport=1")!
        
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
                
                respNoticias = (try! JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSArray
                noticias.removeAll()
                prefs.setValue(respNoticias, forKeyPath: "NOTICIAS")
                for noticia in respNoticias{
                    noticias.append(Noticia(urlImagen: ((noticia as AnyObject).value(forKey: "Imagen") as? String)!, txtTitulo: ((noticia as AnyObject).value(forKey: "Titulo") as? String)!, txtResumen: ((noticia as AnyObject).value(forKey: "Resumen") as? String)!, txtNoticia: ((noticia as AnyObject).value(forKey: "Completa") as? String)!))
                }
                
                self.tblNoticias.reloadData()
                
                NSLog("Trae Datos");
                
                print(respNoticias)
                
                
                self.dismiss(animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "¡Ups!", message: "Hubo un problema conectando al servidor", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
        } else {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Mensaje"
            alertView.message = "No se pudo conectar con el servidor, asegurese de que tiene conexión a internet"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
        }
        
    }

}
