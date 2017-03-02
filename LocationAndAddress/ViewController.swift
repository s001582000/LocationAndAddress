//
//  ViewController.swift
//  LocationAndAddress
//
//  Created by 梁雅軒 on 2017/3/2.
//  Copyright © 2017年 zoaks. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController,MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.addressToLocation(address: "台灣")
    }
    
    
    @IBAction func btnOnClick(_ sender: UIButton) {
        self.addressToLocation(address: sender.currentTitle!)
    }
    
    func addressToLocation(address:String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (arrPlacemark, error) in
            if let placemarks = arrPlacemark{
                let placemark = placemarks.first
                let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                let region = MKCoordinateRegion(center: placemark!.location!.coordinate, span: span)
                self.mapView.region = region
            }else{
                print(error!)
            }
        }
    }
    
    func locationToAddress(location:CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (arrPlacemark, error) in
            if let placemarks = arrPlacemark{
                let placemark = placemarks.first!
                
                print("name=\(placemark.name)\n")
                print("thoroughfare=\(placemark.thoroughfare)\n")
                print("subThoroughfare=\(placemark.subThoroughfare)\n")
                print("locality=\(placemark.locality)\n")
                print("subLocality=\(placemark.subLocality)\n")
                print("administrativeArea=\(placemark.administrativeArea)\n")
                print("subAdministrativeArea=\(placemark.subAdministrativeArea)\n")
                print("postalCode=\(placemark.postalCode)\n")
                print("isoCountryCode=\(placemark.isoCountryCode)\n")
                print("country=\(placemark.country)\n")
                print("inlandWater=\(placemark.inlandWater)\n")
                print("ocean=\(placemark.ocean)\n")
                print("areasOfInterest=\(placemark.areasOfInterest)\n")
                var address = ""
                if let ocean = placemark.ocean{
                    address.append(ocean)
                }
                if let subAdministrativeArea = placemark.subAdministrativeArea{
                    address.append(subAdministrativeArea)
                }
                if let locality = placemark.locality{
                    address.append(locality)
                }
                if let name = placemark.name{
                    address.append(name)
                }
                self.mapView.removeAnnotations(self.mapView.annotations)
                let ann:MKPointAnnotation = MKPointAnnotation();
                ann.coordinate = location.coordinate
                ann.title = address;
                self.mapView.addAnnotation(ann)
                self.mapView.selectAnnotation(ann, animated: false)
                
            }else{
                print(error!)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchPoint = touch.location(in: mapView)
            
            let location = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            self.locationToAddress(location: CLLocation(latitude: location.latitude, longitude: location.longitude))
        }
    }
}
