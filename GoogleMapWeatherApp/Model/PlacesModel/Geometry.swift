//
//  Geometrys.swift
//  GoogleMapWeatherApp
//
//  Created by ashika kalmady on 18/08/17.
//  Copyright © 2017 ashika kalmady. All rights reserved.
//

import Foundation

class Geometry {
    
    public var location : Locations?
   
    //parse array of geometry data
    public class func modelsFromDictionaryArray(array:NSArray) -> [Geometry]
    {
        var models:[Geometry] = []
        for item in array
        {
            models.append(Geometry(dictionary: item as! [String:Any])!)
        }
        return models
    }
    
    //parsing the result set as dictionary key pair value
    required public init?(dictionary: [String:Any]) {
        
        if (dictionary["location"] != nil) { location = Locations(dictionary: dictionary["location"] as! [String:Any]) }
      
    }
    
    
    
}
