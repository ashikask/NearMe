//
//  PlaceService.swift
//  GoogleMapWeatherApp
//
//  Created by ashika kalmady on 18/08/17.
//  Copyright © 2017 ashika kalmady. All rights reserved.
//

import Foundation
import Alamofire

class PlaceService {
    
    //https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670,151.1957&radius=500&name=cruise&key=AIzaSyArfSccvFD4ryF7-YA7-P2tvMFDi_jx9jU
    
    let gplaceApiKey : String
    let gplaceBaseURL : URL
    
    init(APIKey : String) {
        self.gplaceApiKey = APIKey
        gplaceBaseURL = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch")!
    }
    
    //function with completion handler which returns the array of places results
    
    func getNearbyPlaces(latitude : Double, longitude: Double, range : Int, searchKey: String, completion: @escaping ([Results]?) -> Void){
        
        //set the url with lat,long, search key and range and form the url
        if let placeURL = URL(string: "\(gplaceBaseURL)/json?location=\(latitude),\(longitude)&radius=\(range)&name=\(searchKey)&key=\(self.gplaceApiKey)"){
            //call api reuest with alamofire
            Alamofire.request(placeURL).responseJSON(completionHandler: { (response) in
                
                //parse the json response
                if let jsonDictionary = response.result.value as? [String : Any] {
                    
                    //map te result set with Reaults model which returns array of data
                   let placeDictionary = Results.modelsFromDictionaryArray(array: jsonDictionary["results"] as! NSArray)
                   
                   if placeDictionary.count > 0 {
                        completion(placeDictionary)
                    } else {
                        completion(nil)
                    }
                }
            })

            
            
        }
        
    }
    
    
}
