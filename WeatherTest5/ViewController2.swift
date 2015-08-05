//
//  ViewController2.swift
//  WeatherTest4
//
//  Created by Nikita C on 31.07.15.
//  Copyright (c) 2015 TrustSourcing. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var descrShortLabel: UILabel!
    
    @IBOutlet weak var tempMinLabel: UILabel!
    
    @IBOutlet weak var tempMaxLabel: UILabel!
    
    @IBOutlet weak var sunRTLabel: UILabel!
    
    @IBOutlet weak var sunSTLabel: UILabel!

    var weatherInfo = WeatherInfo()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = weatherInfo.time
        summaryLabel.text = weatherInfo.summary
        descrShortLabel.text = weatherInfo.info
        tempMinLabel.text = "Temp min is: \(weatherInfo.tempMin.C) ℃"
        tempMaxLabel.text = "Temp max is: \(weatherInfo.tempMax.C) ℃"
        sunRTLabel.text = "Sunrise time is: \(weatherInfo.sunRise)"
        sunSTLabel.text = "Sunset time is: \(weatherInfo.sunSet)"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
