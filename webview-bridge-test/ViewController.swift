//
//  ViewController.swift
//  webview-bridge-test
//
//  Created by Ismail El-habbash on 2019/2/19.
//  Copyright © 2019 Ismail El-habbash. All rights reserved.
//

import UIKit
import WebKit
import WebViewJavascriptBridge

class ViewController: UIViewController {
    var wkWebView: WKWebView = WKWebView.init()

    lazy var bridge: WebViewJavascriptBridge = {
        let bridge = WebViewJavascriptBridge(forWebView: wkWebView)
        bridge?.setWebViewDelegate(wkWebView)
        return bridge!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // sets up webview
        view.backgroundColor = .black
//        let rootVC = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!
        var frame = view.bounds
        frame.size.height /= 2
        frame.origin.y += frame.size.height
        wkWebView = WKWebView.init(frame: frame)
        view.addSubview(wkWebView)
        
        basicHandler()
        ismailHandler()
        echoHandler()
        callHandlerAndRecieveResponse()
        handleJSButtonTap()
        
        //keep this at the end
        loadWebView()
    }
    

    
    @IBAction func tapMeBarButtonTapped(_ sender: Any) {
        tapMeButtonHandler()
    }
    
    func handleJSButtonTap() {
        bridge.registerHandler("jsButtonTapped") { (data, cb) in
            guard let data = data as? [String: String] , let segueId = data["segue"], let title = data["title"] else { return }
            
            self.performSegue(withIdentifier: segueId, sender: title)
        }
    }
    
    func tapMeButtonHandler() {
        bridge.callHandler("tap-me-button-tapped", data: nil) { (jsResponse) in
            guard
            let segueId = jsResponse as? String else { return }
            
            self.performSegue(withIdentifier: segueId, sender: self)
        }
        
//        loadWebView()
    }
    
    func basicHandler() {
        bridge.registerHandler("Greet") { (data, responseCallback) in
            print("this is the greet handler")
            print("recieved data = \(data!)")
        }
    }
    
    func ismailHandler() {
        bridge.registerHandler("ismail-test") { (data, responseCallback) in
            print("recieved data = \(data!)")
        }
    }
    
    func echoHandler() {
        bridge.callHandler("echoHandler", data: "ISMAIL ARE YOU THERE?") { (response) in
            print("echo handler response == \(response!)")
        }
    }
    
    func loadWebView() {
        let request = URLRequest(url: Bundle.main.url(forResource: "echo", withExtension: "html")!)
        wkWebView.load(request)
    }
    
    func callHandlerAndRecieveResponse() {
        bridge.callHandler("jsRcvResponseTest", data: "anything") { (jsResponse) in
            print("callHandlerAndRecieveResponse() - js response ------- \(jsResponse!)")
            
        }
        
        bridge.registerHandler("objcEchoToJs", handler: { (data, respCallback) in
            respCallback!(["foo": "bar"])
        })
    }
}

extension ViewController {
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        switch identifier {
        case "toVC1":
            print()
            
            let vc = ViewController()
            vc.title = "toVC1"
            vc.view.backgroundColor = .green
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "toVC2":
            let vc = ViewController()
            vc.title = "toVC2"
            vc.view.backgroundColor = .blue
            self.navigationController?.pushViewController(vc, animated: true)
        case "toVC3":
            let vc = ViewController()
            vc.view.backgroundColor = .purple
            vc.title = "toVC3"
            self.navigationController?.pushViewController(vc, animated: true)
        case "toVC4":
            let vc = ViewController()
            vc.view.backgroundColor = .magenta
            vc.title = sender as? String ?? "toVC4"
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("NONE")
        }
    }
}

