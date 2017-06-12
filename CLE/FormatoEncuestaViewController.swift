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
        //self.navigationController?.navigationBar.barTintColor = UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 128.0/255.0, green: 80.0/255.0, blue: 04.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barStyle = .black

        txtPregunta.text = pregunta
        tblRespuestas.dataSource =  self
        tblRespuestas.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  respuestas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mycell = tableView.dequeueReusableCell(withIdentifier: "CeldaRespuestas", for: indexPath) as! RespuestasTableViewCell
        
        mycell.txtTexto.text = respuestas[(indexPath as NSIndexPath).row]
        
        return mycell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        seleccion = true
        respSel = String((indexPath as NSIndexPath).row + 1)
        let master : MantenedorEncuestaViewController = self.parent?.parent as! MantenedorEncuestaViewController
        master.codResp = codPregunta
        master.respSel = respSel
        master.seleccion = seleccion
        master.indexPage = pageIndex
    }

}
