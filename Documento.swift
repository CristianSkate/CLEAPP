//
//  Documento.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 09-12-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import Foundation

class Documento: NSObject{
    var nombre:String
    var paginas:[UIImage]
    
    init(nombre:String, paginas:[UIImage]){
        self.nombre = nombre
        self.paginas = paginas
    }
}