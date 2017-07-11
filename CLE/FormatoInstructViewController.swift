//
//  FormatoInstructViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 15-02-16.
//  Copyright © 2016 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class FormatoInstructViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var tablaInstructivo: UITableView!
    
    
    var pageIndex:Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Instructivo"
        
        //self.navigationController?.navigationBar.barTintColor = UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 128.0/255.0, green: 80.0/255.0, blue: 04.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barStyle = .black
       
        
//        txtTitulo.text = titulo
//        txtCuerpo.text = cuerpo
//        txtTitulo.textAlignment = .center
//        txtCuerpo.textAlignment = .justified
        
        //configureScrollView()
        
        tablaInstructivo.dataSource = self
        tablaInstructivo.delegate = self
        
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //@IBAction func irSiguiente(sender: AnyObject) {
        // funcion para cargar y mostrar la siguiente parte del instructivo
        
            //let master : MantenedorInstructivoViewController = self.parentViewController?.parentViewController as! MantenedorInstructivoViewController
            //master.btnSiguiente(self.pageIndex)
        
    //}
    

    
    func textViewDidChange(_ textView: UITextView) {
        
        let contentSize = textView.sizeThatFits(textView.bounds.size)
        var frame = textView.frame
        frame.size.height = contentSize.height
        textView.frame = frame
        
        let aspectRatioViewConstraint = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: textView, attribute: .width, multiplier: textView.bounds.height/textView.bounds.width, constant: 1)
        textView.addConstraint(aspectRatioViewConstraint)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        
        case 0:
            
            let mycell:CeldaTituloTableViewCell = tableView.dequeueReusableCell(withIdentifier: "celdaTitulo", for: indexPath) as! CeldaTituloTableViewCell
            
            mycell.txtInstrucciones.text = "Instrucciones"
            mycell.txtParrafo.text = "Hola es el texto mas largo que haya visto por la vida\nAquiComienza una nueva linea"
        
            return mycell
            
        case 1:
            
            let mycell:CeldaCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "celdaCard", for: indexPath) as! CeldaCardTableViewCell
            
            mycell.parrafoAzul.text = "Hola esta es una prueba chevere"
            mycell.parrafoBlanco.text = "Hola es el texto mas largo que haya visto por la vida"
            
            mycell.parrafoAzul.textAlignment = .justified
            mycell.parrafoBlanco.textAlignment = .justified
            configureCardView(cardView: mycell.cardView)
            
            return mycell
            
        case 2:
            
            let mycell:CeldaFinalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "celdaFinal", for: indexPath) as! CeldaFinalTableViewCell
            
            mycell.parrafoFinal.text = "Hola esta es una prueba chevere y estamos finalizando"
            mycell.parrafoFinal.textAlignment = .justified
            
            return mycell
            
        default:
            
            let mycell:CeldaTituloTableViewCell = tableView.dequeueReusableCell(withIdentifier: "celdaTitulo", for: indexPath) as! CeldaTituloTableViewCell
            
            mycell.txtInstrucciones.text = ""
            mycell.txtParrafo.text = ""
            
            return mycell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func configureCardView(cardView:UIView){
        
//        let contentSize = cardView.sizeThatFits(cardView.bounds.size)
//        var frame = cardView.frame
//        frame.size.height = contentSize.height
//        cardView.frame = frame
        cardView.layer.cornerRadius = 3.0
        cardView.layer.masksToBounds = false
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowOpacity = 0.8
        cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
    }

}
