

import UIKit
import MapKit
import JJFloatingActionButton

class FirstViewController: UIViewController {

  
    @IBOutlet weak var map: MKMapView!
    var EcoPoint: Set<MKPointAnnotation> = []
    var ContainerPoint: Set<MKPointAnnotation> = []
    var TrashPoint: Set<MKPointAnnotation> = []
    let actionButton = JJFloatingActionButton()
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
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
        
        //My buddy's location
        let myBuddysLocation = CLLocation(latitude: loc2.coordinate.latitude, longitude: loc2.coordinate.longitude)
        
        //Measuring my distance to my buddy's (in km)
        return myLocation.distance(from: myBuddysLocation) / 1000

    }
    
    func setMap(point:MKPointAnnotation){
        let span:MKCoordinateSpan = MKCoordinateSpanMake( 0.0008 , 0.0008)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(point.coordinate.latitude,  point.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
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
                let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000)
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
        
        actionButton.addItem(title: "Equipa", image: UIImage(named: "recycle")?.withRenderingMode(.alwaysTemplate)) { item in
            
            self.getClosestTrash()

            
            
        }
        
        actionButton.addItem(title: "Equipa", image: UIImage(named: "ecoamarelo")?.withRenderingMode(.alwaysTemplate)) { item in
            self.getClosestEcoPoint()
            
        }
        
        actionButton.addItem(title: "Equipa", image: UIImage(named: "lixo")?.withRenderingMode(.alwaysTemplate)) { item in
            self.getClosestContainer()
        }
        
        
        actionButton.addItem(title: "Scan", image: UIImage(named: "qrcode")?.withRenderingMode(.alwaysTemplate)) { item in
            DispatchQueue.main.async {
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "qrreader")
                self.present(newViewController, animated: true, completion: nil)
                
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
        
        if(  UserDefaults.standard.string(forKey: "EMAIL")  == nil ){
            DispatchQueue.main.async(){
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "NavLogin")
                self.present(newViewController, animated: false, completion: nil)
            }
        }
            
        else{
            
            super.viewDidLoad()
            let span:MKCoordinateSpan = MKCoordinateSpanMake( 0.008 , 0.008)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661307,  -9.207192)
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            map.setRegion(region, animated: true)
            
            EcoPointInit()
            ContainersInit()
            TrashInit()
            print(EcoPoint)
            print(TrashPoint)
            print(ContainerPoint)
            //}
        }
    }

    //Adiciona o lixo
    func TrashInit(){
        //Ponto
        let annotation1 = MKPointAnnotation()
        let location1:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661050, -9.205007)
        annotation1.coordinate = location1
        annotation1.title =  ""
        annotation1.subtitle = "Algo"
        map.addAnnotation(annotation1)
        TrashPoint.insert(annotation1)
        //Fim Ponto
        //Ponto
        let annotation2 = MKPointAnnotation()
        let location2:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.662693, -9.2064)
        annotation2.coordinate = location2
        annotation2.title =  ""
        annotation2.subtitle = "Algo"
        map.addAnnotation(annotation2)
        TrashPoint.insert(annotation2)
        //Fim Ponto
        //Ponto
        let annotation3 = MKPointAnnotation()
        let location3:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.662728, -9.206014)
        annotation3.coordinate = location3
        annotation3.title =  ""
        annotation3.subtitle = "Algo"
        map.addAnnotation(annotation3)
        TrashPoint.insert(annotation3)
        //Fim Ponto
        //Ponto
        let annotation4 = MKPointAnnotation()
        let location4:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.663517, -9.206063)
        annotation4.coordinate = location4
        annotation4.title =  ""
        annotation4.subtitle = "Algo"
        map.addAnnotation(annotation4)
        TrashPoint.insert(annotation4)
        //Fim Ponto
        //Ponto
        let annotation5 = MKPointAnnotation()
        let location5:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.66306, -9.207816)
        annotation5.coordinate = location5
        annotation5.title =  ""
        annotation5.subtitle = "Algo"
        map.addAnnotation(annotation5)
        TrashPoint.insert(annotation5)
        //Fim Ponto
        //Ponto
        let annotation6 = MKPointAnnotation()
        let location6:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.662853, -9.207483)
        annotation6.coordinate = location6
        annotation6.title =  ""
        annotation6.subtitle = "Algo"
        map.addAnnotation(annotation6)
        TrashPoint.insert(annotation6)
        //Fim Ponto
        //Ponto
        let annotation7 = MKPointAnnotation()
        let location7:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.6627, -9.207313)
        annotation7.coordinate = location7
        annotation7.title =  ""
        annotation7.subtitle = "Algo"
        map.addAnnotation(annotation7)
        TrashPoint.insert(annotation7)
        //Fim Ponto
        //Ponto
        let annotation8 = MKPointAnnotation()
        let location8:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.662474, -9.207367)
        annotation8.coordinate = location8
        annotation8.title =  ""
        annotation8.subtitle = "Algo"
        map.addAnnotation(annotation8)
        TrashPoint.insert(annotation8)
        //Fim Ponto
        //Ponto
        let annotation9 = MKPointAnnotation()
        let location9:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.662703, -9.207032)
        annotation9.coordinate = location9
        annotation9.title =  ""
        annotation9.subtitle = "Algo"
        map.addAnnotation(annotation9)
        TrashPoint.insert(annotation9)
        //Fim Ponto
        //Ponto
        let annotation10 = MKPointAnnotation()
        let location10:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.6627, -9.206707)
        annotation10.coordinate = location10
        annotation10.title =  ""
        annotation10.subtitle = "Algo"
        map.addAnnotation(annotation10)
        TrashPoint.insert(annotation10)
        //Fim Ponto
        //Ponto
        let annotation11 = MKPointAnnotation()
        let location11:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.662065, -9.207374)
        annotation11.coordinate = location11
        annotation11.title =  ""
        annotation11.subtitle = "Algo"
        map.addAnnotation(annotation11)
        TrashPoint.insert(annotation11)
        //Fim Ponto
        //Ponto
        let annotation12 = MKPointAnnotation()
        let location12:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661818, -9.206189)
        annotation12.coordinate = location12
        annotation12.title =  ""
        annotation12.subtitle = "Algo"
        map.addAnnotation(annotation12)
        TrashPoint.insert(annotation12)
        //Fim Ponto
    }
    //Adiciona container
    func ContainersInit(){
        //Ponto
        let annotation = MKPointAnnotation()
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.6627 , -9.207313)
        annotation.coordinate = location
        annotation.title =  ""
        annotation.subtitle = "Algo"
        map.addAnnotation(annotation)
        ContainerPoint.insert(annotation)
        //Fim Ponto
        //Ponto
        let annotation1 = MKPointAnnotation()
        let location1:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661978 , -9.207133)
        annotation1.coordinate = location1
        annotation1.title =  ""
        annotation1.subtitle = "Algo"
        map.addAnnotation(annotation1)
        ContainerPoint.insert(annotation1)
        //Fim Ponto
        //Ponto
        let annotation3 = MKPointAnnotation()
        let location3:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661447  , -9.206615)
        annotation3.coordinate = location3
        annotation3.title =  ""
        annotation3.subtitle = "Algo"
        map.addAnnotation(annotation3)
        ContainerPoint.insert(annotation3)
        //Fim Ponto
        //Ponto
        let annotation4 = MKPointAnnotation()
        let location4:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.66196 , -9.205482)
        annotation4.coordinate = location4
        annotation4.title =  ""
        annotation4.subtitle = "Algo"
        map.addAnnotation(annotation4)
        ContainerPoint.insert(annotation4)
        //Fim Ponto
        //Ponto
        let annotation5 = MKPointAnnotation()
        let location5:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 38.661901, -9.204865 )
        annotation5.coordinate = location5
        annotation5.title =  ""
        annotation5.subtitle = "Algo"
        map.addAnnotation(annotation5)
        ContainerPoint.insert(annotation5)
        //Fim Ponto
        //Ponto
        let annotation6 = MKPointAnnotation()
        let location6:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661894 , -9.204522)
        annotation6.coordinate = location6
        annotation6.title =  ""
        annotation6.subtitle = "Algo"
        map.addAnnotation(annotation6)
        ContainerPoint.insert(annotation6)
        //Fim Ponto
        //Ponto
        let annotation7 = MKPointAnnotation()
        let location7:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 38.660423, -9.204666 )
        annotation7.coordinate = location7
        annotation7.title =  ""
        annotation7.subtitle = "Algo"
        map.addAnnotation(annotation7)
        ContainerPoint.insert(annotation7)
        //Fim Ponto
        //Ponto
        let annotation8 = MKPointAnnotation()
        let location8:CLLocationCoordinate2D = CLLocationCoordinate2DMake(  38.659691, -9.203315 )
        annotation8.coordinate = location8
        annotation8.title =  ""
        annotation8.subtitle = "Algo"
        map.addAnnotation(annotation8)
        ContainerPoint.insert(annotation8)
        //Fim Ponto
        //Ponto
        let annotation9 = MKPointAnnotation()
        let location9:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 38.660602, -9.206335 )
        annotation9.coordinate = location9
        annotation9.title =  ""
        annotation9.subtitle = "Algo"
        map.addAnnotation(annotation9)
        ContainerPoint.insert(annotation9)
        //Fim Ponto
        //Ponto
        let annotation10 = MKPointAnnotation()
        let location10:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 38.660057, -9.20642 )
        annotation10.coordinate = location10
        annotation10.title =  ""
        annotation10.subtitle = "Algo"
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
        annotation.subtitle = "Algo"
        map.addAnnotation(annotation)
        EcoPoint.insert(annotation)
        //Fim Ponto
        
        //Ponto
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate  = CLLocationCoordinate2DMake(38.661447, -9.206615)
        annotation1.title =  ""
        annotation1.subtitle = "Algo"
        map.addAnnotation(annotation1)
        EcoPoint.insert(annotation1)
        //Fim Ponto
        
        //Ponto
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate  = CLLocationCoordinate2DMake(38.660423, -9.204666)
        annotation2.title =  ""
        annotation2.subtitle = "Algo"
        map.addAnnotation(annotation2)
        EcoPoint.insert(annotation2)
        //Fim Ponto
        
        
        //Ponto
        let annotation3 = MKPointAnnotation()
        annotation3.coordinate  = CLLocationCoordinate2DMake(38.661895, -9.204598)
        annotation3.coordinate = location
        annotation3.title =  ""
        annotation3.subtitle = "Algo"
        map.addAnnotation(annotation3)
        EcoPoint.insert(annotation3)
        //Fim Ponto
        
        //Ponto
        let annotation4 = MKPointAnnotation()
        annotation4.coordinate  = CLLocationCoordinate2DMake(38.660599, -9.206441)
        annotation4.coordinate = location
        annotation4.title =  ""
        annotation4.subtitle = "Algo"
        map.addAnnotation(annotation4)
        EcoPoint.insert(annotation4)
        //Fim Ponto
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    

}

