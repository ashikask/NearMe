//
//  PopOverViewController.swift
//  GoogleMapWeatherApp
//
//  Created by ashika kalmady on 18/08/17.
//  Copyright © 2017 ashika kalmady. All rights reserved.
//

import UIKit
//protocol used by parent viewcontroller called when this viewcontroller is closed
protocol popOverDelegate : class{
    
    func closePresentedView()
}

class PopOverViewController: UIViewController {

    //outlet
    @IBOutlet weak var templeratureLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var fullAddressLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    
    var resultData : Results! //obtained from parent viewcontroller
    let weatherAPIKey = "33c371344898311931ea3058dcc4730f"
    
    weak var delegate : popOverDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //set the tuplet for lat long from the result set got from previous screen
        let coordinate: (lat: Double, long: Double) = ((resultData.geometry?.location?.lat)! ,(resultData.geometry?.location?.lng)!)
        
        self.TitleLabel.text = resultData.name
        self.fullAddressLabel.text = resultData.vicinity
        
       
        
        //make call to weather api to retrive the tempurature of current lat long
        let weatherService = WeatherService(APIKey: weatherAPIKey)
        weatherService.getCurrentWeather(latitude: coordinate.lat, longitude: coordinate.long) { (result) in
            
            // show the result in main queue
            if let currentWeather = result {
                
                DispatchQueue.main.async {
                    
                   
                    if let temperature = currentWeather.temperature {
                        self.templeratureLabel.text = "\(temperature)° F"
                    }
                    else{
                        self.templeratureLabel.text = "-"
                    }
                    
                    
                    self.imageLabel.image = UIImage(named: currentWeather.icon!)
                    
                }
            }
            
            
            
            
        }
        
        

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        self.delegate.closePresentedView()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
