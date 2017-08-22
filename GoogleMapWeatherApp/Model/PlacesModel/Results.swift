//
//  ResultsM.swift
//  GoogleMapWeatherApp
//
//  Created by ashika kalmady on 18/08/17.
//  Copyright © 2017 ashika kalmady. All rights reserved.
//

import Foundation

class Results {
    //parameter only needed for application are taken
    public var geometry : Geometry?
    public var icon : String?
    public var name : String?
    public var rating : String?
    public var vicinity: String?
    
    //parsing array of results data
    public class func modelsFromDictionaryArray(array:NSArray) -> [Results]
    {
        var models:[Results] = []
        for item in array
        {
            models.append(Results(dictionary: item as! [String:Any])!)
        }
        return models
    }
    
    //parse the result data as key pair value
    required public init?(dictionary: [String:Any]) {
        
        if (dictionary["geometry"] != nil) { geometry = Geometry(dictionary: dictionary["geometry"] as! [String:Any]) }
        icon = dictionary["icon"] as? String
       
        name = dictionary["name"] as? String
        
        vicinity = dictionary["vicinity"] as? String
        rating = dictionary["rating"] as? String
       
    }

    
    
}
