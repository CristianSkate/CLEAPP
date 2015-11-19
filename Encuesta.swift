//
//  File.swift
//  Tarea2-U3
//
//  Created by Cristian Martinez Toledo on 18-11-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import Foundation

class Encuesta: NSObject{
    
    var secciones:[Seccion]
    var version:Int
    
    init(secciones:[Seccion],version:Int){
        self.secciones = secciones
        self.version = version
    }
}