//
//  EncuestaViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 01-11-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class EncuestaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var txtPregunta: UITextView!
    @IBOutlet weak var tblRespuestas: UITableView!
    let respuestas:[String] =  ["Bueno","Medio","Malo"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Encuesta"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Salir", style: .Plain, target: self, action: "volverAtras")
        tblRespuestas.dataSource =  self
        tblRespuestas.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func volverAtras() {
        let alertController = UIAlertController(title: "Confirmación", message: "Al presionar Si guardará los cambios para continuar más tarde, ¿Desea continuar?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Si", style: .Default, handler: {(alert: UIAlertAction) in
            self.navigationController?.popViewControllerAnimated(true)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        self.presentViewController((alertController), animated: true, completion: nil)
        
    }
    
    @IBAction func irSiguiente(sender: AnyObject) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  respuestas.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mycell = tableView.dequeueReusableCellWithIdentifier("CeldaRespuestas", forIndexPath: indexPath) as! RespuestasTableViewCell
        
        mycell.txtTexto.text = respuestas[indexPath.row]
        
        return mycell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
