//
//  InicioViewController.swift
//  Centro de Liderazgo Ejercito de Chile
//
//  Created by Cristian Martinez Toledo on 30-09-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class InicioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblNoticias: UITableView!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    var image:UIImage!
    var noticias:[Noticia] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Inicio"
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Black

        var image = UIImage(named: "Menu")
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "btnMenu:")
        
        noticias.append(Noticia(imagen: UIImage(named: "Logo")!, txtTitulo: "MILE EJECUTA TALLERES EN UNIDADES DE LA FUERZA TERRESTRE", txtResumen: "Los integrantes del proyecto “Modelo Integral de Liderazgo del Ejército” (MILE), efectuaron talleres de desarrollo de liderazgo con las unidades de la Fuerza Terrestre, ubicadas en las ciudades de Temuco, Osorno y Valdivia.", txtNoticia: "asd"))
        // asignar datasource y delegate a la tabla
        tblNoticias.dataSource = self
        tblNoticias.delegate = self
        //tblNoticias.rowHeight = UITableViewAutomaticDimension
        //tblNoticias.estimatedRowHeight =  50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(animated: Bool) {
    
    }
    
    @IBAction func btnMenu(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticias.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let mycell:CeldaNoticiasTableViewCell = tableView.dequeueReusableCellWithIdentifier("CeldaNoticias", forIndexPath: indexPath) as! CeldaNoticiasTableViewCell
        
        mycell.txtTitulo.text = noticias[indexPath.row].txtTitulo
        mycell.imgImagen.image = noticias[indexPath.row].imagen
        mycell.txtResumen.text = noticias[indexPath.row].txtResumen
        
        return mycell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
