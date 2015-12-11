//
//  MantenedorDoctrinaViewController.swift
//  CLE Chile
//
//  Created by Cristian Martinez Toledo on 09-12-15.
//  Copyright © 2015 Cristian Martinez Toledo. All rights reserved.
//

import UIKit

class MantenedorDoctrinaViewController: UIViewController, UIPageViewControllerDataSource {

    var pageViewController:UIPageViewController!
    var paginas:[UIImage]!
    var titulo:String!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = titulo//"Doctrina"
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.translucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Black
        
        var image = UIImage(named: "Menu")
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "btnMenu:")
        
        //comienzo uipageviewer
        
//        for var i:Int = 0; i<45 ; i++ {
//            if (i < 9){
//                paginas.append(UIImage(named: ("Diapositiva0\(i+1)"))!)
//            }else{
//                paginas.append(UIImage(named: ("Diapositiva\(i+1)"))!)
//            }
//        }
        //paginas = [UIImage(named: "pag1")!,UIImage(named: "pag2")!]
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        let initialContenViewController = self.paginaAtIndex(0) as FormatoPaginaViewController
        
        let viewControllers = NSArray(object: initialContenViewController)
        
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height-10)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        // Do any additional setup after loading the view.
    }
    
//    func cargarFotos() -> [UIImage]{
//        var pag:[UIImage] = []
//        
//        for var i:Int = 0; i<45 ; i++ {
//            pag.append(UIImage(named: ("Diapositiva\(i+1)"))!)
//        }
//        return pag
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnMenu(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    func paginaAtIndex(index: Int) ->FormatoPaginaViewController
    {
        
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FormatoPaginaViewController") as! FormatoPaginaViewController
        
        pageContentViewController.pagina =  paginas[index]
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let viewController = viewController as! FormatoPaginaViewController
        var index = viewController.pageIndex as Int
        
        if(index == 0 || index == NSNotFound)
        {
            return nil
        }
        
        index--
        
        return self.paginaAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let viewController = viewController as! FormatoPaginaViewController
        var index = viewController.pageIndex as Int
        
        if((index == NSNotFound))
        {
            return nil
        }
        
        index++
        
        if(index == paginas.count)
        {
            return nil
        }
        
        return  self.paginaAtIndex(index)
    }
    
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return paginas.count
    }
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }

}
