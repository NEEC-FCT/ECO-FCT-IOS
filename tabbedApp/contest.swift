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


class contest: UIViewController ,  UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var NomeLabel: UILabel!
    @IBOutlet weak var PontosLabel: UILabel!
    @IBOutlet weak var posicaoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trofeuLabel: UILabel!
    
    var list = [""]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(list.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row]
        cell.imageView?.image = UIImage(named: "lixo")
        
        return(cell)
    }

    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Necessita login
    if(  UserDefaults.standard.string(forKey: "EMAIL")  == nil ){
        let alertController = UIAlertController(title: "Alerta", message: "Necessita de Login", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Voltar", style: .default) { (action:UIAlertAction) in
            print("You've pressed Voltar");
            
                DispatchQueue.main.async(){
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "starter")
                    self.present(newViewController, animated: false, completion: nil)
                }
            
        }
        
        let action2 = UIAlertAction(title: "Login", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed Login");
           
                DispatchQueue.main.async(){
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "NavLogin")
                    self.present(newViewController, animated: false, completion: nil)
                }
            
        }
        
        
        alertController.addAction(action1)
        alertController.addAction(action2)
     
        self.present(alertController, animated: true, completion: nil)
          }
    
        
        self.hideKeyboardWhenTappedAround()
        // Dispose of any resources that can be recreated.
        //Pedido
         if(  UserDefaults.standard.string(forKey: "EMAIL")  != nil ){
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
            
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
                // your code here
          
            print("Pontos")
            print(dict?["pontos"] as! String )
            self.NomeLabel.text =  "Nome: " + ( dict?["nome"] as! String )
            self.trofeuLabel.text = "Pontos: " + (dict?["pontos"] as! String )
            self.posicaoLabel.text = "Posição: " + String(dict?["pos"] as! Int )
           
            self.list.insert((dict?["1"] as! String ), at: 0)
            self.list.insert((dict?["2"] as! String ), at: 1)
            self.list.insert((dict?["3"] as! String ), at: 2)
            self.list.insert((dict?["4"] as! String ), at: 3)
            self.list.insert((dict?["5"] as! String ), at: 4)
            self.list.insert((dict?["6"] as! String ), at: 5)
            self.list.insert((dict?["7"] as! String ), at: 6)
            self.list.insert((dict?["8"] as! String ), at: 7)
            self.list.insert((dict?["9"] as! String ), at: 8)
            self.list.insert((dict?["10"] as! String ), at: 9)
            self.list.insert((dict?["11"] as! String ), at: 10)
          
            self.tableView.reloadData()
            }
          
        }
        task.resume()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        
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
