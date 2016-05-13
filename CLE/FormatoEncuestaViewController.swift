//
//  EncuestaViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 01-11-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class FormatoEncuestaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var txtPregunta: UITextView!
    @IBOutlet weak var tblRespuestas: UITableView!
    var respuestas:[String]!
    var pregunta:String!
    var tituloSeccion:String!
    var pageIndex:Int!
    var seleccion:Bool = false
    var codPregunta:String!
    var respSel:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Black

        txtPregunta.text = pregunta
        tblRespuestas.dataSource =  self
        tblRespuestas.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        seleccion = true
        respSel = String(indexPath.row + 1)
        let master : MantenedorEncuestaViewController = self.parentViewController?.parentViewController as! MantenedorEncuestaViewController
        master.codResp = codPregunta
        master.respSel = respSel
        master.seleccion = seleccion
        master.indexPage = pageIndex
    }

}
