//
//  FormatoPaginaViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 03-12-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class FormatoPaginaViewController: UIViewController {

    @IBOutlet weak var imgPagina: UIImageView!
    var pagina:UIImage!
    var pageIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgPagina.image = pagina
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
