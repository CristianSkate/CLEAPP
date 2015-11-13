//
//  RespuestasTableViewCell.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 11-11-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class RespuestasTableViewCell: UITableViewCell {

    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var txtTexto: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgSelected.image = UIImage(named: "radUnChecked")

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            imgSelected.image = UIImage(named: "radChecked")
        }else{
            imgSelected.image = UIImage(named: "radUnChecked")
        }
    }

}
