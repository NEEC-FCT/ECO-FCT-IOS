//
//  SecondViewController.swift
//  tabbedApp
//
//  Created by Sebastian Hette on 07.11.2016.
//  Copyright © 2016 MAGNUMIUM. All rights reserved.
//

import UIKit

class NEEC: UIViewController {
    
    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL (string: "https://neec-fct.com")
        let requestObj = URLRequest(url: url!)
        webview.loadRequest(requestObj)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

