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
    
    @IBOutlet weak var tblDoctrinas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Doctrina"
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Black
        
        var image = UIImage(named: "Menu")
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "btnMenu:")
        self.tblDoctrinas.dataSource = self
        self.tblDoctrinas.delegate = self
        
        cargarDocumentos()
        documentos.append(Documento(nombre: "Guía de herramientas para el fortalecimiento del liderazgo", paginas: paginas))
        
        // Do any additional setup after loading the view.
    }

    func cargarDocumentos(){
        for var i:Int = 0; i<45 ; i++ {
            if (i < 9){
                paginas.append(UIImage(named: ("Diapositiva0\(i+1)"))!)
            }else{
                paginas.append(UIImage(named: ("Diapositiva\(i+1)"))!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnMenu(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true, completion: nil)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let mycell:CeldaDoctrinasTableViewCell = tableView.dequeueReusableCellWithIdentifier("CeldaDoctrina", forIndexPath: indexPath) as! CeldaDoctrinasTableViewCell
        
        mycell.imgCaratula.image = documentos[indexPath.row].paginas[0]
        mycell.txtTituloDocumento.textAlignment = .Center
        mycell.txtTituloDocumento.text = documentos[indexPath.row].nombre
        
        return mycell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
}
