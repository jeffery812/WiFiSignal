//
//  ViewController.swift
//  wifi-rssi
//
//  Created by Zhihui Tang on 2018-01-03.
//  Copyright © 2018 Zhihui Tang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getWiFiNumberOfActiveBars() -> Int? {
        let app = UIApplication.shared
        var numberOfActiveBars: Int?
        let exception = tryBlock {
            guard let containerBar = app.value(forKey: "statusBar") as? UIView else { return }
            guard let statusBarMorden = NSClassFromString("UIStatusBar_Modern"), containerBar .isKind(of: statusBarMorden), let statusBar = containerBar.value(forKey: "statusBar") as? UIView else { return }
            
            guard let foregroundView = statusBar.value(forKey: "foregroundView") as? UIView else { return }
            
            for view in foregroundView.subviews {
                for v in view.subviews {
                    if let statusBarWifiSignalView = NSClassFromString("_UIStatusBarWifiSignalView"), v .isKind(of: statusBarWifiSignalView) {
                        if let val = v.value(forKey: "numberOfActiveBars") as? Int {
                            numberOfActiveBars = val
                            break
                        }
                    }
                }
                if let _ = numberOfActiveBars {
                    break
                }
            }
        }
        if let exception = exception {
            print("getWiFiNumberOfActiveBars exception: \(exception)")
        }

        return numberOfActiveBars
    }
    
    private func getWiFiRSSI() -> Int? {
        let app = UIApplication.shared
        var rssi: Int?
        let exception = tryBlock {
            guard let statusBar = app.value(forKey: "statusBar") as? UIView else { return }
            if let statusBarMorden = NSClassFromString("UIStatusBar_Modern"), statusBar .isKind(of: statusBarMorden) { return }
            
            guard let foregroundView = statusBar.value(forKey: "foregroundView") as? UIView else { return  }
            
            for view in foregroundView.subviews {
                if let statusBarDataNetworkItemView = NSClassFromString("UIStatusBarDataNetworkItemView"), view .isKind(of: statusBarDataNetworkItemView) {
                    if let val = view.value(forKey: "wifiStrengthRaw3") as? Int {
                        rssi = val
                        break
                    }
                }
            }
        }
        if let exception = exception {
            print("getWiFiRSSI exception: \(exception)")
        }
        return rssi
    }
    
    @IBAction func refresh(_ sender: UIButton) {
        if let numberOfBars = getWiFiNumberOfActiveBars() {
            label.text = "WiFi number of bars: \(numberOfBars)"
        } else if let rssi = getWiFiRSSI() {
            label.text = "WiFi RSSI: \(rssi)"
        }
        //let a = getSignalStrength()
    }
    
    /*
    private func operatorName() -> String? {
        
        var name: String?
        let app = UIApplication.shared
        guard let statusBar = app.value(forKey: "statusBar") as? UIView, let foregroundView = statusBar.value(forKey: "foregroundView") as? UIView else {
            return name
        }
        
        for view in foregroundView.subviews {
            if let statusBarServiceItemView = NSClassFromString("UIStatusBarServiceItemView"), view .isKind(of: statusBarServiceItemView) {
                if let val = view.value(forKey: "serviceString") as? String {
                    print("servaceName: \(val)")
                    name = val
                    break
                }
            }
        }
        
        return name
        
    }
     
    func getSignalStrength() -> Int {
        let application = UIApplication.shared
        let statusBarView = application.value(forKey: "statusBar") as! UIView
        let foregroundView = statusBarView.value(forKey: "foregroundView") as! UIView
        let foregroundViewSubviews = foregroundView.subviews
        
        var dataNetworkItemView:UIView!
        
        for subview in foregroundViewSubviews {
            if subview.isKind(of: NSClassFromString("UIStatusBarSignalStrengthItemView")!) {
                dataNetworkItemView = subview
                print("NONE")
                break
            } else {
                print("NONE")
                
                return 0 //NO SERVICE
            }
        }
        let wifi = dataNetworkItemView.value(forKey: "serviceString") as? Int
        let mobile = dataNetworkItemView.value(forKey: "signalStrengthBars") as? Int
        print("wifi: \(wifi!), mobile: \(mobile!)")
        
        return dataNetworkItemView.value(forKey: "signalStrengthBars") as! Int
    }
     */
    
}

