//
//  CeldaMenuTableViewCell.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 06-10-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class CeldaMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var txtTituloOp: UILabel!
    @IBOutlet weak var imgMenu: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
