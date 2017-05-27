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

        self.title = titulo //"Doctrina"
        //self.navigationController?.navigationBar.barTintColor =  UIColor(red: 87.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 80.0/255.0, green: 50.0/255.0, blue: 04.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Volver", style: .plain, target: self, action: #selector(MantenedorDoctrinaViewController.volverAtras))
        
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        let initialContenViewController = self.paginaAtIndex(0) as FormatoPaginaViewController
        
        let viewControllers = NSArray(object: initialContenViewController)
        
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject] as? [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: self.view.frame.size.height-10)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func volverAtras(){
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnMenu(_ sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(.left, animated: true, completion: nil)
    }
    
    func paginaAtIndex(_ index: Int) ->FormatoPaginaViewController
    {
        
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "FormatoPaginaViewController") as! FormatoPaginaViewController
        
        pageContentViewController.pagina =  paginas[index]
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let viewController = viewController as! FormatoPaginaViewController
        var index = viewController.pageIndex as Int
        
        if(index == 0 || index == NSNotFound)
        {
            return nil
        }
        
        index -= 1
        
        return self.paginaAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let viewController = viewController as! FormatoPaginaViewController
        var index = viewController.pageIndex as Int
        
        if((index == NSNotFound))
        {
            return nil
        }
        
        index += 1
        
        if(index == paginas.count)
        {
            return nil
        }
        
        return  self.paginaAtIndex(index)
    }
    
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return paginas.count
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return 0
    }

}
