

import UIKit
import MapKit

class FirstViewController: UIViewController {

  
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake( 0.005 , 0.005)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.661307,  -9.207192)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Ponto 1"
        annotation.subtitle = "Algo"
        map.addAnnotation(annotation)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

