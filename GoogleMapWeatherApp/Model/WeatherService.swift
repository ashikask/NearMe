//
//  WeatherService.swift
//  GoogleMapWeatherApp
//
//  Created by ashika kalmady on 18/08/17.
//  Copyright © 2017 ashika kalmady. All rights reserved.
//

import Foundation
import Alamofire

class WeatherService {


    let weatherBaseURL : URL
    //initialize service with api key
    init(APIKey: String ) {
    
        weatherBaseURL = URL(string: "https://api.darksky.net/forecast/\(APIKey)")!
    }
    
    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Weather?) ->Void ) {
        //set the url with lat and long and form the url
        if let weatherURL = URL(string: "\(weatherBaseURL)/\(latitude),\(longitude)") {
            
            //call the api reuest
            Alamofire.request(weatherURL).responseJSON(completionHandler: { (response) in
                
                //parse the json response as key value pair
                if let jsonDictionary = response.result.value as? [String : Any] {
                    //query the reqired parameter
                    if let currentWeatherDictionary = jsonDictionary["currently"] as? [String : Any] {
                        //map with weather model
                        let currentWeather = Weather(weatherDictionary: currentWeatherDictionary)
                        completion(currentWeather)
                    } else {
                        completion(nil)
                    }
                }

                
                
            })
            
        }

        
    }
}
