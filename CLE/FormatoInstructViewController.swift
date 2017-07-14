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

        self.title = "Encuesta"
        
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
        
        tablaInstructivo.rowHeight = UITableViewAutomaticDimension
        tablaInstructivo.estimatedRowHeight = 180.0
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //@IBAction func irSiguiente(sender: AnyObject) {
        // funcion para cargar y mostrar la siguiente parte del instructivo
        
            //let master : MantenedorInstructivoViewController = self.parentViewController?.parentViewController as! MantenedorInstructivoViewController
            //master.btnSiguiente(self.pageIndex)
        
    //}
    

    
//    func textViewDidChange(_ textView: UITextView) {
//        
//        let contentSize = textView.sizeThatFits(textView.bounds.size)
//        var frame = textView.frame
//        frame.size.height = contentSize.height
//        textView.frame = frame
//        
//        let aspectRatioViewConstraint = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: textView, attribute: .width, multiplier: textView.bounds.height/textView.bounds.width, constant: 1)
//        textView.addConstraint(aspectRatioViewConstraint)
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let normalFont = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular) //UIFont(name: "System", size: 14)
        let boldSearchFont = UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold)
        
        switch indexPath.row {
        
        case 0:
            
            let mycell:CeldaTituloTableViewCell = tableView.dequeueReusableCell(withIdentifier: "celdaTitulo", for: indexPath) as! CeldaTituloTableViewCell
            
            mycell.txtInstrucciones.text = "Instrucciones"
            mycell.txtParrafo.text = "En esta sección, usted encontrará una serie de frases o afirmaciones referentes a diversos aspectos relacionados con las conductas y habilidades que forman parte del MILE (Modelo Integral de Liderazgo del Ejército), las cuales le solicitamos leer cuidadosamente.\n \nPara que su opinión aporte formativamente a la persona evaluada, es necesario responder a conciencia, señalando los aspectos destacados como aquellos que la persona deba perfeccionar, para ser un mejor líder dentro del Ejército.\n \nFrente a cada frase, usted debe seleccionar el nivel que represente su opinión de la forma más completa de acuerdo a 4 niveles. Para marcar un nivel debe estar seguro que la persona cumple completamente la descripción del nivel, si no es así, considere el nivel inferior siguiente:\n \nSus respuestas son guardadas instantáneamente por lo que podrá detenerse y volver a iniciar la encuesta en el mismo número de respuesta donde quedó.\n \nUna vez recibido el reporte y comprendido sus resultados usted podrá acceder a través de la página web del CLE a una serie de herramientas que permitirán fortalecer su desempeño como líder."
            configureTextView(textView: mycell.txtParrafo)
            
            return mycell
            
        case 1:
            
            let mycell:CeldaCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "celdaCard", for: indexPath) as! CeldaCardTableViewCell
            
            
            //            mycell.txtParrafo.attributedText = addBoldText(fullString: "En esta sección, usted encontrará una serie de frases o afirmaciones referentes a diversos aspectos relacionados con las conductas y habilidades que forman parte del MILE (Modelo Integral de Liderazgo del Ejército), las cuales le solicitamos leer cuidadosamente.\n \nPara que su opinión aporte formativamente a la persona evaluada, es necesario responder a conciencia, señalando los aspectos destacados como aquellos que la persona deba perfeccionar, para ser un mejor líder dentro del Ejército.\n \nFrente a cada frase, usted debe seleccionar el nivel que represente su opinión de la forma más completa de acuerdo a 4 niveles. Para marcar un nivel debe estar seguro que la persona cumple completamente la descripción del nivel, si no es así, considere el nivel inferior siguiente:\n \nSus respuestas son guardadas instantáneamente por lo que podrá detenerse y volver a iniciar la encuesta en el mismo número de respuesta donde quedó.\n \nUna vez recibido el reporte y comprendido sus resultados usted podrá acceder a través de la página web del CLE a una serie de herramientas que permitirán fortalecer su desempeño como líder.", boldPartsOfString: ["aspectos", "persona", "Para", "instantáneamente"], font: normalFont, boldFont: boldSearchFont)

            
            
            mycell.parrafoAzul.attributedText = addBoldText(fullString: "INSUFICIENTE: La conducta o habilidad no está presente o está poco desarrollada por lo que se manifiesta nunca o casi nunca", boldPartsOfString: ["INSUFICIENTE:", "nunca o casi nunca"], font: normalFont, boldFont: boldSearchFont)
            mycell.parrafoBlanco.text = "Debe marcar este nivel cuando la persona no presenta la conducta o habilidad o está poco desarrollada y/o presenta conductas o habilidades opuestas a lo descrito"
            
            mycell.parrafoAzul.textAlignment = .justified
            mycell.parrafoAzul.textColor = UIColor.white
            mycell.parrafoBlanco.textAlignment = .justified
            
            configureTextView(textView: mycell.parrafoAzul)
            configureTextView(textView: mycell.parrafoBlanco)
            configureCardView(cardView: mycell.cardView)
            configureCardView(cardView: mycell.contentView)
            
            return mycell
            
        case 2:
            
            let mycell:CeldaCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "celdaCard", for: indexPath) as! CeldaCardTableViewCell
            
            //mycell.parrafoAzul.text = "*BASICO:* La conducta o habilidad está parcialmente desarrollada, por lo que se manifiesta *a veces*"
            mycell.parrafoAzul.attributedText = addBoldText(fullString: "BASICO: La conducta o habilidad está parcialmente desarrollada, por lo que se manifiesta a veces", boldPartsOfString: ["BASICO:", "a veces"], font: normalFont, boldFont: boldSearchFont)
            mycell.parrafoBlanco.text = "Debe marcar este nivel cuando la persona presenta la conducta o habilidad, sin embargo esto ocurre a veces o se da solo en algunos contextos, situaciones o grupos"
            
            mycell.parrafoAzul.textAlignment = .justified
            mycell.parrafoAzul.textColor = UIColor.white
            mycell.parrafoBlanco.textAlignment = .justified
            configureTextView(textView: mycell.parrafoAzul)
            configureTextView(textView: mycell.parrafoBlanco)
            configureCardView(cardView: mycell.cardView)
            configureCardView(cardView: mycell.contentView)

            
            return mycell
            
        case 3:
            
            let mycell:CeldaCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "celdaCard", for: indexPath) as! CeldaCardTableViewCell
            
            //mycell.parrafoAzul.text = "*ADECUADO:* La conducta o habilidad está satisfactoriamente desarrollada por lo que se manifiesta *siempre o casi siempre*"
            mycell.parrafoAzul.attributedText = addBoldText(fullString: "ADECUADO: La conducta o habilidad está satisfactoriamente desarrollada por lo que se manifiesta siempre o casi siempre", boldPartsOfString: ["ADECUADO:","siempre o casi siempre"], font: normalFont, boldFont: boldSearchFont)
            mycell.parrafoBlanco.text = "Debe marcar este nivel cuando la persona es alguien que siempre o casi siempre se comporta según las conductas o habilidades que se describen, es decir éstas se observan establemente. La conducta o habilidad es fácil de identificar en la persona, en diferentes situaciones, con distintos grupos y contextos. Varias personas estarían de acuerdo con este nivel de desarrollo en la conducta o habilidad consultada"
            
            mycell.parrafoAzul.textAlignment = .justified
            mycell.parrafoAzul.textColor = UIColor.white
            mycell.parrafoBlanco.textAlignment = .justified
            configureTextView(textView: mycell.parrafoAzul)
            configureTextView(textView: mycell.parrafoBlanco)
            configureCardView(cardView: mycell.cardView)
            configureCardView(cardView: mycell.contentView)
            
            return mycell
            
        case 4:
            
            let mycell:CeldaCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "celdaCard", for: indexPath) as! CeldaCardTableViewCell

            //mycell.parrafoAzul.text = "*INFLUYENTE:* Además de manifestar la conducta o habilidad *siempre o casi siempre*, la presenta como *un modelo a seguir*"
            mycell.parrafoAzul.attributedText = addBoldText(fullString: "INFLUYENTE: Además de manifestar la conducta o habilidad siempre o casi siempre, la presenta como un modelo a seguir", boldPartsOfString: ["INFLUYENTE:","siempre o casi siempre","un modelo a seguir"], font: normalFont, boldFont: boldSearchFont)
            mycell.parrafoBlanco.text = "Debe marcar este nivel cuando la persona es alguien que además del nivel anterior, es efectivamente un modelo a seguir para los demás respecto a las conductas o habilidades descritas. Tanto usted como otros lo reconocen como un modelo en la conducta o habilidad descrita"
            
            mycell.parrafoAzul.textAlignment = .justified
            mycell.parrafoAzul.textColor = UIColor.white
            mycell.parrafoBlanco.textAlignment = .justified
            configureTextView(textView: mycell.parrafoAzul)
            configureTextView(textView: mycell.parrafoBlanco)
            configureCardView(cardView: mycell.cardView)
            configureCardView(cardView: mycell.contentView)
            
            return mycell
            
        case 5:
            
            let mycell:CeldaFinalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "celdaFinal", for: indexPath) as! CeldaFinalTableViewCell
            
            //mycell.parrafoFinal.text = "Le recordamos que el resultado:\n \nEs *CONFIDENCIAL*, solo usted podrá acceder a su reporte personal.\nTiene una finalidad *FORMATIVA*, no es una evaluación o calificación de su liderazgo, sino una información que orienta su autodesarrollo."
            mycell.parrafoFinal.attributedText = addBoldText(fullString: "Le recordamos que el resultado:\n \nEs CONFIDENCIAL, solo usted podrá acceder a su reporte personal.\nTiene una finalidad FORMATIVA, no es una evaluación o calificación de su liderazgo, sino una información que orienta su autodesarrollo.", boldPartsOfString: ["CONFIDENCIAL","FORMATIVA"], font: normalFont, boldFont: boldSearchFont)
            mycell.parrafoFinal.textAlignment = .justified
            configureTextView(textView: mycell.parrafoFinal)

            
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
        
        let contentSize = cardView.sizeThatFits(cardView.bounds.size)
        var frame = cardView.frame
        frame.size.height = contentSize.height
        cardView.frame = frame
        cardView.layer.cornerRadius = 3.0
        cardView.layer.masksToBounds = false
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowOpacity = 0.8
        cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
    }
    
    func configureTextView(textView:UITextView){
        
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame;
        
        
    }
    
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    private func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func addBoldText(fullString: NSString, boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        let nonBoldFontAttribute = [NSFontAttributeName:font!]
        let boldFontAttribute = [NSFontAttributeName:boldFont!]
        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }
    
    

}
