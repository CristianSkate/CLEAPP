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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
