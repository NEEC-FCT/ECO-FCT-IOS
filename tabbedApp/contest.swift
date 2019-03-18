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


class contest: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
  
    let list = ["Milk", "Honey", "Bread", "Tacos", "Tomatoes"]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(list.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row]
        cell.imageView?.image = UIImage(named: "lixo")
        
        return(cell)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.hideKeyboardWhenTappedAround()
        // Dispose of any resources that can be recreated.
        //Pedido
        NSLog("Pedido")
        let url = URL(string: "https://ecoapp.neec-fct.com/getStatus.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        

        var postString =   "&email=" + UserDefaults.standard.string(forKey: "EMAIL")!
        postString =   postString + "&token=" + UserDefaults.standard.string(forKey: "TOKEN")!
        
        NSLog("Pedido: " + postString)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                
                
                print("error=\(error!)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                
                
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("response = \(response!)")
            let dict = self.convertToDictionary(text: responseString!)
            print(dict!)
            
            //login
            // if( dict?["success"]  as! Int == 1 ){
            
            print("responseString = \(responseString!)")
            
         
        }
        task.resume()
        
        
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
