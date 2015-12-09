//
//  Noticia.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 08-12-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import Foundation

class Noticia: NSObject{
    var imagen:UIImage
    var txtTitulo:String
    var txtResumen:String
    var txtNoticia:String
    
    init(imagen:UIImage, txtTitulo:String, txtResumen:String, txtNoticia:String){
        self.imagen = imagen
        self.txtTitulo = txtTitulo
        self.txtResumen = txtResumen
        self.txtNoticia = txtNoticia
    }
}