//
//  Register.swift
//  ECO FCT
//
//  Created by NEEC on 18/02/2019.
//  Copyright © 2019 MAGNUMIUM. All rights reserved.
//

import Foundation
import UIKit

class Register: UIViewController , UIGestureRecognizerDelegate {
    
    @IBOutlet weak var nomeLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passLabel: UITextField!
    @IBOutlet weak var eulaLabel: UILabel!
    @IBOutlet weak var RegulamentoLabel: UILabel!
    
    @IBAction func regulamentoClicked(_ sender: Any) {
        
        guard let url = URL(string: "https://drive.google.com/file/d/1u0SV23Ba0pcJ1zjxYMJbHbg2wxJ-7DPO/view?usp=sharing") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func RegisterClicked(_ sender: Any) {
        
        if( emailLabel.text!.range(of:"@") == nil ){
            let alert = UIAlertController(title: "Alert", message: "Email must have a @", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            //campos vazios
        else if(   nomeLabel.text!.count < 1 || emailLabel.text!.count < 1 || passLabel.text!.count < 1  ){
            
            let alert = UIAlertController(title: "Alert", message: "Can not have empty fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            //password minimo
            
        else if( passLabel.text!.count < 6 ){
            let alert = UIAlertController(title: "Alert", message: "Password must be at least 6 letters long", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
      
        else{
            NSLog("Pedido")
            let url = URL(string: "https://ecoapp.neec-fct.com/Register.php")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            
            let postString = "nome=" +  nomeLabel.text! + "&password=" + passLabel.text! +  "&username=" + emailLabel.text!
            
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
                        
                        let alertController = UIAlertController(title: "Alert", message: "Success", preferredStyle: .alert)
                        
                        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                            //go to storyboard
                            sleep(2)
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Login")
                            self.present(newViewController, animated: true, completion: nil)
                        }
                        
                        
                        
                        alertController.addAction(action1)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                    }
                    
                    
                    
                }
                    //Erro
                else{
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "Email in use", preferredStyle: .alert)
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
