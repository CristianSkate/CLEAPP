//
//  Pregunta.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 19-11-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import Foundation

class Respuestas: NSObject {
    
    var rutEvaluador:String
    var rutEvaluado:String
    var respuestas:[(codRespuesta:String,resp:String)]
    
    init(rutEvaluador:String, rutEvaluado:String, respuestas:[(codRespuesta:String,resp:String)]){
        self.rutEvaluado = rutEvaluado
        self.rutEvaluador = rutEvaluador
        self.respuestas = respuestas
    }
}