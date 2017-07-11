//
//  CeldaTituloTableViewCell.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 10-07-17.
//  Copyright © 2017 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class CeldaTituloTableViewCell: UITableViewCell {

    
    @IBOutlet var txtInstrucciones: UILabel!
    @IBOutlet var txtParrafo: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
