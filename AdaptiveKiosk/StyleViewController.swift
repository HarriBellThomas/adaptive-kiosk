//
//  StyleViewController.swift
//  AdaptiveKiosk
//
//  Created by Carlos Purves on 06/03/2018.
//  Copyright © 2018 Carlos Purves. All rights reserved.
//

import Cocoa
import WebKit

class StyleViewController: NSViewController, WKNavigationDelegate{
    
    @IBOutlet weak var mainStylePage: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainStylePage.load(URLRequest(url: URL(string: "https://cp.md/adaptive/KIOSK/ops.html?")!))
        mainStylePage.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let url = webView.url!.absoluteString
        if url.contains("https://cp.md/adaptive/KIOSK/GO/?"){
            let id = url.replacingOccurrences(of: "https://cp.md/adaptive/KIOSK/GO/?", with: "")
            print("Set id to \(id)")
            let nc = NotificationCenter.default
            nc.post(name:Notification.Name(rawValue:"goReloadWithID"),
                    object: nil,
                    userInfo: ["id":id])
            self.dismiss(nil)
        }
    }

    
}
