//
//  CeldaDoctrinasTableViewCell.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 09-12-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class CeldaDoctrinasTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCaratula: UIImageView!
    @IBOutlet weak var txtTituloDocumento: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
