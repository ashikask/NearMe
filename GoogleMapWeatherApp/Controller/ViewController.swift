//
//  ViewController.swift
//  GoogleMapWeatherApp
//
//  Created by ashika kalmady on 18/08/17.
//  Copyright © 2017 ashika kalmady. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController , UIPopoverPresentationControllerDelegate{

    //outles
    @IBOutlet weak var gmsMap: GMSMapView!
    @IBOutlet weak var placeTableView: UITableView!
    @IBOutlet weak var segmentControll: UISegmentedControl!
    
    
    var hospitalsArray = [Results]() //holds hospitals result data
    var restaurants = [Results]() //holds restaurants result data
    var splashscreen: UIImageView! //shows splash screen
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //add splash screen set for 5 seconds
        self.splashscreen = UIImageView(frame: self.view.frame)
        self.splashscreen.image = UIImage(named: "Default")
        self.splashscreen.contentMode = .scaleAspectFill
        self.view.addSubview(self.splashscreen)
        
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(removeSP), userInfo: nil, repeats: false)
        
        
        //initialize the segment to 0 to point to hospital data
        self.segmentControll.selectedSegmentIndex = 0
        
        self.gmsMap.delegate = self
        self.setUpLocationManager()
          // Do any additional setup after loading the view, typically from a nib.
    }
    
    //selector method called after 5 seconds to remove the splash added as subview
    func removeSP(){
        
        self.splashscreen.removeFromSuperview()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

    //MARK: Api to retrieve naerby places
    func callSearchPlaceApi(searchKey : String, lat: Double, long : Double){
       
        self.loadingIndicator(true)
        
        let placeService = PlaceService(APIKey: "AIzaSyArfSccvFD4ryF7-YA7-P2tvMFDi_jx9jU")
        //call the service to get the places based on lat lon search key and range specified , this function has completion handler which returns either result st or nil if no data
        placeService.getNearbyPlaces(latitude: lat,longitude: long, range: 10000, searchKey: searchKey) { (result) in
             self.loadingIndicator(false)
            //chevk if result is not nil
            if result != nil {
               
                // do the ui related modification on main thread
                DispatchQueue.main.async {
                    //segment 0 -hospital
                    if self.segmentControll.selectedSegmentIndex == 0{
                        self.hospitalsArray.removeAll()
                    }
                        //segment 1 - restaurant
                    else{
                        self.restaurants.removeAll()
                    }
                    
                    
                    //loop through result set and store in local array
                    for item in result!{
                       
                        self.segmentControll.selectedSegmentIndex == 0 ? self.hospitalsArray.append(item) : self.restaurants.append(item)
                        
                        
                    }
                    
                    
                    self.placeTableView.reloadData()
                    
                }
                
               
             
            }
            else{
                self.placeTableView.reloadData()
            }
            
        }
        
    }
    //MARK: setMarker on map
    func setMarkers(place : Results, index: Int){
        //clear already existing markers
        self.gmsMap.clear()
        var target : CLLocationCoordinate2D!
            
            if let geo = place.geometry?.location{
                //using GMSMarker set title , postion and icon
                let marker = GMSMarker()
                
                target = CLLocationCoordinate2D(latitude: geo.lat!, longitude: geo.lng!)
                marker.position = target
                marker.title = place.name
                
                marker.icon = self.segmentControll.selectedSegmentIndex == 1 ? UIImage(named: "ic_eat_dark_new") : UIImage(named: "ic_live_dark_new")
                
                marker.map = gmsMap
                marker.tracksViewChanges = true
                // uniquely detrmine the index of each marker to fetch from the relative array --hospitalarray[index]
               marker.userData = index

        }
    }
    
    func setUpLocationManager(){
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
    }
    
    //MARK: delegate of popoverpresentation
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .none
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController)
    {
        self.view.alpha = 1
    }
    
    
    @IBAction func segmeChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.callSearchPlaceApi(searchKey: "hospitals", lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude)
            break
        case 1:
             self.callSearchPlaceApi(searchKey: "restaurants", lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude)
            break
        default:
            break
        }
        
    }
    //location around 10km
    func drawCircle(position: CLLocationCoordinate2D) {
        
        let circle = GMSCircle(position: position, radius: 10000)
        circle.strokeColor = UIColor.blue
        circle.fillColor = UIColor(red: 0, green: 0, blue: 0.35, alpha: 0.05)
        circle.map = gmsMap
        
    }
    
}
//MARK: GMSMap delegate
extension ViewController: GMSMapViewDelegate{
    
    //called when user tap on marker icon
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let index: Int = marker.userData as! Int
        
        // show the popoverviewcontroller screen
        guard let popOverViewController = storyboard?.instantiateViewController(withIdentifier: "PopOverViewController") as? PopOverViewController else
        {
            fatalError()
        }
        
        popOverViewController.modalPresentationStyle = .popover
        popOverViewController.delegate = self
        //pass teh related data to presenting screen
        popOverViewController.resultData = self.segmentControll.selectedSegmentIndex == 0 ? hospitalsArray[index] : restaurants[index]
        
        //set up the  popoverPresentationcontroller
        
        let popover : UIPopoverPresentationController = popOverViewController.popoverPresentationController!
        popover.delegate = self
        popover.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popOverViewController.preferredContentSize = CGSize(width: 300, height: 500)
        popover.sourceView = self.view
        popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.view.alpha = 0.5
        present(popOverViewController, animated: true, completion: nil)
        
        return true
        
    }
    
}
//MARK: popOver presented screen delegate
extension ViewController : popOverDelegate{
    
    //called when cross is clicked on popover to reset parent view alpha to 1
    func closePresentedView() {
        self.view.alpha = 1
    }
    
}

//MARK: table view deleagte and datasource
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.segmentControll.selectedSegmentIndex == 0 ? hospitalsArray.count : restaurants.count
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell") as? PlaceTableViewCell else{
            fatalError()
        }
        
        cell.placeName.text = self.segmentControll.selectedSegmentIndex == 0 ? hospitalsArray[indexPath.row].name : restaurants[indexPath.row].name

        cell.address.text = self.segmentControll.selectedSegmentIndex == 0 ? hospitalsArray[indexPath.row].vicinity : restaurants[indexPath.row].vicinity
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let placeSelected = self.segmentControll.selectedSegmentIndex == 0 ? hospitalsArray[indexPath.row] : restaurants[indexPath.row]
        
        self.setMarkers(place: placeSelected , index: indexPath.row)
        
        
    }
    
}

//MARK: locationmanager delagate

extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("error: \(error)")
        
    }
    
    //called each time the location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            // set the camera view position for map
            gmsMap.camera = GMSCameraPosition.camera(withTarget: location.coordinate , zoom: 11)
            self.drawCircle(position: location.coordinate)
            
            
            // call the api to retrieve location nearby restaurant or hospitals if previos and update dlocation are not same as this delegate is called multiple times written this condition
            if currentLocation.coordinate.latitude != location.coordinate.latitude{
            currentLocation = location
            if location.coordinate.latitude != 0 {
                if self.segmentControll.selectedSegmentIndex == 0 //hospital
                {
                     self.callSearchPlaceApi(searchKey: "hospitals", lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude)
                }
                else{ //restaurants
                     self.callSearchPlaceApi(searchKey: "restaurants", lat:  currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude)
                }
                
            
            }
            }
            
          
            
        }
        
    }
    //called if the user changes the authentication
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse{
            
            locationManager.startUpdatingLocation()
            
            gmsMap.isMyLocationEnabled = true
            gmsMap.settings.myLocationButton = true
            
        }
        
    }
    
}
