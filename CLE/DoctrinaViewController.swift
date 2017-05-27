//
//  DoctrinaViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 23-10-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class DoctrinaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var documentos:[Documento] = []
    var paginas:[UIImage] = []
    var index:Int!
    
    @IBOutlet weak var tblDoctrinas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Doctrina"
        //self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 80.0/255.0, green: 50.0/255.0, blue: 04.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barStyle = .black
        
        var image = UIImage(named: "Menu")
        
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(DoctrinaViewController.btnMenu(_:)))
        self.tblDoctrinas.dataSource = self
        self.tblDoctrinas.delegate = self
        
        cargarDocumentos()

    }

    func cargarDocumentos(){
        for i:Int in 0 ..< 53  {
            if (i < 9){
                paginas.append(UIImage(named: ("herramientas_0\(i+1)"))!)
            }else{
                paginas.append(UIImage(named: ("herramientas_\(i+1)"))!)
            }
        }
        documentos.append(Documento(nombre: "Guía de herramientas para el fortalecimiento del liderazgo", paginas: paginas))
        paginas = []
        for i:Int in 0 ..< 23  {
            if (i < 9){
                paginas.append(UIImage(named: ("plegable_0\(i+1)"))!)
            }else{
                paginas.append(UIImage(named: ("plegable_\(i+1)"))!)
            }
        }
        documentos.append(Documento(nombre: "Competencias", paginas: paginas))
        paginas = []
        for i:Int in 0 ..< 8  {
                paginas.append(UIImage(named: ("cuadriptico_\(i+1)"))!)
        }
        documentos.append(Documento(nombre: "Los atributos del Líder", paginas: paginas))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    @IBAction func btnMenu(_ sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(.left, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mycell:CeldaDoctrinasTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CeldaDoctrina", for: indexPath) as! CeldaDoctrinasTableViewCell
        
        mycell.imgCaratula.image = documentos[(indexPath as NSIndexPath).row].paginas[0]
        mycell.txtTituloDocumento.textAlignment = .center
        mycell.txtTituloDocumento.text = documentos[(indexPath as NSIndexPath).row].nombre
        
        return mycell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarDocumento" {

            let vc:MantenedorDoctrinaViewController = segue.destination as! MantenedorDoctrinaViewController;
            vc.titulo = documentos[(tblDoctrinas.indexPathForSelectedRow! as NSIndexPath).row].nombre
            vc.paginas = documentos[(tblDoctrinas.indexPathForSelectedRow! as NSIndexPath).row].paginas
        }
    }
    
    
}
