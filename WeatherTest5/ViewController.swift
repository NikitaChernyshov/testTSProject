//
//  ViewController.swift
//  WeatherTest4
//
//  Created by Nikita C on 29.07.15.
//  Copyright (c) 2015 TrustSourcing. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftLocation

class ViewController: UIViewController,  UITableViewDelegate, OpenWeatherMapDelegate, CLLocationManagerDelegate {
    
    var openWeather = OpenWeatherMap()
    let locationManager: CLLocationManager = CLLocationManager()
    var weatherInfo = WeatherInfo()
    
    var rows = [WeatherInfo]()
    
    var refreshControl : UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func refresh(sender:AnyObject) {
        refreshBegin("Refresh",
            refreshEnd: {(x:Int) -> () in
                self.getLocation()
                self.rows = []
                self.tableView.reloadData()
        })
    }
    
    func refreshBegin(newtext:String, refreshEnd:(Int) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            println("refreshing")
            //self.text = newtext
            sleep(2)
            dispatch_async(dispatch_get_main_queue()) {
                refreshEnd(0)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.openWeather.delegate = self
        //tableView.registerClass(CustomTableViewCell.self, forCellReuseIdentifier: "cellIdent") //Nib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "cellIdent")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func getLocation() {
        SwiftLocation.shared.currentLocation(Accuracy.Neighborhood, timeout: 20, onSuccess: { (location) -> Void in
            // location is a CLPlacemark
            println("Location found \(location?.description)")
            var coord = location!.coordinate
            self.openWeather.weatherFor(coord)
            self.tableView.reloadData()
            }) { (error) -> Void in
                // something went wrong
                println("Something went wrong -> \(error?.localizedDescription)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cellIdent", forIndexPath: indexPath) as! CustomTableViewCell
        //cell.textLabel?.text = rows[indexPath.item].time
        cell.cellText.text = rows[indexPath.item].time
        cell.tempMinLabel.text = "Min: \(rows[indexPath.item].tempMin)"
        cell.tempMaxLabel.text = "Max: \(rows[indexPath.item].tempMax)"
        self.refreshControl.endRefreshing()
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //click on cell
        println(indexPath.item)
        performSegueWithIdentifier("toDetail", sender: indexPath.item)
    }
    
    func updateWeatherInfo(weatherJson: AnyObject) {
        let commonInfo: AnyObject = weatherJson
        let lt = commonInfo["Lt"] as! Double
        let lg = commonInfo["Lg"] as! Double
        let tz = commonInfo["Tz"] as! String
        let os = commonInfo["Os"] as! Double
        println(lt)
        println(lg)
        println(tz)
        println(os)
        
        let dailyList = weatherJson["D"] as! [AnyObject]
        for weather in dailyList {
            
            var time = weather["T"] as! Int
            var timeToStr = openWeather.timeFromUnix(time)
            var weatherData = WeatherInfo()
            weatherData.time = timeToStr
            
            
            var summary = weather["S"] as! String
            weatherData.summary = summary
            
            
            var info = weather["I"] as! String
            weatherData.info = info
            
            var tempMin = weather["TempMin"] as! Double
            weatherData.tempMin = tempMin
            
            var tempMax = weather["TempMax"] as! Double
            weatherData.tempMax = tempMax
            
            var srT = weather["SrT"] as! Int
            weatherData.sunRise = openWeather.timeFromUnix(srT)
            
            var ssT = weather["SsT"] as! Int
            weatherData.sunSet = openWeather.timeFromUnix(ssT)
            
            rows.append(weatherData)
            
        }
        self.tableView.reloadData()
    }
    
    func failure() {
        //No connection internet
        let networkController = UIAlertController(title: "Error", message: "No connection!", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        networkController.addAction(okButton)
        
        self.presentViewController(networkController, animated: true, completion: nil)
    }
    
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
        println("Can't get your location")
        
        let networkController = UIAlertController(title: "Error", message: "Can't get your location", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        networkController.addAction(okButton)
        
        self.presentViewController(networkController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetail" {
            
            let weatherController = segue.destinationViewController as! ViewController2
            let weather = rows[sender as! Int]
            weatherController.weatherInfo = weather
            
        }
    }
}