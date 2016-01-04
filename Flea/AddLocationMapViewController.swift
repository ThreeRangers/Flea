//
//  AddLocationMapViewController.swift
//  Flea
//
//  Created by Sinh Quyen Ngo on 1/1/16.
//  Copyright © 2016 ThreeStrangers. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

@objc protocol AddLocationMapViewControllerDelegate {
    optional func updateLocation(addLocationViewController: AddLocationMapViewController, locationMark: Dictionary<String,String>, location: CLLocation)
}

class AddLocationMapViewController: UIViewController, CLLocationManagerDelegate {
    var placeDict = Dictionary<String,String>()
    var currentLocation: CLLocation?
    var loMgr: CLLocationManager!
    var delegate: AddLocationMapViewControllerDelegate?
    @IBOutlet weak var mapview: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loMgr = CLLocationManager()
        loMgr.delegate = self
        loMgr.desiredAccuracy = kCLLocationAccuracyBest
        
        if currentLocation == nil {
            loMgr.requestWhenInUseAuthorization()
            loMgr.startUpdatingLocation()
        }
        else {
//            let latitude = NSString(string: placeDict["latitude"]!).doubleValue
//            let longitude = NSString(string: placeDict["longitude"]!).doubleValue
            let latDelta :CLLocationDegrees = 0.01
            let longDelta :CLLocationDegrees = 0.01
            let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
//            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(currentLocation!.coordinate, span)
            self.mapview.setRegion(region, animated: true)
            
            let anotation = MKPointAnnotation()
            anotation.title = placeDict["name"]
            anotation.coordinate = currentLocation!.coordinate
            self.mapview.addAnnotation(anotation)
            
        }
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 2
        mapview.addGestureRecognizer(uilpgr)    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func action(uilpgr: UILongPressGestureRecognizer) {
        
        if (uilpgr.state == UIGestureRecognizerState.Began) {
            
            let touchPoint = uilpgr.locationInView(self.mapview)
            let touchCoordinate = self.mapview.convertPoint(touchPoint, toCoordinateFromView: self.mapview)
            currentLocation = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(currentLocation!) { (placemarkArr, error) -> Void in
                
                var title = ""
                if (error == nil) {
                    let p = placemarkArr?[0]
                    var subThoroughfare: String = ""
                    var thoroughfare: String = ""
                    if p!.subThoroughfare != nil {
                        subThoroughfare = p!.subThoroughfare!
                    }
                    if p!.thoroughfare != nil {
                        thoroughfare = p!.thoroughfare!
                    }
                    title = "\(thoroughfare) \(subThoroughfare)"
                    print("\(title)")
                    if title == " " {
                        title = "Added\(NSDate())"
                    }
                    
                    self.placeDict = ["name":title, "latitude":"\(touchCoordinate.latitude)", "longitude":"\(touchCoordinate.longitude)"]
//                    
//                    NSUserDefaults.standardUserDefaults().setObject(placeDict, forKey: "MemoryPlaces")
                    
                    self.delegate?.updateLocation!(self, locationMark: self.placeDict, location: self.currentLocation!)
                    let anotation = MKPointAnnotation()
                    anotation.title = "Move Here"
                    anotation.coordinate = touchCoordinate
                    self.mapview.addAnnotation(anotation)
                }
                else {
                    print("\(error)")
                }
                
            }
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userlocation = locations[0]
        let latitude = userlocation.coordinate.latitude
        let longitude = userlocation.coordinate.longitude
        let latDelta :CLLocationDegrees = 0.01
        let longDelta :CLLocationDegrees = 0.01
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.mapview.setRegion(region, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
