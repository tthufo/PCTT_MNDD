//
//  PC_Info_ViewController.swift
//  PCTT
//
//  Created by Thanh Hai Tran on 8/4/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

import UIKit

import MarqueeLabel

class PC_Info_ViewController: UIViewController {
    
    @IBOutlet var bg: UIImageView!
        
    @IBOutlet var bottom: MarqueeLabel!
    
    @IBOutlet var tableView: UITableView!
    
    var dataList: NSMutableArray!

  @IBOutlet var headerImg: UIImageView!

    @IBOutlet var logoLeft: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Information.check != "0" {
            logoLeft.image = UIImage(named: "logo_tc")
        }
      
      if Information.check == "0" {
          headerImg.image = UIImage(named: "bg_text_dms")
      }
        
        dataList = NSMutableArray.init(array: [["title":"Thông tin tài khoản", "image":"user_info"],
                                               ["title":"Đổi mật khẩu", "image":"change_pass"],
//                                               ["title":"Đóng góp ý tưởng", "image":"contribution"],
                                               ["title":"Cho phép nhận thông báo", "image":"notification"],
                                               ["title":"Đăng xuất", "image":"logout"]
                                              ])
    
    dataList = NSMutableArray.init(array: [
                                        //        ["title":"Thông tin tài khoản", "image":"user_info"],
                                                   ["title":"Đổi mật khẩu", "image":"change_pass"],
                                                   ["title":"Cho phép nhận thông báo", "image":"notification", "content":"sw"],
                                                   ["title":"Đăng xuất", "image":"logout"]
                                                  ])
        
        tableView.withCell("PC_Info_Cell")
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
//        bottom.text = "Gisco Ver %@".format(parameters: appVersion!)
    }
    
    @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didPressLogout() {
//        LTRequest.sharedInstance()?.didRequestInfo(["CMD_CODE":"logout",
//                                                    "user_id":Information.userInfo?.getValueFromKey("user_id") ?? "",
//                                                    "device_id":FirePush.shareInstance()?.deviceToken() ?? "",
//                                                    "overrideAlert":"1",
//                                                    "host":self], withCache: { (cacheString) in
//        }, andCompletion: { (response, errorCode, error, isValid, object) in
//            let result = response?.dictionize() ?? [:]
//            if result.getValueFromKey("ERR_CODE") != "0" {
//                self.showToast(response?.dictionize().getValueFromKey("ERR_MSG"), andPos: 0)
//                return
//            }
//
            Information.removeInfo()

            self.navigationController?.popToRootViewController(animated: true)
//        })
    }
    
    func postNotification(ids: NSArray) {
        LTRequest.sharedInstance()?.didRequestInfo(["absoluteLink":"".urlGet(postFix: "notification/subcribe"),
                                                                          "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                                          "ids": ids,
                                                                          "overrideAlert":"1",
                                                                          "overrideLoading":"1",
                                                                          "host":self], withCache: { (cacheString) in
                              }, andCompletion: { (response, errorCode, error, isValid, object) in
                                  let result = response?.dictionize() ?? [:]
                               
                                  if result.getValueFromKey("status") != "OK" {
                                      self.showToast(response?.dictionize().getValueFromKey("data") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("data"), andPos: 0)
                                      return
                                  }
                                                                  
                                self.showToast("Cập nhật thông báo thành công", andPos: 0)
                                              
                              })
    }
    
    func didRequestNotification() {
        LTRequest.sharedInstance()?.didRequestInfo(["absoluteLink":"".urlGet(postFix: "subcribe"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "is_subcribe": self.getValue("push") == "1" ? false : true ,
                                                   "overrideAlert":"1",
                                                   "overrideLoading":"1",
                                                   "host":self], withCache: { (cacheString) in
       }, andCompletion: { (response, errorCode, error, isValid, object) in
           let result = response?.dictionize() ?? [:]
                                
           if result.getValueFromKey("status") != "OK" {
               self.showToast(response?.dictionize().getValueFromKey("data") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("data"), andPos: 0)
               return
           }
        
        self.showToast("Cài đặt thành công", andPos: 0)
           
       })
    }
}

extension PC_Info_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"PC_Info_Cell", for: indexPath)
        
        let data = dataList![indexPath.row] as! NSDictionary

        
        let image = self.withView(cell, tag: 11) as! UIImageView

        image.image = UIImage(named: data.getValueFromKey("image"))
        
        let title = self.withView(cell, tag: 1) as! UILabel
        
        title.text = data["title"] as? String
        
        
        let sw = self.withView(cell, tag: 3) as! UISwitch
        
        sw.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        sw.isOn = self.getValue("push") == "1" //&& self.checkForNotification()
        
//        sw.isEnabled = self.checkForNotification()
        
        sw.action(forTouch: [:]) { (obj) in
//            if self.getValue("push") == "1" {
////                FirePush.shareInstance()?.didUnregisterNotification()
//            } else {
////                FirePush.shareInstance()?.reRegisterNotification()
//            }
            self.didRequestNotification()
            self.addValue(self.getValue("push") == "1" ? "0" : "1", andKey: "push")
            sw.isOn = self.getValue("push") == "1"
        }
        
        sw.alpha = data["content"] as? String == "sw" ? 1 : 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        if Information.check == nil {
//            if indexPath.row == 0 {
//                self.navigationController?.pushViewController(PC_Inner_Info_ViewController.init(), animated: true)
//            }
//
            if indexPath.row == 0 {
                self.navigationController?.pushViewController(PC_ChangePass_ViewController.init(), animated: true)
            }
            
            if indexPath.row == 1 {
                self.didRequestNotification()

//                LTRequest.sharedInstance()?.didRequestInfo(["absoluteLink":"".urlGet(postFix: "subcribe"),
//                                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
//                                                                   "is_subcribe": self.getValue("push") == "1" ? false : true ,
//                                                                   "overrideAlert":"1",
//                                                                   "overrideLoading":"1",
//                                                                   "host":self], withCache: { (cacheString) in
//                       }, andCompletion: { (response, errorCode, error, isValid, object) in
//                           let result = response?.dictionize() ?? [:]
//
//                           if result.getValueFromKey("status") != "OK" {
//                               self.showToast(response?.dictionize().getValueFromKey("data") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("data"), andPos: 0)
//                               return
//                           }
//
//
//
//                        //                let cell = tableView.cellForRow(at: indexPath)
//                        //                if self.getValue("push") == "1" {
//                        //                    FirePush.shareInstance()?.didUnregisterNotification()
//                        //                } else {
//                        //                    FirePush.shareInstance()?.reRegisterNotification()
//                        //                }
//                        //                self.addValue(self.getValue("push") == "1" ? "0" : "1", andKey: "push")
//                        //                let sw = self.withView(cell, tag: 3) as! UISwitch
//                        //                sw.isOn = self.getValue("push") == "1"
//
//
////                            let data = (response?.dictionize()["data"] as! NSArray).withMutable()
////
////                            EM_MenuView.init(notification: ["data": data as Any]).show { (indexing, obj, menu) in
////                                let array = NSMutableArray.init()
////                                let ids = obj as! NSDictionary
////                                if indexing == 100 {
////                                    for ob in ids["data"] as! NSArray {
////                                        if (ob as! NSDictionary).getValueFromKey("subscribed") == "1" {
////                                            array.add((ob as! NSDictionary).getValueFromKey("id") as Any)
////                                        }
////                                    }
////                                    if array.count != 0 {
////                                        self.postNotification(ids: array)
////                                    }
////
////                                    menu?.close()
////                                }
////                            }
//
//                       })
//                if !self.checkForNotification() {
//                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
//                    return
//                }
//                
                let cell = tableView.cellForRow(at: indexPath)
//                if self.getValue("push") == "1" {
//                    FirePush.shareInstance()?.didUnregisterNotification()
//                } else {
//                    FirePush.shareInstance()?.reRegisterNotification()
//                }
                self.addValue(self.getValue("push") == "1" ? "0" : "1", andKey: "push")
                let sw = self.withView(cell, tag: 3) as! UISwitch
                sw.isOn = self.getValue("push") == "1"
            }
            
            if indexPath.row == 2 {
                self.didPressLogout()
            }
//        } else {
//            if indexPath.row == 1 {
//                
//                if !self.checkForNotification() {
//                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
//                    return
//                }
//                
//                let cell = tableView.cellForRow(at: indexPath)
//                if self.getValue("push") == "1" {
////                    FirePush.shareInstance()?.didUnregisterNotification()
//                } else {
////                    FirePush.shareInstance()?.reRegisterNotification()
//                }
//                self.addValue(self.getValue("push") == "1" ? "0" : "1", andKey: "push")
//                let sw = self.withView(cell, tag: 3) as! UISwitch
//                sw.isOn = self.getValue("push") == "1"
//            }
//            
//            if indexPath.row == 2 {
//                self.navigationController?.pushViewController(PC_FeedBack_ViewController.init(), animated: true)
//            }
//        }
    }
}
