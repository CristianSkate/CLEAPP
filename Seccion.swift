//
//  Seccion.swift
//  Tarea2-U3
//
//  Created by Cristian Martinez Toledo on 18-11-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import Foundation

class Seccion: NSObject {
    
    var titulo:String
    var instructivo:String
    var preguntas:[String]
    var respuestas:[String]
    
    init(titulo:String,instructivo:String,preguntas:[String],respuestas:[String]){
        self.titulo = titulo
        self.instructivo = instructivo
        self.preguntas = preguntas
        self.respuestas = respuestas
    }
}