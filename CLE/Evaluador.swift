//
//  Encuestadores.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 02-01-16.
//  Copyright © 2016 Cristian Martinez Toledo. All rights reserved.
//

import Foundation

class Evaluador: NSObject, NSCoding {
    
    var rut:String
    var nombre:String
    var relacion:String
    
    init(rut:String, nombre:String, relacion:String){
        self.rut = rut
        self.nombre = nombre
        self.relacion = relacion
    }
    
    required init(coder aDecoder: NSCoder) {
        rut = aDecoder.decodeObjectForKey("rut") as! String
        nombre = aDecoder.decodeObjectForKey("nombre") as! String
        relacion = aDecoder.decodeObjectForKey("relacion") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(rut, forKey: "rut")
        aCoder.encodeObject(nombre, forKey: "nombre")
        aCoder.encodeObject(relacion, forKey:  "relacion")
    }
}