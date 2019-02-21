//
//  WkWebViewController.swift
//  webview-bridge-test
//
//  Created by Ismail El-habbash on 2019/2/21.
//  Copyright © 2019 Ismail El-habbash. All rights reserved.
//

import UIKit
import WebKit
import CoreLocation

class WkWebViewViewController: UIViewController {
    
    var webView: WKWebView!
    
    let colors = [
        "black", "red", "blue", "green", "purple"
    ]
    
    @IBOutlet weak var webViewContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWkWebView()
       
    }
    
    func setupWkWebView() {
        let contentController = WKUserContentController();
        contentController.add(
            self,
            name: "geocodeAddress"
        )
        
        contentController.add(
            self,
            name: "test"
        )

        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        webView = WKWebView(frame: webViewContainer.bounds, configuration: config)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewContainer.addSubview(webView)
        
        webView.leadingAnchor.constraint(equalTo: webViewContainer.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: webViewContainer.trailingAnchor, constant: 0).isActive = true
        webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor, constant: 0).isActive = true
        
        
        let request = URLRequest(url: Bundle.main.url(forResource: "wkWebViewExample", withExtension: "html")!)
        webView.load(request)
    }
    
    @IBAction func colorChoiceChanged(_ sender: UISegmentedControl) {
        webView.evaluateJavaScript("changeBackgroundColor('\(colors[sender.selectedSegmentIndex])')") { (data, err) in
            print("data === \(data)")
            print("err === \(err)")
        }
    }
    
    // test address using  -> 100 Century Avenue, Pudong, Shanghai, China
    func geocodeAddress(dict: NSDictionary) {
        let geocoder = CLGeocoder()
        let street = dict["street"] as? String ?? ""
        let city = dict["city"] as? String ?? ""
        let state = dict["state"] as? String ?? ""
        let country = dict["country"] as? String ?? ""
        
        let addressString = "\(street), \(city), \(state), \(country)"
        geocoder.geocodeAddressString(addressString, completionHandler: geocodeComplete)
    }
    
    func geocodeComplete(placemarks: [CLPlacemark]?, error: Error?) {
        if let placemarks = placemarks, placemarks.count > 0 {
            let lat = placemarks[0].location?.coordinate.latitude ?? 0.0
            let lon = placemarks[0].location?.coordinate.longitude ?? 0.0
            webView.evaluateJavaScript("setLatLon('\(lat)', '\(lon)')") { (data, err) in
                print("data === \(data)")
                print("err === \(err)")
                
            }
        }
        
    }
}

extension WkWebViewViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "geocodeAddress", let dict = message.body as? NSDictionary {
            geocodeAddress(dict: dict)
        }
        
        if message.name == "test", let dict = message.body as? String {
            print(dict)
        }

    }
}
