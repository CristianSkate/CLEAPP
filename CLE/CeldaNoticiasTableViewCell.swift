//
//  CeldaNoticiasTableViewCell.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 08-12-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class CeldaNoticiasTableViewCell: UITableViewCell {

    @IBOutlet weak var imgImagen: UIImageView!
    @IBOutlet weak var txtTitulo: UILabel!
    @IBOutlet weak var txtResumen: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
