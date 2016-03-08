//
//  OrganicaViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 23-10-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class OrganicaViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imgOrganica: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Orgánica"
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Black
        
        var image = UIImage(named: "Menu")
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "btnMenu:")

        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imgOrganica
    }
    

    @IBAction func btnMenu(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true, completion: nil)
    }

}
