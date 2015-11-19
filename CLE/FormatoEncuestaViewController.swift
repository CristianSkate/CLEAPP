//
//  EncuestaViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 01-11-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class FormatoEncuestaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var txtTituloSeccion: UILabel!
    @IBOutlet weak var txtPregunta: UITextView!
    @IBOutlet weak var tblRespuestas: UITableView!
    var respuestas:[String]!
    var pregunta:String!
    var tituloSeccion:String!
    var pageIndex:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        txtTituloSeccion.text = tituloSeccion
        txtPregunta.text = pregunta
        tblRespuestas.dataSource =  self
        tblRespuestas.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func irSiguiente(sender: AnyObject) {
        // funcion para cargar y mostrar la siguiente pregunta
        let master : MantenedorEncuestaViewController = self.parentViewController?.parentViewController as! MantenedorEncuestaViewController
        
        master.btnSiguiente(self.pageIndex)
        
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
