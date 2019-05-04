//
//  ATCClassicSignUpViewController.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/10/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

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

class ATCClassicSignUpViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var nameTextField: ATCTextField!
    @IBOutlet var phoneNumberTextField: ATCTextField!
    @IBOutlet var passwordTextField: ATCTextField!
    @IBOutlet var emailTextField: ATCTextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var signUpButton: UIButton!
     @IBOutlet var Regulamento: UILabel!

    private let tintColor = UIColor(hexString: "#4684ef")
    private let backgroundColor: UIColor = .white
    private let textFieldColor = UIColor(hexString: "#B0B3C6")
    
    private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")
    
 

    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private let textFieldFont = UIFont.systemFont(ofSize: 16)
    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ATCClassicSignUpViewController.tapFunction))
        Regulamento.isUserInteractionEnabled = true
        Regulamento.addGestureRecognizer(tap)
        
        let color = UIColor(hexString: "#282E4F")
        backButton.tintColor = color
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        titleLabel.font = titleFont
        titleLabel.text = "Registar"
        titleLabel.textColor = tintColor

        nameTextField.configure(color: textFieldColor!,
                                font: textFieldFont,
                                cornerRadius: 40/2,
                                borderColor: textFieldBorderColor,
            backgroundColor: backgroundColor,
            borderWidth: 1.0)
        nameTextField.placeholder = "Nome completo"
        nameTextField.clipsToBounds = true

        emailTextField.configure(color: textFieldColor!,
                                 font: textFieldFont,
                                 cornerRadius: 40/2,
                                 borderColor: textFieldBorderColor,
            backgroundColor: backgroundColor,
            borderWidth: 1.0)
        emailTextField.placeholder = "Repetir E-mail"
        emailTextField.clipsToBounds = true

        phoneNumberTextField.configure(color: textFieldColor!,
                                       font: textFieldFont,
                                       cornerRadius: 40/2,
                                       borderColor: textFieldBorderColor,
            backgroundColor: backgroundColor,
            borderWidth: 1.0)
        phoneNumberTextField.placeholder = "E-mail"
        phoneNumberTextField.clipsToBounds = true

        passwordTextField.configure(color: textFieldColor!,
                                    font: textFieldFont,
                                    cornerRadius: 40/2,
                                    borderColor: textFieldBorderColor,
                                    backgroundColor: backgroundColor,
                                    borderWidth: 1.0)
            passwordTextField.placeholder = "Password"
            passwordTextField.isSecureTextEntry = true
            passwordTextField.clipsToBounds = true

        signUpButton.setTitle("Criar conta", for: .normal)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        signUpButton.configure(color: backgroundColor,
                               font: buttonFont,
                               cornerRadius: 40/2,
                               backgroundColor: UIColor(hexString: "#334D92"))

        self.hideKeyboardWhenTappedAround()
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @objc func didTapBackButton() {
        
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Login")
            self.present(newViewController, animated: true, completion: nil)
        }
        self.navigationController?.popViewController(animated: true)
        
    }

    @objc func didTapSignUpButton() {
      
        if( emailTextField.text!.range(of:"@") == nil ){
            let alert = UIAlertController(title: "Alert", message: "Email must have a @", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            //campos vazios
        else if(   nameTextField.text!.count < 1 || emailTextField.text!.count < 1 || passwordTextField.text!.count < 1  ){
            
            let alert = UIAlertController(title: "Alert", message: "Não pode ter campos vazios", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            //password minimo
            
        else if( passwordTextField.text!.count < 6 ){
            let alert = UIAlertController(title: "Alert", message: "A password tem de ter 6 digitos", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
            
        else{
            NSLog("Pedido")
            let url = URL(string: "https://ecoapp.neec-fct.com/Register.php")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            
            let postString = "nome=" +  nameTextField.text! + "&password=" + passwordTextField.text! +  "&username=" + emailTextField.text!
            
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

    
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        
        guard let url = URL(string: "https://drive.google.com/file/d/1u0SV23Ba0pcJ1zjxYMJbHbg2wxJ-7DPO/view?usp=sharing") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        print("tap working")
    }
    
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
}
