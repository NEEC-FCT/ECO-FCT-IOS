//
//  contest.swift
//  ECO FCT
//
//  Created by NEEC on 18/02/2019.
//  Copyright © 2019 MAGNUMIUM. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class contest: UIViewController {
    
  

    @IBAction func scanQR(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.hideKeyboardWhenTappedAround()
        // Dispose of any resources that can be recreated.
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
}
