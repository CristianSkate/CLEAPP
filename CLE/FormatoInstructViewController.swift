//
//  FormatoInstructViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 15-02-16.
//  Copyright © 2016 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class FormatoInstructViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtTitulo: UITextView!
    @IBOutlet weak var txtCuerpo: UITextView!
    var titulo:String!
    var cuerpo:String!
    var pageIndex:Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Instructivos"
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Black
        
        txtTitulo.text = titulo
        txtCuerpo.text = cuerpo
        txtTitulo.textAlignment = .Center
        txtCuerpo.textAlignment = .Justified
        
        configureScrollView()
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func irSiguiente(sender: AnyObject) {
        // funcion para cargar y mostrar la siguiente parte del instructivo
        
            let master : MantenedorInstructivoViewController = self.parentViewController?.parentViewController as! MantenedorInstructivoViewController
            master.btnSiguiente(self.pageIndex)
        
    }
    
    func configureScrollView(){
        
        let contentSize = scrollView.sizeThatFits(scrollView.bounds.size)
        var frame = scrollView.frame
        frame.size.height = contentSize.height
        scrollView.contentSize.height = frame.size.height
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        let contentSize = textView.sizeThatFits(textView.bounds.size)
        var frame = textView.frame
        frame.size.height = contentSize.height
        textView.frame = frame
        
        let aspectRatioViewConstraint = NSLayoutConstraint(item: textView, attribute: .Height, relatedBy: .Equal, toItem: textView, attribute: .Width, multiplier: textView.bounds.height/textView.bounds.width, constant: 1)
        textView.addConstraint(aspectRatioViewConstraint)
    }

    

}
