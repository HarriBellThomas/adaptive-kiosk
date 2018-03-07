//
//  ViewController.swift
//  AdaptiveKiosk
//
//  Created by Carlos Purves on 06/03/2018.
//  Copyright © 2018 Carlos Purves. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate {

    @IBOutlet weak var mainSiteView: WKWebView!
   
    var requiredModules = "onDOMChange,adaptiveBase,adaptiveTools"
    var baseURL = "https://en.wikipedia.org.uk"
    var scriptInject = ""
    var moduleScript = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainSiteView.navigationDelegate = self
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"goReloadWithID"),
                       object:nil, queue:nil,
                       using:catchReload)
        loadViewById(1)
        
    }
    
    func catchReload(notification:Notification) -> Void {
        let userInfo = notification.userInfo!
        let id  = userInfo["id"] as? String
        print("GO:\(Int(id!)!)")
        loadViewById(Int(id!)!)
    }
    
    func loadViewById(_ id:Int){
        let file = "\(NSHomeDirectory())/AdaptiveKiosk/style\(id).js"
        let path=URL(fileURLWithPath: file)
        let text = try! String(contentsOf: path)
        var lines = text.components(separatedBy: .newlines)
        requiredModules = lines[0]
        baseURL = lines[1]
        scriptInject = lines.dropFirst(2).joined(separator: "\n")
        print("Loading url: \(baseURL)")
        
        
        let urlPath: String = "https://cp.md/adaptive/FINAL/src/fresh/?negateglobal=N&mod=\(requiredModules)"
        let url: URL = URL(string: urlPath)!
        let request1: URLRequest = URLRequest(url: url)
        let queue:OperationQueue = .main
        
        NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: URLResponse?, data: Data?, error: Error?) -> Void in
            
            self.moduleScript = String(bytes: data!, encoding: String.Encoding.utf8)!
            print("Code: \(self.moduleScript)")
            self.mainSiteView.load(URLRequest(url: URL(string: self.baseURL)!))
        })
        
            
        
        
    }
    
    
    
    override func viewDidAppear() {
        self.view.window?.title = "The Adaptive Web"
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("ADDING:\(moduleScript)")
        
            print("Loading script...")
            self.mainSiteView.evaluateJavaScript(moduleScript, completionHandler: {(v, e) in
                print("Loaded...")
                if(e==nil){
                    print("Injecting...")
                    print(self.scriptInject)
                    self.mainSiteView.evaluateJavaScript(self.scriptInject)
                }else{
                    print(e?.localizedDescription)
                }
                
            })
        
    }



}

