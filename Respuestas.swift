//
//  Pregunta.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 19-11-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import Foundation
import ObjectMapper

class Respuestas: NSObject, Mappable {
    
    var rutEvaluador:String?
    var rutEvaluado:String?
    var respuestas:[respuestasFin]?
    
    init(rutEvaluador:String, rutEvaluado:String,respuestas:[respuestasFin]){
        self.rutEvaluador = rutEvaluador
        self.rutEvaluado = rutEvaluado
        self.respuestas = respuestas
    }
    
    required init?(_ map: Map){
    }
    
    func mapping(map: Map){
        rutEvaluado <- map["rut_evaluado"]
        rutEvaluador <- map["rut_evaluador"]
        respuestas <- map["respuestas"]
    }
    
    struct respuestasFin: Mappable{
        
        var codPregunta:String?
        var codRespuesta:String?
        
        init(codPregunta:String, codRespuesta:String){
            self.codPregunta = codPregunta
            self.codRespuesta = codRespuesta
        }
        
        init?(_ map: Map){
        }
        
        mutating func mapping(map: Map) {
            codPregunta <- map["cod_pregunta"]
            codRespuesta <- map["cod_respuesta"]
            
        }
        
    }
    
}
