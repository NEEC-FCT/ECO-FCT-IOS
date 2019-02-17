//
//  SecondViewController.swift
//  tabbedApp
//
//  Created by Sebastian Hette on 07.11.2016.
//  Copyright © 2016 MAGNUMIUM. All rights reserved.
//

import UIKit

class Parceiros: UIViewController {
    
    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Do any additional setup after loading the view, typically from a nib.
        let url = NSURL (string: "https://neec-fct.com/demoappp/equipa/team/partners.html");
        let requestObj = NSURLRequest(url: url! as URL);
        webview.loadRequest(requestObj as URLRequest);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

