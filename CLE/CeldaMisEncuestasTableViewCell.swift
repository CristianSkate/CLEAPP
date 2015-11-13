//
//  CeldaMisEncuestasTableViewCell.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 01-11-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class CeldaMisEncuestasTableViewCell: UITableViewCell {

    
    @IBOutlet weak var txtNombreEncuestado: UILabel!
    @IBOutlet weak var btnResponder: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
