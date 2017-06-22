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
    var cantidad:String
    
    init(rut:String, nombre:String, relacion:String, cantidad:String){
        self.rut = rut
        self.nombre = nombre
        self.relacion = relacion
        self.cantidad = cantidad
    }
    
    required init(coder aDecoder: NSCoder) {
        rut = aDecoder.decodeObject(forKey: "rut") as! String
        nombre = aDecoder.decodeObject(forKey: "nombre") as! String
        relacion = aDecoder.decodeObject(forKey: "relacion") as! String
        cantidad = aDecoder.decodeObject(forKey: "cantidad") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(rut, forKey: "rut")
        aCoder.encode(nombre, forKey: "nombre")
        aCoder.encode(relacion, forKey:  "relacion")
        aCoder.encode(cantidad, forKey:  "cantidad")
    }
}
