//
//  TG_Intro_ViewController.swift
//  PCTT
//
//  Created by Thanh Hai Tran on 11/4/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

import UIKit

import MarqueeLabel

import WebKit

class TG_Intro_ViewController: UIViewController {

    @IBOutlet var bg: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var bottom: MarqueeLabel!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var back: UIButton!

    @IBOutlet var gap: NSLayoutConstraint!

    var dataList: NSMutableArray!
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet var webView: WKWebView!

    var isIntro: Bool = true
    
    @IBOutlet var headerImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Information.check == "0" {
            headerImg.image = UIImage(named: "bg_text_dms")
        }
        
         if #available(iOS 10.0, *) {
           tableView.refreshControl = refreshControl
        } else {
           tableView.addSubview(refreshControl)
        }
           
        refreshControl.tintColor = UIColor.black
        
        refreshControl.addTarget(self, action: #selector(didRequestNotification), for: .valueChanged)
           
        gap.constant = isIntro ? 0 : 44
        
        dataList = NSMutableArray.init()
        
//        if let path : String = Bundle.main.path(forResource: "notification_test_data", ofType: "json") {
//            if let data = NSData(contentsOfFile: path) {
//
//                let json = data.objectFromJSONData() as! NSDictionary
//
//
//                let noti = (json["data"] as! NSArray).withMutable()
//
//                for var not in noti! {
////                    for var station in (not as! NSMutableDictionary)["list_station"] as! NSArray {
//                        (not as! NSMutableDictionary)["open"] = "0"
////                    }
//                }
//
//                dataList.addObjects(from: noti!)
//            }
//        }
        
        bg.image = UIImage(named: "intro_bg")
        
        tableView.withCell("Province_Cell")
        
        tableView.withCell("Province1")

        tableView.withHeaderOrFooter("PC_Header_Tab")
        
        if isIntro {
            let link = URL(string:"http://eladmin.gisgo.vn/?cmd=intro")!
            let request = URLRequest(url: link)
            webView.load(request)
        }
        
        webView.isHidden = !isIntro

        back.isHidden = isIntro
        
        titleLabel.isHidden = isIntro
        
        didRequestNotification()
    }
    
    @objc func didRequestNotification() {
        LTRequest.sharedInstance()?.didRequestInfo(["absoluteLink":"".urlGet(postFix: "notification"),
                                                    "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                    "method":"GET",
                                                    "overrideAlert":"1",
                                                    "overrideLoading":"1",
                                                    "host":self], withCache: { (cacheString) in
        }, andCompletion: { (response, errorCode, error, isValid, object) in
            let result = response?.dictionize() ?? [:]
                                                         
            self.refreshControl.endRefreshing()
            
            if (error != nil) || result.getValueFromKey("status") != "OK" {
                self.showToast(response?.dictionize().getValueFromKey("data") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("data"), andPos: 0)
                return
            }
                    
            self.dataList.removeAllObjects()
            
            let noti = (result["data"] as! NSArray).withMutable()
            
            for not in noti! {
                (not as! NSMutableDictionary)["open"] = "0"
            }
            
            self.dataList.addObjects(from: noti!)

            self.tableView.reloadData()
        })
    }
    
    func didRequestFAQ() {
        LTRequest.sharedInstance()?.didRequestInfo(["absoluteLink":"".urlGet(postFix: "faq"),
                                                    "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                    "method":"GET",
                                                    "overrideAlert":"1",
                                                    "overrideLoading":"1",
                                                    "host":self], withCache: { (cacheString) in
        }, andCompletion: { (response, errorCode, error, isValid, object) in
            let result = response?.dictionize() ?? [:]
                                                         
            if (error != nil) || result.getValueFromKey("status") != "OK" {
                self.showToast(response?.dictionize().getValueFromKey("data") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("data"), andPos: 0)
                return
            }
                    
            self.dataList.addObjects(from: response?.dictionize()["data"] as! [Any])
                        
            self.tableView.reloadData()
        })
    }
    
    @IBAction func didPressBack() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressFAQ() {
       let question = PC_FeedBack_New_ViewController.init()
               
       question.inner = false
       
       self.navigationController?.pushViewController(question, animated: true)
    }
}

extension TG_Intro_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50//-1//CGFloat(self.screenWidth() * 9 / 16)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let head = Bundle.main.loadNibNamed("PC_Header_Tab", owner: nil, options: nil)![0] as! UIView
                
        let sec = (dataList[section] as! NSMutableDictionary);
        
        (self.withView(head, tag: 11) as! UILabel).text = sec.getValueFromKey("title")
        
        (self.withView(head, tag: 12) as! UIButton).action(forTouch: [:]) { (obj) in
            sec["open"] = sec.getValueFromKey("open") == "0" ? "1" : "0"
            tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
        }
        
        head.action(forTouch: [:]) { (obj) in
            sec["open"] = sec.getValueFromKey("open") == "0" ? "1" : "0"
            tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
        }
        
        let angle = sec.getValueFromKey("open") == "0" ? 0 : CGFloat.pi
        
        (self.withView(head, tag: 12) as! UIButton).transform = CGAffineTransform(rotationAngle: angle)
        
        return head
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = (dataList[section] as! NSDictionary);
        
        return section.getValueFromKey("open") == "0" ? 0 : (section["data"] as! NSArray).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let data = ((dataList![indexPath.section] as! NSDictionary)["data"] as! NSArray)[indexPath.row] as! NSDictionary
        
        let cell = tableView.dequeueReusableCell(withIdentifier: data.getValueFromKey("xuthe") == "0" ? "Province_Cell" : "Province1", for: indexPath)
         
         let name = self.withView(cell, tag: 11) as! UILabel
                        
         name.text = data.getValueFromKey("vi_tri")
         
         
         let desc = self.withView(cell, tag: 12) as! UILabel
                        
         desc.text = data.getValueFromKey("vitri_de") + " " + data.getValueFromKey("ten_tuyen_de_tw")
         
         
         let value = self.withView(cell, tag: 14) as! UILabel
                               
        value.text = data.getValueFromKey("mucnuoc_hientai") + "m"
        
        
        let time = self.withView(cell, tag: 15) as! UILabel
                       
        time.text = data.getValueFromKey("thoigian_capnhat")
         
         
         let icon = self.withView(cell, tag: 16) as! UIImageView
         
         icon.isHidden = data.getValueFromKey("xuthe") == "0"
         
         icon.heightConstaint!.constant = data.getValueFromKey("xuthe") == "0" ? 0 : 27
                              
         
         let red = self.withView(cell, tag: 1000) as! UIView

        red.alpha = data.getValueFromKey("cap_baodong") != "0" ? 0.7 : 0
         
        
//         if data.getValueFromKey("cap_baodong") != "0" {
//
//             let bd = self.withView(cell, tag: 17) as! UILabel
//
//             bd.text = "Trên BD" + data.getValueFromKey("cap_baodong")
//
//
////             let mm = self.withView(cell, tag: 18) as! UILabel
//         }
        
        if data.getValueFromKey("cap_baodong") != "" {
            if data.getValueFromKey("cap_baodong") != "0" {
                let bd = self.withView(cell, tag: 17) as! UILabel

                bd.text = "Trên BĐ" + data.getValueFromKey("cap_baodong")
                
                let mm = self.withView(cell, tag: 18) as! UILabel
                
                mm.text = data.getValueFromKey("vuotmuc_baodong") + "m"
            } else {
                if data.getValueFromKey("mucbaodong") != "" && data.getValueFromKey("mucnuoc_hientai") != "" {
                    let bd = self.withView(cell, tag: 17) as! UILabel

                    bd.text = "Dưới BĐ" + "1"
                    
                    let mm = self.withView(cell, tag: 18) as! UILabel
                    
                    let alert:Double? = Double(data.getValueFromKey("mucbaodong") ?? "0")

                    let present:Double? = Double(data.getValueFromKey("mucnuoc_hientai") ?? "0")

                    mm.text = String(format: "%.2f", alert! - present!)  + "m"
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        let data = ((dataList![indexPath.section] as! NSDictionary)["data"] as! NSArray)[indexPath.row] as! NSDictionary

        var lat = "21.0077147"
               
        var lng = "105.832827"

        if (Permission.shareInstance()?.isLocationEnable())! {
            let location = Permission.shareInstance()?.currentLocation()! as! NSDictionary
           
            lat = location.getValueFromKey("lat")
           
            lng = location.getValueFromKey("lng")
        }
        
        let web = PC_Inner_Map_ViewController.init()

        web.directUrl = "http://eladmin.gisgo.vn/?cmd=station&id_kttv=%@&id_vitrimucnuoc=%@&x=@&y=%@&lat=%@&lng=%@".format(parameters: data.getValueFromKey("tram_kttv_id"), data.getValueFromKey("id"), data.getValueFromKey("kinh_do"), data.getValueFromKey("vi_do"), lat, lng ) as NSString
        
        self.navigationController?.pushViewController(web, animated: true)
    }
}


//http://eladmin.gisgo.vn/?cmd=station&id_kttv=246&id_vitrimucnuoc=0&x=105.42376053813&y=21.28904891265&lat=21.0077147&lng=105.832827
