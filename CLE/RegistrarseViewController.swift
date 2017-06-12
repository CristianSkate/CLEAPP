//
//  RegistrarseViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 12-06-17.
//  Copyright © 2017 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class RegistrarseViewController: UIViewController {

    
    @IBOutlet var txtRUN: UITextField!
    @IBOutlet var txtClaveUnidad: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 22))
        //statusBarView.backgroundColor = UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        statusBarView.backgroundColor = UIColor(red: 128.0/255.0, green: 80.0/255.0, blue: 04.0/255.0, alpha: 1.0)
        self.view.addSubview(statusBarView)
        self.preferredStatusBarStyle

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    

    @IBAction func volverAtras(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSiguiente(_ sender: AnyObject) {
        //enviar datos al ws y pasar a la siguiente pantalla.
        
        
        
        

        //Luego de enviar, recibir y guardar los datos se pasa al segundo paso
        self.performSegue(withIdentifier: "irASiguienteRegistro", sender: nil)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    

}
