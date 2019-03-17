//
//  Question.swift
//  ECO FCT
//
//  Created by NEEC on 11/03/2019.
//  Copyright © 2019 MAGNUMIUM. All rights reserved.
//

import Foundation
import UIKit

class Question: UIViewController {
    
    
    
    var id:String = ""
    @IBOutlet weak var ButtonOne: UIButton!
    @IBOutlet weak var ButtonTwo: UIButton!
    @IBOutlet weak var ButtonThree: UIButton!
    @IBOutlet weak var Button3: UIButton!
    
    //Clicado
    @IBAction func ButtonOneClicked(_ sender: Any) {
    }
    
    @IBAction func ButtonTwoClicked(_ sender: Any) {
    }
    
    @IBAction func ButtonThreeClicked(_ sender: Any) {
    }
    
    @IBAction func ButtonFourClicked(_ sender: Any) {
    }
    
    
    func sendReply( resposta : Int){
        
        
        //Pedido
        NSLog("Pedido")
        let url = URL(string: "https://ecoapp.neec-fct.com/responderPergunta.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        
        
        var postString = "QRCode=" + (UserDefaults.standard.string(forKey: "loginJSONValue")! )
        postString =  postString + "&email=" + UserDefaults.standard.string(forKey: "EMAIL")!
        postString =   postString + "&token=" + UserDefaults.standard.string(forKey: "TOKEN")!
        
        postString =   postString + "&resposta=" + String ( resposta )
        postString =   postString + "&idPergunta=" + self.id
        
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
 
        //Pedido
        NSLog("Pedido")
        let url = URL(string: "https://ecoapp.neec-fct.com/getPergunta.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
    
        
        var postString = "QRCode=" + (UserDefaults.standard.string(forKey: "loginJSONValue")! )
        postString =  postString + "&email=" + UserDefaults.standard.string(forKey: "EMAIL")!
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
            
            if( dict?["sucess"] as! Bool ){
                DispatchQueue.main.async {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "correct")
                    self.present(newViewController, animated: true, completion: nil)
                }
            }
            else{
                
                DispatchQueue.main.async {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "wrong")
                    self.present(newViewController, animated: true, completion: nil)
                }
            }
            
         
        }
        task.resume()
    
        
        
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


