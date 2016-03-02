//
//  FinEncuestaViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 19-02-16.
//  Copyright © 2016 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class FinEncuestaViewController: UIViewController {

    @IBOutlet weak var txtFinEncuesta: UITextView!
    var rutEvaluado:String!
    var rutEvaluador:String!
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Fin de la encuesta"
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Black
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Salir", style: .Plain, target: self, action: "volverAtras")
        
        rutEvaluador = prefs.valueForKey("RUN") as! String
        
        
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
    
    @IBAction func btnEnviarEncuesta(sender: AnyObject) {
        
        let jsonFinal:String = prefs.valueForKey("resp\(rutEvaluador)\(rutEvaluador)") as! String
        if enviarResultados(jsonFinal){
            self.performSegueWithIdentifier("unwindToMisEncuestas", sender: self)
        }
        
        
    }
    
    func enviarResultados(jsonFinal:String) -> Bool {
        print(jsonFinal)
        
        return true
    }
    

}
