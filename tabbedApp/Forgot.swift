//
//  Forgot.swift
//  ECO FCT
//
//  Created by NEEC on 18/02/2019.
//  Copyright © 2019 MAGNUMIUM. All rights reserved.
//

import Foundation
import UIKit

class Forgot: UIViewController {
    
    @IBOutlet weak var emailLabel: UITextField!
    
    
    
    
    @IBAction func SendClicked(_ sender: Any) {
        
        //email tem arruba
        if( emailLabel.text!.range(of:"@") == nil ){
            let alert = UIAlertController(title: "Alert", message: "Email must have a @", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if( emailLabel.text!.count < 1  ){
            
            let alert = UIAlertController(title: "Alert", message: "Can not be empty fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
            //Pedido
        else{
            NSLog("Pedido")
            let url = URL(string: "https://ecoapp.neec-fct.com/recoverRequest.php")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            
            let postString = "email=" + emailLabel.text!
            
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
                
                //login
                if( dict?["success"]  as! Int == 1 ){
                    print( "Vou mudar " )
                    DispatchQueue.main.async {
                        
                        let alertController = UIAlertController(title: "Alert", message: "Success check your email", preferredStyle: .alert)
                        
                        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                            //go to storyboard
                            
                        }
                        
                        
                        
                        alertController.addAction(action1)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                    }
                    
                    
                    
                }
                    //Erro
                else{
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Erro", message: "Not a valid email", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                                
                                
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                print("responseString = \(responseString!)")
            }
            task.resume()
        }
        
    }
    
   override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

