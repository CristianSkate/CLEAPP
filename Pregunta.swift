//
//  Pregunta.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 19-11-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import Foundation

class Pregunta: NSObject {
    
    var encabezado:String
    var respuestas:[String]
    
    init(encabezado:String,respuestas:[String]){
        self.encabezado = encabezado
        self.respuestas =  respuestas
    }
}