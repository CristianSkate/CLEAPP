//
//  Instructivo.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 18-02-16.
//  Copyright © 2016 Cristian Martinez Toledo. All rights reserved.
//

import Foundation

class Instructivo: NSObject{
    
    var titulo:String
    var cuerpo:String
    
    init(titulo:String,cuerpo:String){
        self.titulo = titulo
        self.cuerpo = cuerpo
    }
}