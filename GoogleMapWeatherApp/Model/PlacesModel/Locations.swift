//
//  LocationM.swift
//  GoogleMapWeatherApp
//
//  Created by ashika kalmady on 18/08/17.
//  Copyright © 2017 ashika kalmady. All rights reserved.
//

import Foundation


class Locations {
    public var lat : Double?
    public var lng : Double?
   
    public class func modelsFromDictionaryArray(array:NSArray) -> [Locations]
    {
        var models:[Locations] = []
        for item in array
        {
            models.append(Locations(dictionary: item as! [String:Any])!)
        }
        return models
    }
    
   
    required public init?(dictionary: [String:Any]) {
        
        lat = dictionary["lat"] as? Double
        lng = dictionary["lng"] as? Double
    }
    
    
}
