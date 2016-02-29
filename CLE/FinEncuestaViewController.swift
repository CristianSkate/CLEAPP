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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Fin de la encuesta"
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnEnviarEncuesta(sender: AnyObject) {
        
        self.performSegueWithIdentifier("unwindToMisEncuestas", sender: self)
        
    }
    

}
