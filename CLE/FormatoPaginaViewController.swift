//
//  FormatoPaginaViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 03-12-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class FormatoPaginaViewController: UIViewController, UIScrollViewDelegate{

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgPagina: UIImageView!
    var pagina:UIImage!
    var pageIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        imgPagina.image = pagina

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imgPagina
    }
    


}
