//
//  FormatoPregAbiertaViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 02-03-16.
//  Copyright © 2016 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class FormatoPregAbiertaViewController: UIViewController {

    @IBOutlet weak var txtPreg1: UITextView!
    @IBOutlet weak var txtPreg2: UITextView!
    @IBOutlet weak var txtPreg3: UITextView!
    @IBOutlet weak var txtResp1a: UITextView!
    @IBOutlet weak var txtResp1b: UITextView!
    @IBOutlet weak var txtResp1c: UITextView!
    @IBOutlet weak var txtResp2a: UITextView!
    @IBOutlet weak var txtResp2b: UITextView!
    @IBOutlet weak var txtResp2c: UITextView!
    @IBOutlet weak var txtResp3: UITextView!
    var pageIndex:Int!
    var seleccion:Bool = false
    var codPregunta:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Black
        
        txtPreg1.text = ""
        txtPreg2.text = ""
        txtPreg3.text = ""
        txtResp1a.text = ""
        txtResp1b.text = ""
        txtResp1c.text = ""
        txtResp2a.text = ""
        txtResp2b.text = ""
        txtResp2c.text = ""
        txtResp3.text = ""
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func irSiguiente(sender: AnyObject) {
        // funcion para cargar y mostrar la siguiente pregunta
        if seleccion{
            //Se guarda la respuesta de la pregunta
            
            
            //Se referencia el vc padre para utilizar la funcion del boton siguiente
            let master : MantenedorPregAbiertasViewController = self.parentViewController?.parentViewController as! MantenedorPregAbiertasViewController
            master.btnSiguiente(self.pageIndex, resp1a: txtResp1a.text, resp1b: txtResp1b.text, resp1c: txtResp1c.text, resp2a: txtResp2a.text, resp2b: txtResp2b.text, resp2c: txtResp2c.text, resp3: txtResp3.text)
        }else{
            let AlertController = UIAlertController(title: "Mensaje", message: "Debes seleccionar una respuesta para avanzar", preferredStyle: .Alert)
            AlertController.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
            self.presentViewController(AlertController, animated: true, completion: nil)
        }
    }

}
