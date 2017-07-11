//
//  CeldaCardTableViewCell.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 10-07-17.
//  Copyright © 2017 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class CeldaCardTableViewCell: UITableViewCell {

    
    @IBOutlet var cardView: UIView!
    @IBOutlet var parrafoAzul: UITextView!
    @IBOutlet var parrafoBlanco: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    func textViewDidChange(_ textView: UITextView) {
        
        let contentSize = textView.sizeThatFits(textView.bounds.size)
        var frame = textView.frame
        frame.size.height = contentSize.height
        textView.frame = frame
        
        let aspectRatioViewConstraint = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: textView, attribute: .width, multiplier: textView.bounds.height/textView.bounds.width, constant: 1)
        textView.addConstraint(aspectRatioViewConstraint)
    }
}
