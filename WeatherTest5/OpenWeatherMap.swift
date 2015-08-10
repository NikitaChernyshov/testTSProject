//
//  OpenWeatherMap.swift
//  WeatherTest4
//
//  Created by Nikita C on 30.07.15.
//  Copyright (c) 2015 TrustSourcing. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation


protocol OpenWeatherMapDelegate {
    
    func updateWeatherInfo(weatherJson: AnyObject)
    func failure()
}

class OpenWeatherMap {
    
    var nameCity: String?
    
    let weatherUrl = "http://weatheritapiv2.ds.trustsourcing.com/GetData"
    
    var delegate: OpenWeatherMapDelegate!
    

    func weatherFor(geo: CLLocationCoordinate2D) {
        let params = ["lat" : geo.latitude, "lon" : geo.longitude]
        setRequest(params)
    }
    
    func setRequest(params: [String: AnyObject]?) {
        request(Method.GET, weatherUrl, parameters: params).responseJSON { (req, res, json, error) -> Void in
            
            if (error != nil) {
                
                self.delegate.failure()
                
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.delegate.updateWeatherInfo(json!)
                })
            }
        }
    }
    func timeFromUnix(unixTime: Int) -> String {
        
        let timeInSecond = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSecond)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d MMMM y HH:mm"
        
        return dateFormatter.stringFromDate(weatherDate)
    }
    
}



extension Double {
    func toC() -> Double {
        return (round(self - 273.15))
    }
    
    var C: Double {
        return (round((self - 32) * 5 / 9))
    }
}