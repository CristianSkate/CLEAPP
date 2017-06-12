//
//  Paso2RegistrarseViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 12-06-17.
//  Copyright © 2017 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class Paso2RegistrarseViewController: UIViewController {

    
    @IBOutlet var txtTituloPaso2: UITextView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var txtApellidoPaterno: UITextField!
    @IBOutlet var txtApellidoMaterno: UITextField!
    @IBOutlet var txtNombres: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtConfirmEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtConfirmPassword: UITextField!
    @IBOutlet var txtPregSecreta: UITextField!
    @IBOutlet var txtRespuesta: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 22))
        //statusBarView.backgroundColor = UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        statusBarView.backgroundColor = UIColor(red: 128.0/255.0, green: 80.0/255.0, blue: 04.0/255.0, alpha: 1.0)
        self.view.addSubview(statusBarView)
        self.preferredStatusBarStyle

        
        txtTituloPaso2.text = "Revise y confirme sus datos para completar el registro"
        configureScrollView()
        
        scrollView.keyboardDismissMode = .onDrag
        //scrollView.keyboardDismissMode = .interactive
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    func textViewDidChange(_ textView: UITextView) {
        
        if textView == txtTituloPaso2 {
            let contentSize = textView.sizeThatFits(textView.bounds.size)
            var frame = textView.frame
            frame.size.height = contentSize.height
            textView.frame = frame
            
            let aspectRatioViewConstraint = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: textView, attribute: .width, multiplier: textView.bounds.height/textView.bounds.width, constant: 1)
            textView.addConstraint(aspectRatioViewConstraint)
            
        }
    }
    
    func configureScrollView(){
        
        let contentSize = scrollView.sizeThatFits(scrollView.bounds.size)
        var frame = scrollView.frame
        frame.size.height = contentSize.height
        scrollView.contentSize.height = frame.size.height
        
    }
    
    @IBAction func VolverAtras(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bntEnviar(_ sender: AnyObject) {
        //Grabar en webservice
        
        
    }
    
    @IBAction func btnSeleccionPregunta(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Selección de pregunta", message: "Seleccione una pregunta secreta", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Lugar de nacimiento de la madre", style: .default, handler: {(alert: UIAlertAction) in
            
           self.txtPregSecreta.text = "Lugar de nacimiento de la madre"
        }))
        alertController.addAction(UIAlertAction(title: "Primera mascota", style: .default, handler: {(alert: UIAlertAction) in
           self.txtPregSecreta.text = "Primera mascota"
        }))
        alertController.addAction(UIAlertAction(title: "Nombre de Abuela", style: .default, handler: {(alert: UIAlertAction) in
            self.txtPregSecreta.text = "Nombre de Abuela"
        }))
        alertController.addAction(UIAlertAction(title: "Cancion preferida", style: .default, handler: {(alert: UIAlertAction) in
            self.txtPregSecreta.text = "Cancion preferida"
        }))
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present((alertController), animated: true, completion: nil)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self.scrollView.keyboardDismissMode
        //self.view.endEditing(true)
        
    }
    
}
