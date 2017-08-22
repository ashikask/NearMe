//
//  Weather.swift
//  GoogleMapWeatherApp
//
//  Created by ashika kalmady on 18/08/17.
//  Copyright © 2017 ashika kalmady. All rights reserved.
//

import Foundation

class Weather
{
    let temperature: Double?
    let summary: String?
    let icon: String?
    
    //parameters keys created as structure
    struct WeatherKeys {
        static let temperature = "temperature"
        static let summary = "summary"
        static let icon = "icon"
    }
    
    //parse teh required data
    init(weatherDictionary: [String : Any])
    {
        //convert celsius to farengheit
        if let temperatureValue = weatherDictionary[WeatherKeys.temperature] as? Double {
            temperature = ceil((temperatureValue * 1.8) + 32 )
        }
        else{
            temperature = nil
        }
        
        summary = weatherDictionary[WeatherKeys.summary] as? String
        //all the icons are set in assets as per the name required
        icon = weatherDictionary[WeatherKeys.icon] as? String
        
    }
}
