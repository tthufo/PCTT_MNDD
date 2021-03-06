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
    
    var timer: Timer!
    
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
        
        let link = URL(string: url)!
        let request = URLRequest(url: link)
        webView.load(request)
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { timer in
            self.updating()
        }
        
        let backButton = UIButton.init(type: .custom)
           backButton.setImage(UIImage.init(named: "icon_back"), for: .normal)
           backButton.frame = CGRect.init(x: 5, y: 10, width: 44, height: 44)
//           if directUrl == "" {
               webView.addSubview(backButton)
//           }
           backButton.action(forTouch: [:]) { (objc) in
               self.navigationController?.popViewController(animated: true)
           }
    }
    
    func updating() {
        var lat = "0"
                       
        var lng = "0"

        if (Permission.shareInstance()?.isLocationEnable())! {
            let location = Permission.shareInstance()?.currentLocation()! as! NSDictionary
           
            lat = location.getValueFromKey("lat")
           
            lng = location.getValueFromKey("lng")
        }
        LTRequest.sharedInstance()?.didRequestInfo(["CMD_CODE":"auth/locate/",
                                                          "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                          "longtitude": lng,
                                                          "latitude": lat,
                                                          "overrideAlert":"1",
                                                          "overrideLoading":"1",
                                                          "postFix":"auth/locate/",
                                                          "host":self], withCache: { (cacheString) in
              }, andCompletion: { (response, errorCode, error, isValid, object) in
                  
              })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        swipeToPop()
    }

    func swipeToPop() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if (timer != nil) {
            timer.invalidate()
            timer  = nil
        }
    }
}
