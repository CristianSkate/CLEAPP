//
//  DetalleNoticiaViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 10-01-16.
//  Copyright © 2016 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class DetalleNoticiaViewController: UIViewController , UITextViewDelegate{

    var noticia:Noticia!
    @IBOutlet weak var imgNoticia: UIImageView!
    @IBOutlet weak var txtTitulo: UITextView!
    @IBOutlet weak var txtNoticia: UITextView!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Noticias CLE"
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Black
        //Boton volver
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Volver", style: .Plain, target: self, action: "volverAtras")
        
        let url = NSURL(string: "http://cle.ejercito.cl/upload/\(noticia.urlImagen)")
        //Carga de cache
        if let image = url?.cachedImage{
            imgNoticia.image = image
            imgNoticia.alpha = 1
        }else {
            imgNoticia.alpha = 0
            url!.fetchImage { image in
                self.imgNoticia.image = image
                UIView.animateWithDuration(0.3) {
                    self.imgNoticia.alpha = 1
                    
                }
            }
        }

        txtTitulo.text = noticia.txtTitulo
        txtNoticia.text = noticia.txtNoticia
        txtTitulo.textAlignment = .Center
        txtNoticia.textAlignment = .Justified
        
        configureScrollView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    
    func volverAtras(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    

}
