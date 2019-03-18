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
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
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

