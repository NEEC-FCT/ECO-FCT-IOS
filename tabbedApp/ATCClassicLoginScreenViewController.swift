//
//  ATCClassicLoginScreenViewController.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/9/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ATCClassicLoginScreenViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var passwordTextField: ATCTextField!
    @IBOutlet var contactPointTextField: ATCTextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var separatorLabel: UILabel!
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var backButton: UIButton!

    private let backgroundColor: UIColor = .white
    private let tintColor = UIColor(hexString: "#4684ef")

    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)

    private let textFieldFont = UIFont.systemFont(ofSize: 24)
    private let textFieldColor = UIColor(hexString: "#B0B3C6")
    private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")

    private let separatorFont = UIFont.boldSystemFont(ofSize: 14)
    private let separatorTextColor = UIColor(hexString: "#464646")

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
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Forgot")
            self.present(newViewController, animated: true, completion: nil)
        }
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(UIImage.localImage("arrow-back-icon", template: true), for: .normal)
        backButton.tintColor = UIColor(hexString: "#282E4F")
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        titleLabel.font = titleFont
        titleLabel.text = "Entrar"
        titleLabel.textColor = tintColor

        contactPointTextField.configure(color: textFieldColor!,
                                        font: textFieldFont,
                                        cornerRadius: 55/2,
                                        borderColor: textFieldBorderColor,
                                        backgroundColor: backgroundColor,
                                        borderWidth: 1.0)
        contactPointTextField.placeholder = "E-mail"
        contactPointTextField.textContentType = .emailAddress
        contactPointTextField.clipsToBounds = true

        passwordTextField.configure(color: textFieldColor!,
                                font: textFieldFont,
                                cornerRadius: 55/2,
                                borderColor: textFieldBorderColor,
                                backgroundColor: backgroundColor,
                                borderWidth: 1.0)
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .emailAddress
        passwordTextField.clipsToBounds = true

        separatorLabel.font = separatorFont
        separatorLabel.textColor = separatorTextColor
        separatorLabel.text = "Esqueceu"
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ATCClassicLoginScreenViewController.tapFunction))
        separatorLabel.isUserInteractionEnabled = true
        separatorLabel.addGestureRecognizer(tap)
        

        loginButton.setTitle("Validar", for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        loginButton.configure(color: backgroundColor,
                              font: buttonFont,
                              cornerRadius: 55/2,
                              backgroundColor: tintColor!)

        facebookButton.setTitle("Registo", for: .normal)
        facebookButton.addTarget(self, action: #selector(didTapFacebookButton), for: .touchUpInside)
        facebookButton.configure(color: backgroundColor,
                                 font: buttonFont,
                                 cornerRadius: 55/2,
                                 backgroundColor: UIColor(hexString: "#334D92"))
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "starter")
            self.present(newViewController, animated: true, completion: nil)
        }
    }

    @objc func didTapLoginButton() {
       
        NSLog("clicou")
        
        
        let url = URL(string: "https://ecoapp.neec-fct.com/Login.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "username=" + contactPointTextField.text! + "&password=" + passwordTextField.text!
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
            
            let dict = self.convertToDictionary(text: responseString!)
            
            //login
            if( dict?["success"]  as! Int == 1 ){
                print( "Vou mudar " )
                
                
                UserDefaults.standard.set( dict?["token"]  as! String, forKey: "TOKEN")
             
                 UserDefaults.standard.set( dict?["email"]  as! String, forKey: "EMAIL")
                
                //go to storyboard
                DispatchQueue.main.async {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "starter")
                    self.present(newViewController, animated: true, completion: nil)
                }
                
                
                
            }
                //Erro
            else{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Check your password", preferredStyle: .alert)
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

    @objc func didTapFacebookButton() {
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "registo")
            self.present(newViewController, animated: true, completion: nil)
        }
    }

    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
}
