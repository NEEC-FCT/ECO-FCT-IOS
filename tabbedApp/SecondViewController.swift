//
//  SecondViewController.swift
//  tabbedApp
//
//  Created by Sebastian Hette on 07.11.2016.
//  Copyright © 2016 MAGNUMIUM. All rights reserved.
//

//Hex
extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}


import UIKit

class SecondViewController: UIViewController  , UICollectionViewDataSource, UICollectionViewDelegate  , UICollectionViewDelegateFlowLayout{

    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var descricao = ["Papel ou Cartão", "Plástico ou Metal", "Vidro", "Resíduo Perigoso", "Resíduo de Elétricos", "Lâmpada", "Óleo lubrificante", "Mobiliário", "Resíduo Orgânico" ]
    var imagens   = ["textdocuments", "bag", "fragile", "dangerouscan", "circuitboard", "lamp", "diesel", "couch", "apple" ]
    var hex   = ["#09A9FF", "#faff00", "#05af21" , "#4BAA50", "#F94336", "#09A9FF", "#e5f71b", "#673BB7", "#995710" ]
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.descricao.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
        //Set na celu
        cell.myLabel.text = self.descricao[indexPath.item]
        cell.image.image = UIImage(named: self.imagens[indexPath.item] )
        cell.backgroundColor = UIColor(hexString: self.hex[indexPath.item] )
        
        return cell
    }
    
    
    func openMail(email:String){
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
  
    
    func showWarning( mensagem:String , email:String){
        let alert = UIAlertController(title: "", message: mensagem, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        alert.addAction(UIAlertAction(title: "Já tenho", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                self.openMail(email: email)
                
            case .cancel:
                print("cancel")
                self.openMail(email: email)
                
            case .destructive:
                print("destructive")
                self.openMail(email: email)
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        if(indexPath.item == 0){
            DispatchQueue.main.async(){
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "Paper")
                self.present(newViewController, animated: false, completion: nil)
            }
        }
       else  if(indexPath.item == 1){
            DispatchQueue.main.async(){
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "plastic")
                self.present(newViewController, animated: false, completion: nil)
            }
        }
        else  if(indexPath.item == 2){
            DispatchQueue.main.async(){
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "glass")
                self.present(newViewController, animated: false, completion: nil)
            }
        }
        else  if(indexPath.item == 3){
            guard let url = URL(string: "https://bd2.fct.unl.pt/v7/downloads/dat/ef025_03_entrega_res_perigosos_0118.pdf ") else { return }
            UIApplication.shared.open(url)
        }
        else  if(indexPath.item == 4){
            
             showWarning( mensagem: "Solicite à Direção o abate do equipamento" , email: "div.at.sg.helpdesk@fct.unl.pt")
           
        }
        else  if(indexPath.item == 5){
             showWarning( mensagem: "Coloque a lâmpada usada inteira na embalagem de cartão da lâmpada nova" , email: "div.at.sg.helpdesk@fct.unl.pt")
           
        }
        else  if(indexPath.item == 6){
            guard let url = URL(string: "https://bd2.fct.unl.pt/v7/downloads/dat/ef025_03_entrega_res_perigosos_0118.pdf") else { return }
            UIApplication.shared.open(url)
            
        }
        else  if(indexPath.item == 7){
            showWarning( mensagem: "Solicite à Direção o abate do equipamento" , email: "div.at.sg.helpdesk@fct.unl.pt")
            
        }
        else  if(indexPath.item == 8){
           //abrir o mapa
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  10
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
  


}

