//
//  SecondViewController.swift
//  tabbedApp
//
//  Created by Sebastian Hette on 07.11.2016.
//  Copyright © 2016 MAGNUMIUM. All rights reserved.
//




import UIKit

class  PaperChoosed: UIViewController  , UICollectionViewDataSource, UICollectionViewDelegate  , UICollectionViewDelegateFlowLayout{
    
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var descricao = [  "Deposite" , "Não Deposite" , "Embalagens de cartão e papel" , "Embalagens contaminadas com substâncias perigosas " , "Jornais,Revistas" ,"Resíduos orgânicos" ,"Papel de escrita e impresso" , "Guardanapos e lenços de papel" , "Sacos de papel" , "Loiça de papel" , "Livros / Cadernos (sem argolas)" , "Papel sujo ou húmido " , "" , "Papel vegetal, de alumínio, encerado ou com plástico " , "" , "Embalagens de cartão com gordura" , "" ,"Toalhetes e fraldas " , "" , "Autocolantes"  , "Voltar" ]
    
        var cores = [  "#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ,"#962525" , "#4286f4" ]
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.descricao.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PaperCell
        
        //Set na celu
        if(self.descricao[indexPath.item].count < 3){
            cell.myLabel.isHidden = true
        }
        else{
        cell.myLabel.text = self.descricao[indexPath.item]
       cell.myLabel.backgroundColor = UIColor(hexString: self.cores[indexPath.item]  )
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
         UserDefaults.standard.set( 4  , forKey: "ZOOM")
            DispatchQueue.main.async(){
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "starter")
                self.present(newViewController, animated: false, completion: nil)
            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  10
        let collectionViewSize = collectionView.frame.size.width - padding
        
        
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/4)
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

