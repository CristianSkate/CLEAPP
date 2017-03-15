//
//  FormatoPregAbiertaViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 02-03-16.
//  Copyright © 2016 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class FormatoPregAbiertaViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtPreg1: UITextView!
    @IBOutlet weak var txtPreg2: UITextView!
    @IBOutlet weak var txtPreg3: UITextView!
    @IBOutlet weak var txtResp1a: UITextView!
    @IBOutlet weak var txtResp1b: UITextView!
    @IBOutlet weak var txtResp1c: UITextView!
    @IBOutlet weak var txtResp2a: UITextView!
    @IBOutlet weak var txtResp2b: UITextView!
    @IBOutlet weak var txtResp2c: UITextView!
    @IBOutlet weak var txtResp3: UITextView!
    var pageIndex:Int!
    var seleccion:Bool = false
    var codPregunta:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barStyle = .black
        
        txtPreg1.text = "Indique 3 características que usted identifica como FORTALEZAS en la persona que está evaluando"
        txtPreg2.text = "Indique 3 características que usted identifica como ÁREAS DE MEJORA en la persona que está evaluando"
        txtPreg3.text = " Indique cualquier COMENTARIO ADICIONAL sobre el evaluado y/o que permita aclarar cualquier respuesta"
        txtResp1a.text = ""
        txtResp1b.text = ""
        txtResp1c.text = ""
        txtResp2a.text = ""
        txtResp2b.text = ""
        txtResp2c.text = ""
        txtResp3.text = ""
        
        configureResponses()
        configureScrollView()
        registerForKeyboardNotifications()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func irSiguiente(_ sender: AnyObject) {
        // funcion para cargar y mostrar la siguiente pregunta
        if validar(){
            
            //Se referencia el vc padre para utilizar la funcion del boton siguiente
            let master : MantenedorPregAbiertasViewController = self.parent?.parent as! MantenedorPregAbiertasViewController
            master.btnSiguiente(self.pageIndex, resp1a: txtResp1a.text, resp1b: txtResp1b.text, resp1c: txtResp1c.text, resp2a: txtResp2a.text, resp2b: txtResp2b.text, resp2c: txtResp2c.text, resp3: txtResp3.text)
        }else{
            let AlertController = UIAlertController(title: "Mensaje", message: "Debes completar las respuestas para avanzar", preferredStyle: .alert)
            AlertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(AlertController, animated: true, completion: nil)
        }
    }
    
    func validar() ->Bool{
        var value:Bool = false
        
        if txtResp1a.text != "" && txtResp1b.text != "" && txtResp1c.text != "" && txtResp2a.text != "" && txtResp2b.text != "" && txtResp2c.text != "" && txtResp3.text != "" {
            value = true
        }
        return value
    }

    func configureScrollView(){
        
        let contentSize = scrollView.sizeThatFits(scrollView.bounds.size)
        var frame = scrollView.frame
        frame.size.height = contentSize.height
        scrollView.contentSize.height = frame.size.height
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView == txtPreg1 || textView == txtPreg2 || textView == txtPreg3{
            let contentSize = textView.sizeThatFits(textView.bounds.size)
            var frame = textView.frame
            frame.size.height = contentSize.height
            textView.frame = frame
        
            let aspectRatioViewConstraint = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: textView, attribute: .width, multiplier: textView.bounds.height/textView.bounds.width, constant: 1)
            textView.addConstraint(aspectRatioViewConstraint)
            
        }
    }
    
    func configureResponses(){
        
        txtPreg1.textAlignment = .natural
        txtPreg1.font = UIFont(name: "System" , size: 17)
    
        txtResp1a.layer.borderWidth = 1
        txtResp1a.layer.cornerRadius = 8.0
        txtResp1a.layer.masksToBounds = true
        txtResp1a.layer.borderColor = UIColor.gray.cgColor
        txtResp1a.delegate = self
        
        txtResp1b.layer.borderWidth = 1
        txtResp1b.layer.cornerRadius = 8.0
        txtResp1b.layer.masksToBounds = true
        txtResp1b.layer.borderColor = UIColor.gray.cgColor
        txtResp1b.delegate = self

        txtResp1c.layer.borderWidth = 1
        txtResp1c.layer.cornerRadius = 8.0
        txtResp1c.layer.masksToBounds = true
        txtResp1c.layer.borderColor = UIColor.gray.cgColor
        txtResp1c.delegate = self
        
        txtResp2a.layer.borderWidth = 1
        txtResp2a.layer.cornerRadius = 8.0
        txtResp2a.layer.masksToBounds = true
        txtResp2a.layer.borderColor = UIColor.gray.cgColor
        txtResp2a.delegate = self

        txtResp2b.layer.borderWidth = 1
        txtResp2b.layer.cornerRadius = 8.0
        txtResp2b.layer.masksToBounds = true
        txtResp2b.layer.borderColor = UIColor.gray.cgColor
        txtResp2b.delegate = self

        txtResp2c.layer.borderWidth = 1
        txtResp2c.layer.cornerRadius = 8.0
        txtResp2c.layer.masksToBounds = true
        txtResp2c.layer.borderColor = UIColor.gray.cgColor
        txtResp2c.delegate = self

        txtResp3.layer.borderWidth = 1
        txtResp3.layer.cornerRadius = 8.0
        txtResp3.layer.masksToBounds = true
        txtResp3.layer.borderColor = UIColor.gray.cgColor
        txtResp3.delegate = self

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //Solucion al teclado
    var activeField: UITextView?
    
    func registerForKeyboardNotifications()
    {
        //agregando escuchas de notificaciones del teclado
        NotificationCenter.default.addObserver(self, selector: #selector(FormatoPregAbiertaViewController.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FormatoPregAbiertaViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //eliminar escuchas del teclado
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
     
        self.activeField = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        
        self.activeField = nil
    }
    override func viewDidDisappear(_ animated: Bool) {
       deregisterFromKeyboardNotifications()
    }
    
    func keyboardWasShown(_ notification: Notification)
    {
        //calcular tamaño del teclado
        self.scrollView.isScrollEnabled = true
        let info : NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let _ = self.activeField
        {
            if (!aRect.contains(activeField!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            
            }
        }
    }
    
    
    func keyboardWillBeHidden(_ notification: Notification)
    {
        self.scrollView.contentInset = UIEdgeInsets.zero
    }
    

}
