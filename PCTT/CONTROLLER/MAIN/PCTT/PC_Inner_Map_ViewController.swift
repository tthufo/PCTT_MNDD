//
//  PC_Inner_Map_ViewController.swift
//  PCTT
//
//  Created by Thanh Hai Tran on 11/11/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

import UIKit

import WebKit

class PC_Inner_Map_ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var webView: WKWebView!
    
    var category: NSString!
    
    var directUrl: NSString!
    
    @IBOutlet var headerImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var lat = "0"
               
        var lng = "0"

        if (Permission.shareInstance()?.isLocationEnable())! {
            let location = Permission.shareInstance()?.currentLocation()! as! NSDictionary
           
            lat = location.getValueFromKey("lat")
           
            lng = location.getValueFromKey("lng")
        }
        
        let url = category == nil ? directUrl as String : category != "vnmap" ? "http://vndms.dmc.gov.vn/?cmd=category&values=%@&lat=%@&lng=%@&isAuth=1".format(parameters: category, lat, lng ) : "http://vndms.dmc.gov.vn/?cmd=%@&values=%@&lat=%@&lng=%@&isAuth=1".format(parameters: "setmap", category, lat, lng )
        print(url)

        print("-->", url);
        
        let link = URL(string: url)!
        let request = URLRequest(url: link)
        webView.load(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        swipeToPop()
    }

    func swipeToPop() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
    }
}
