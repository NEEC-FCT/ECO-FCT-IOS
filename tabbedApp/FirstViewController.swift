

import UIKit
import MapKit
import JJFloatingActionButton

class FirstViewController: UIViewController {

  
    @IBOutlet weak var map: MKMapView!
    var EcoPoint: Set<MKPointAnnotation> = []
    var ContainerPoint: Set<MKPointAnnotation> = []
    var AmarelosPoint: Set<MKPointAnnotation> = []
    var TrashPoint: Set<MKPointAnnotation> = []
    let actionButton = JJFloatingActionButton()
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    
    func getClosestAmareloPoint(){
        // iterate over all items in the set
        
        let maxDistance:Double = 555555
        var point:MKPointAnnotation? = nil
        
        for item in AmarelosPoint {
            
            let distancia = getdistance(loc2: item)
            if( distancia < maxDistance){
                point = item
            }
            
        }
        //Set do ponto
        print(point?.coordinate.latitude)
        print(point?.coordinate.longitude)
        setMap(point: point!)
        
    }
    
    func getClosestEcoPoint(){
        // iterate over all items in the set
        
        let maxDistance:Double = 555555
        var point:MKPointAnnotation? = nil
        
        for item in EcoPoint {
            
            let distancia = getdistance(loc2: item)
            if( distancia < maxDistance){
                point = item
            }
            
        }
        //Set do ponto
        setMap(point: point!)
        
    }
    
    func getClosestContainer(){
        // iterate over all items in the set
        
        let maxDistance:Double = 555555
        var point:MKPointAnnotation? = nil
        
        for item in ContainerPoint {
            
            let distancia = getdistance(loc2: item)
            if( distancia < maxDistance){
                point = item
            }
            
        }
        //Set do ponto
        setMap(point: point!)
        
    }
    
    
    func getdistance(loc2: MKPointAnnotation ) -> Double{
        
        let loc1:CLLocationCoordinate2D = self.locationManager.location!.coordinate
        //My location
        let myLocation = CLLocation(latitude: loc1.latitude, longitude: loc1.longitude)
        print(loc1.latitude)
        print(loc1.longitude)
        
        //My buddy's location
        let myBuddysLocation = CLLocation(latitude: loc2.coordinate.latitude, longitude: loc2.coordinate.longitude)
        
        //Measuring my distance to my buddy's (in km)
        print( myLocation.distance(from: myBuddysLocation)  / 1000)
        return myLocation.distance(from: myBuddysLocation) / 1000

    }
    
    func setMap(point:MKPointAnnotation){
        let span:MKCoordinateSpan = MKCoordinateSpan( latitudeDelta: 0.0008 , longitudeDelta: 0.0008)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(point.coordinate.latitude,  point.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)
    }

    func getClosestTrash(){
        // iterate over all items in the set
       
        let maxDistance:Double = 555555
        var point:MKPointAnnotation? = nil
        
        for item in TrashPoint {
          
            let distancia = getdistance(loc2: item)
            if( distancia < maxDistance){
                point = item
            }
        
        }
        //Set do ponto
        setMap(point: point!)
      
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                map.setRegion(viewRegion, animated: false)
            }
        }
    }
    
    

    
   
    
    override func viewDidLoad() {
        
      
        
       
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
       
        //checkar o login
        
        actionButton.addItem(title: "Saco amarelo", image: UIImage(named: "recycle")?.withRenderingMode(.alwaysTemplate)) { item in
            
            self.getClosestAmareloPoint()
            
            
            
        }
        
        actionButton.addItem(title: "Papeleiras", image: UIImage(named: "recycle")?.withRenderingMode(.alwaysTemplate)) { item in
            
            self.getClosestTrash()

            
            
        }
        
        actionButton.addItem(title: "Ecopontos", image: UIImage(named: "ecoamarelo")?.withRenderingMode(.alwaysTemplate)) { item in
            self.getClosestEcoPoint()
            
        }
        
        actionButton.addItem(title: "Contentores", image: UIImage(named: "lixo")?.withRenderingMode(.alwaysTemplate)) { item in
            self.getClosestContainer()
        }
        
        
        actionButton.addItem(title: "Scan", image: UIImage(named: "qrcode")?.withRenderingMode(.alwaysTemplate)) { item in
            
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
            
            else  {
            DispatchQueue.main.async {
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "qrreader")
                self.present(newViewController, animated: true, completion: nil)
                
              }
            }
        }
        
        
        view.addSubview(actionButton)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        } else {
            // Fallback on earlier versions
            actionButton.display(inViewController: self)
        }
        
      
            
    
            
            super.viewDidLoad()
        let span:MKCoordinateSpan = MKCoordinateSpan( latitudeDelta: 0.008 , longitudeDelta: 0.008)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661307,  -9.207192)
            
        let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
            map.setRegion(region, animated: true)
            
            EcoPointInit()
            AmarelosInit()
            ContainersInit()
            TrashInit()
            print(EcoPoint)
            print(TrashPoint)
            print(ContainerPoint)
            //}
        
        let change =   UserDefaults.standard.integer(forKey: "ZOOM")
        
        UserDefaults.standard.set( 0  , forKey: "ZOOM")
        if(change == 1){
            self.getClosestAmareloPoint()
        }
        else if(change == 2){
            self.getClosestTrash()
        }
        else if(change == 3){
            self.getClosestEcoPoint()
        }
        else if(change == 4){
            self.getClosestContainer()
        }
        
    }

    //Adiciona o lixo
    func TrashInit(){
        //Ponto
        let annotation1 = MKPointAnnotation()
        let location1:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661050, -9.205007)
        annotation1.coordinate = location1
        annotation1.title =  ""
        annotation1.subtitle = "Papeleiras"
        map.addAnnotation(annotation1)
        TrashPoint.insert(annotation1)
        //Fim Ponto
        //Ponto
        let annotation2 = MKPointAnnotation()
        let location2:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.662693, -9.2064)
        annotation2.coordinate = location2
        annotation2.title =  ""
        annotation2.subtitle = "Papeleiras"
        map.addAnnotation(annotation2)
        TrashPoint.insert(annotation2)
        //Fim Ponto
        //Ponto
        let annotation3 = MKPointAnnotation()
        let location3:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.662728, -9.206014)
        annotation3.coordinate = location3
        annotation3.title =  ""
        annotation3.subtitle = "Papeleiras"
        map.addAnnotation(annotation3)
        TrashPoint.insert(annotation3)
        //Fim Ponto
        //Ponto
        let annotation4 = MKPointAnnotation()
        let location4:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.663517, -9.206063)
        annotation4.coordinate = location4
        annotation4.title =  ""
        annotation4.subtitle = "Papeleiras"
        map.addAnnotation(annotation4)
        TrashPoint.insert(annotation4)
        //Fim Ponto
        //Ponto
        let annotation5 = MKPointAnnotation()
        let location5:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.66306, -9.207816)
        annotation5.coordinate = location5
        annotation5.title =  ""
        annotation5.subtitle = "Papeleiras"
        
        map.addAnnotation(annotation5)
        TrashPoint.insert(annotation5)
        //Fim Ponto
        //Ponto
        let annotation6 = MKPointAnnotation()
        let location6:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.662853, -9.207483)
        annotation6.coordinate = location6
        annotation6.title =  ""
        annotation6.subtitle = "Papeleiras"
        map.addAnnotation(annotation6)
        TrashPoint.insert(annotation6)
        //Fim Ponto
        //Ponto
        let annotation7 = MKPointAnnotation()
        let location7:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.6627, -9.207313)
        annotation7.coordinate = location7
        annotation7.title =  ""
        annotation7.subtitle = "Papeleiras"
        map.addAnnotation(annotation7)
        TrashPoint.insert(annotation7)
        //Fim Ponto
        //Ponto
        let annotation8 = MKPointAnnotation()
        let location8:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.662474, -9.207367)
        annotation8.coordinate = location8
        annotation8.title =  ""
        annotation8.subtitle = "Papeleiras"
        map.addAnnotation(annotation8)
        TrashPoint.insert(annotation8)
        //Fim Ponto
        //Ponto
        let annotation9 = MKPointAnnotation()
        let location9:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.662703, -9.207032)
        annotation9.coordinate = location9
        annotation9.title =  ""
        annotation9.subtitle = "Papeleiras"
        map.addAnnotation(annotation9)
        TrashPoint.insert(annotation9)
        //Fim Ponto
        //Ponto
        let annotation10 = MKPointAnnotation()
        let location10:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.6627, -9.206707)
        annotation10.coordinate = location10
        annotation10.title =  ""
        annotation10.subtitle = "Papeleiras"
        map.addAnnotation(annotation10)
        TrashPoint.insert(annotation10)
        //Fim Ponto
        //Ponto
        let annotation11 = MKPointAnnotation()
        let location11:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.662065, -9.207374)
        annotation11.coordinate = location11
        annotation11.title =  ""
        annotation11.subtitle = "Papeleiras"
        map.addAnnotation(annotation11)
        TrashPoint.insert(annotation11)
        //Fim Ponto
        //Ponto
        let annotation12 = MKPointAnnotation()
        let location12:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661818, -9.206189)
        annotation12.coordinate = location12
        annotation12.title =  ""
        annotation12.subtitle = "Papeleiras"
        map.addAnnotation(annotation12)
        TrashPoint.insert(annotation12)
        //Fim Ponto

    }
    
    //Adiciona os amarelos
    func AmarelosInit(){
        let annotation = MKPointAnnotation()
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(36.663213 , -9.206909)
        annotation.coordinate = location
        annotation.title =  ""
        annotation.subtitle = "Saco amarelo"
        map.addAnnotation(annotation)
        AmarelosPoint.insert(annotation)
        //Fim Ponto
        //Ponto
        let annotation1 = MKPointAnnotation()
        let location1:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.663065 ,  -9.207025)
        annotation1.coordinate = location1
        annotation1.title =  ""
        annotation1.subtitle = "Saco amarelo"
        map.addAnnotation(annotation1)
        AmarelosPoint.insert(annotation1)
        //Fim Ponto
        //Ponto
        let annotation2 = MKPointAnnotation()
        let location2:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.663053 , -9.207214)
        annotation2.coordinate = location2
        annotation2.title =  ""
        annotation2.subtitle = "Saco amarelo"
        map.addAnnotation(annotation2)
        AmarelosPoint.insert(annotation2)
        //Fim Ponto
        //Ponto
        let annotation3 = MKPointAnnotation()
        let location3:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.662532 , -9.207467)
        annotation3.coordinate = location3
        annotation3.title =  ""
        annotation3.subtitle = "Saco amarelo"
        map.addAnnotation(annotation3)
        AmarelosPoint.insert(annotation3)
        //Fim Ponto
        //Ponto
        let annotation4 = MKPointAnnotation()
        let location4:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661874 , -9.207785)
        annotation4.coordinate = location4
        annotation4.title =  ""
        annotation4.subtitle = "Saco amarelo"
        map.addAnnotation(annotation4)
        AmarelosPoint.insert(annotation4)
        //Fim Ponto
        //Ponto
        let annotation5 = MKPointAnnotation()
        let location5:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661599 ,  -9.206665)
        annotation5.coordinate = location5
        annotation5.title =  ""
        annotation5.subtitle = "Saco amarelo"
        map.addAnnotation(annotation5)
        AmarelosPoint.insert(annotation5)
        //Fim Ponto
        //Ponto
        let annotation6 = MKPointAnnotation()
        let location6:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661947 , -9.206347)
        annotation6.coordinate = location6
        annotation6.title =  ""
        annotation6.subtitle = "Saco amarelo"
        map.addAnnotation(annotation6)
        AmarelosPoint.insert(annotation6)
        //Fim Ponto
        //Ponto
        let annotation7 = MKPointAnnotation()
        let location7:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.662153 ,  -9.205929)
        annotation7.coordinate = location7
        annotation7.title =  ""
        annotation7.subtitle = "Saco amarelo"
        map.addAnnotation(annotation7)
        AmarelosPoint.insert(annotation7)
        //Fim Ponto
        //Ponto
        let annotation8 = MKPointAnnotation()
        let location8:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.662586 ,  -9.205320)
        annotation8.coordinate = location8
        annotation8.title =  ""
        annotation8.subtitle = "Saco amarelo"
        map.addAnnotation(annotation8)
        AmarelosPoint.insert(annotation8)
        //Fim Ponto
        //Ponto
        let annotation9 = MKPointAnnotation()
        let location9:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.662008 , -9.204093)
        annotation9.coordinate = location9
        annotation9.title =  ""
        annotation9.subtitle = "Saco amarelo"
        map.addAnnotation(annotation9)
        AmarelosPoint.insert(annotation9)
        //Fim Ponto
        //Ponto
        let annotation10 = MKPointAnnotation()
        let location10:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661789 , -9.204689)
        annotation10.coordinate = location10
        annotation10.title =  ""
        annotation10.subtitle = "Saco amarelo"
        map.addAnnotation(annotation10)
        AmarelosPoint.insert(annotation10)
        //Fim Ponto
        //Ponto
        let annotation11 = MKPointAnnotation()
        let location11:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661470 , -9.205313)
        annotation11.coordinate = location11
        annotation11.title =  ""
        annotation11.subtitle = "Saco amarelo"
        map.addAnnotation(annotation11)
        AmarelosPoint.insert(annotation11)
        //Fim Ponto
        //Ponto
        let annotation12 = MKPointAnnotation()
        let location12:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.6622796 , -9.204981)
        annotation12.coordinate = location12
        annotation12.title =  ""
        annotation12.subtitle = "Saco amarelo"
        map.addAnnotation(annotation12)
        AmarelosPoint.insert(annotation12)
        //Fim Ponto
        //Ponto
        let annotation13 = MKPointAnnotation()
        let location13:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661242 , -9.205155)
        annotation13.coordinate = location13
        annotation13.title =  ""
        annotation13.subtitle = "Saco amarelo"
        map.addAnnotation(annotation13)
        AmarelosPoint.insert(annotation13)
        //Fim Ponto
        //Ponto
        let annotation14 = MKPointAnnotation()
        let location14:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 38.661150 , -9.204850)
        annotation14.coordinate = location14
        annotation14.title =  ""
        annotation14.subtitle = "Saco amarelo"
        map.addAnnotation(annotation14)
        AmarelosPoint.insert(annotation14)
        //Fim Ponto
        //Ponto
        let annotation15 = MKPointAnnotation()
        let location15:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661459 , -9.204640)
        annotation15.coordinate = location15
        annotation15.title =  ""
        annotation15.subtitle = "Saco amarelo"
        map.addAnnotation(annotation15)
        AmarelosPoint.insert(annotation15)
        //Fim Ponto
        //Ponto
        let annotation16 = MKPointAnnotation()
        let location16:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661501,  -9.203496)
        annotation16.coordinate = location16
        annotation16.title =  ""
        annotation16.subtitle = "Saco amarelo"
        map.addAnnotation(annotation16)
        AmarelosPoint.insert(annotation16)
        //Fim Ponto
        //Ponto
        let annotation17 = MKPointAnnotation()
        let location17:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661064 , -9.203010)
        annotation17.coordinate = location17
        annotation17.title =  ""
        annotation17.subtitle = "Saco amarelo"
        map.addAnnotation(annotation17)
        AmarelosPoint.insert(annotation17)
        //Fim Ponto
        //Ponto
        let annotation18 = MKPointAnnotation()
        let location18:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.660306 , -9.204131)
        annotation18.coordinate = location18
        annotation18.title =  ""
        annotation18.subtitle = "Saco amarelo"
        map.addAnnotation(annotation18)
        AmarelosPoint.insert(annotation18)
        //Fim Ponto
        
        
        //Ponto
        let annotation20 = MKPointAnnotation()
        let location20:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.660806, -9.204810)
        annotation20.coordinate = location20
        annotation20.title =  ""
        annotation20.subtitle = "Saco amarelo"
        map.addAnnotation(annotation20)
        AmarelosPoint.insert(annotation20)
        //Fim Ponto
        
        //Ponto
        let annotation21 = MKPointAnnotation()
        let location21:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.660773 , -9.205819)
        annotation21.coordinate = location21
        annotation21.title =  ""
        annotation21.subtitle = "Saco amarelo"
        map.addAnnotation(annotation21)
        AmarelosPoint.insert(annotation21)
        //Fim Ponto
        
        //Ponto
        let annotation22 = MKPointAnnotation()
        let location22:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.660438 , -9.205685)
        annotation22.coordinate = location22
        annotation22.title =  ""
        annotation22.subtitle = "Saco amarelo"
        map.addAnnotation(annotation22)
        AmarelosPoint.insert(annotation22)
        //Fim Ponto
        
        //Ponto
        let annotation23 = MKPointAnnotation()
        let location23:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.660363 , -9.206723)
        annotation23.coordinate = location23
        annotation23.title =  ""
        annotation23.subtitle = "Saco amarelo"
        map.addAnnotation(annotation23)
        AmarelosPoint.insert(annotation23)
        //Fim Ponto
        
        //Ponto
        let annotation24 = MKPointAnnotation()
        let location24:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.660292 , -9.206993)
        annotation24.coordinate = location24
        annotation24.title =  ""
        annotation24.subtitle = "Saco amarelo"
        map.addAnnotation(annotation24)
        AmarelosPoint.insert(annotation24)
        //Fim Ponto
        

        
        
    }
    //Adiciona container
    func ContainersInit(){
        //Ponto
        let annotation = MKPointAnnotation()
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.6627 , -9.207313)
        annotation.coordinate = location
        annotation.title =  ""
        annotation.subtitle = "Contentores"
        map.addAnnotation(annotation)
        ContainerPoint.insert(annotation)
        //Fim Ponto
        //Ponto
        let annotation1 = MKPointAnnotation()
        let location1:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661978 , -9.207133)
        annotation1.coordinate = location1
        annotation1.title =  ""
        annotation1.subtitle = "Contentores"
        map.addAnnotation(annotation1)
        ContainerPoint.insert(annotation1)
        //Fim Ponto
        //Ponto
        let annotation3 = MKPointAnnotation()
        let location3:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661447  , -9.206615)
        annotation3.coordinate = location3
        annotation3.title =  ""
        annotation3.subtitle = "Contentores"
        map.addAnnotation(annotation3)
        ContainerPoint.insert(annotation3)
        //Fim Ponto
        //Ponto
        let annotation4 = MKPointAnnotation()
        let location4:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.66196 , -9.205482)
        annotation4.coordinate = location4
        annotation4.title =  ""
        annotation4.subtitle = "Contentores"
        map.addAnnotation(annotation4)
        ContainerPoint.insert(annotation4)
        //Fim Ponto
        //Ponto
        let annotation5 = MKPointAnnotation()
        let location5:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 38.661901, -9.204865 )
        annotation5.coordinate = location5
        annotation5.title =  ""
        annotation5.subtitle = "Contentores"
        map.addAnnotation(annotation5)
        ContainerPoint.insert(annotation5)
        //Fim Ponto
        //Ponto
        let annotation6 = MKPointAnnotation()
        let location6:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661894 , -9.204522)
        annotation6.coordinate = location6
        annotation6.title =  ""
        annotation6.subtitle = "Contentores"
        map.addAnnotation(annotation6)
        ContainerPoint.insert(annotation6)
        //Fim Ponto
        //Ponto
        let annotation7 = MKPointAnnotation()
        let location7:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 38.660423, -9.204666 )
        annotation7.coordinate = location7
        annotation7.title =  ""
        annotation7.subtitle = "Contentores"
        map.addAnnotation(annotation7)
        ContainerPoint.insert(annotation7)
        //Fim Ponto
        //Ponto
        let annotation8 = MKPointAnnotation()
        let location8:CLLocationCoordinate2D = CLLocationCoordinate2DMake(  38.659691, -9.203315 )
        annotation8.coordinate = location8
        annotation8.title =  ""
        annotation8.subtitle = "Contentores"
        map.addAnnotation(annotation8)
        ContainerPoint.insert(annotation8)
        //Fim Ponto
        //Ponto
        let annotation9 = MKPointAnnotation()
        let location9:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 38.660602, -9.206335 )
        annotation9.coordinate = location9
        annotation9.title =  ""
        annotation9.subtitle = "Contentores"
        map.addAnnotation(annotation9)
        ContainerPoint.insert(annotation9)
        //Fim Ponto
        //Ponto
        let annotation10 = MKPointAnnotation()
        let location10:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 38.660057, -9.20642 )
        annotation10.coordinate = location10
        annotation10.title =  ""
        annotation10.subtitle = "Contentores"
        map.addAnnotation(annotation10)
        ContainerPoint.insert(annotation10)
        //Fim Ponto

        
    }
    //Adiciona os pontos EcoPoint
    func EcoPointInit()  {
        
        //Ponto
        let annotation = MKPointAnnotation()
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.6627, -9.207313)
        annotation.coordinate = location
        annotation.title =  ""
        annotation.subtitle = "Ecopontos"
        map.addAnnotation(annotation)
        EcoPoint.insert(annotation)
        //Fim Ponto
        
        //Ponto
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate  = CLLocationCoordinate2DMake(38.661447, -9.206615)
        annotation1.title =  ""
        annotation1.subtitle = "Ecopontos"
        map.addAnnotation(annotation1)
        EcoPoint.insert(annotation1)
        //Fim Ponto
        
        //Ponto
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate  = CLLocationCoordinate2DMake(38.660423, -9.204666)
        annotation2.title =  ""
        annotation2.subtitle = "Ecopontos"
        map.addAnnotation(annotation2)
        EcoPoint.insert(annotation2)
        //Fim Ponto
        
        
        //Ponto
        let annotation3 = MKPointAnnotation()
        annotation3.coordinate  = CLLocationCoordinate2DMake(38.661895, -9.204598)
        annotation3.coordinate = location
        annotation3.title =  ""
        annotation3.subtitle = "Ecopontos"
        map.addAnnotation(annotation3)
        EcoPoint.insert(annotation3)
        //Fim Ponto
        
        //Ponto
        let annotation4 = MKPointAnnotation()
        annotation4.coordinate  = CLLocationCoordinate2DMake(38.660599, -9.206441)
        annotation4.coordinate = location
        annotation4.title =  ""
        annotation4.subtitle = "Ecopontos"
        map.addAnnotation(annotation4)
        EcoPoint.insert(annotation4)
        //Fim Ponto

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    

}

