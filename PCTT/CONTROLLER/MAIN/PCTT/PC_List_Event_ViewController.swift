//
//  PC_List_Event_ViewController.swift
//  PCTT
//
//  Created by Thanh Hai Tran on 11/18/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

import UIKit

class PC_List_Event_ViewController: UIViewController {

     @IBOutlet var tableView: UITableView!
        
    @IBOutlet var menu: UIButton!
    
    @IBOutlet var cover: UIButton!
    
    @IBOutlet var menuBottom: UIButton!
    
    @IBOutlet var menu1: UIButton!
    
    @IBOutlet var menu2: UIButton!
    
    @IBOutlet var menu3: UIButton!
    
    @IBOutlet var menu4: UIButton!
    
    @IBOutlet var alert1: UILabel!
    
    @IBOutlet var alert2: UILabel!
    
    @IBOutlet var alert3: UILabel!
    
    @IBOutlet var alert4: UILabel!

    
    var isShow: Bool = false
    
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
        
        dataList = NSMutableArray.init()
        
        tableView.withCell("PC_Event_Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.requestEvent()
        
        cover.action(forTouch: [:]) { (obj) in
         self.didPressBottomMenu(self.menuBottom!)
        }
        
        alert1.action(forTouch: [:]) { (obj) in
         self.didPressOption(self.alert1!)
        }
        alert2.action(forTouch: [:]) { (obj) in
         self.didPressOption(self.alert2!)
        }
        alert3.action(forTouch: [:]) { (obj) in
         self.didPressOption(self.alert3!)
        }
        alert4.action(forTouch: [:]) { (obj) in
         self.didPressOption(self.alert4!)
        }
    }
    
//    func requestDeleteEvent(id: String) {
//      LTRequest.sharedInstance()?.didRequestInfo(["absoluteLink":"".urlGet(postFix: "event/delete/" + id),
//                                                  "header":["Authorization":Information.token == nil ? "" : Information.token!],
//                                                  "method":"GET",
//                                                  "overrideAlert":"1",
//                                                  "overrideLoading":"1",
//                                                  "host":self], withCache: { (cacheString) in
//      }, andCompletion: { (response, errorCode, error, isValid, object) in
//          let result = response?.dictionize() ?? [:]
//
//          if result.getValueFromKey("status") != "OK" {
//              self.showToast(response?.dictionize().getValueFromKey("data") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("data"), andPos: 0)
//              return
//          }
//
//          self.requestEvent()
//      })
//   }
       
       @IBAction func didPressBottomMenu(_ sender: Any) {
           UIView.animate(withDuration: 0.3) {
               self.menu1.alpha = !self.isShow ? 1 : 0
               self.menu2.alpha = !self.isShow ? 1 : 0
               self.menu3.alpha = !self.isShow ? 1 : 0
               self.menu4.alpha = !self.isShow ? 1 : 0

               self.alert1.alpha = !self.isShow ? 1 : 0
               self.alert2.alpha = !self.isShow ? 1 : 0
               self.alert3.alpha = !self.isShow ? 1 : 0
               self.alert4.alpha = !self.isShow ? 1 : 0

               self.cover.alpha = !self.isShow ? 0.1 : 0
               (sender as! UIButton).setImage(UIImage(named: !self.isShow ? "xxxx" : "menu"), for: .normal)
           }
           isShow = !isShow
       }
       
       @IBAction func didPressOption(_ sender: Any) {
           switch (sender as! UIView).tag {
           case 1:
            self.requestEvent()
               break
           case 2:
            self.navigationController?.pushViewController(PC_Upload_ViewController.init(), animated: true)
               break
           case 3:
            let map = AP_Map_ViewController.init()
            map.dataListPoints = self.dataList
            self.navigationController?.pushViewController(map, animated: true)
               break
            case 4:
            let offLine = OffLine_ViewController.init()
            self.navigationController?.pushViewController(offLine, animated: true)
               break
           default:
               break
           }
                   
        self.didPressBottomMenu(self.menuBottom!)
       }
    
    func requestEvent() {
      LTRequest.sharedInstance()?.didRequestInfo(["absoluteLink":"".urlGet(postFix: "event"),
                                                  "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                  "method":"GET",
                                                  "overrideAlert":"1",
                                                  "overrideLoading":"1",
                                                  "host":self], withCache: { (cacheString) in
      }, andCompletion: { (response, errorCode, error, isValid, object) in
          let result = response?.dictionize() ?? [:]
                                                 
          if result.getValueFromKey("status") != "OK" {
              self.showToast(response?.dictionize().getValueFromKey("data") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("data"), andPos: 0)
              return
          }
          
          self.dataList.removeAllObjects()
        
          self.dataList.addObjects(from: Information.offLine as! [Any])

          self.dataList.addObjects(from: response?.dictionize()["data"] as! [Any])
          
          self.tableView.reloadData()
                
        if self.dataList.count == 0 {
            self.showToast("Không có dữ liệu. Mời bạn thử lại sau", andPos: 0)
        }
      })
    }
    
    @IBAction func didPressFAQ() {
    }
    
    func requestDeleteEvent(id: String) {
       LTRequest.sharedInstance()?.didRequestInfo(["absoluteLink":"".urlGet(postFix: "event/delete/" + id),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "overrideAlert":"1",
                                                   "overrideLoading":"1",
                                                   "host":self], withCache: { (cacheString) in
       }, andCompletion: { (response, errorCode, error, isValid, object) in
           let result = response?.dictionize() ?? [:]
                                          
           if result.getValueFromKey("status") != "OK" {
               self.showToast(response?.dictionize().getValueFromKey("data") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("data"), andPos: 0)
               return
           }
          
            self.tableView.reloadData()

            self.showToast("Xoá thành công", andPos: 0)
        })
    }
    
    func didPressSubmit(data: NSDictionary) {
        self.showSVHUD("", andOption: 0)
     LTRequest.sharedInstance()?.didRequestMultiPart(["CMD_CODE":"event/",
                                                    "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                    "data": data["data"] as Any,
                                                    "field": data["field"] as Any,
                                                    "overrideAlert":"1",
                                                    "overrideLoading":"1",
                                                    "postFix":"event/",
                                                    "host":self], withCache: { (cacheString) in
        }, andCompletion: { (response, errorCode, error, isValid, object) in
            let result = response?.dictionize() ?? [:]
            self.hideSVHUD()

            if result.getValueFromKey("status") != "OK" {
                self.showToast(response?.dictionize().getValueFromKey("data") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("data"), andPos: 0)
                return
            }

            self.showToast("Cập nhật thông tin thành công", andPos: 0)

            let id = data.getValueFromKey("id")
//            self.dataList.removeAllObjects()
            Information.removeOffline(order: id!)
            self.requestEvent()
//            self.dataList.addObjects(from: Information.offLine as! [Any])
//            self.tableView.reloadData()
        })
    }
    
    @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
}


extension PC_List_Event_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Xóa"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let data = dataList![indexPath.row] as! NSDictionary

        let isOffline = data.response(forKey: "data")
        
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            if isOffline {
                let id = (dataList![indexPath.row] as! NSDictionary)["id"]
                Information.removeOffline(order: id as! String)
                self.dataList.removeObject(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadData()
            } else {
                self.requestDeleteEvent(id: data.getValueFromKey("id"))
                self.dataList.removeObject(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"PC_Event_Cell", for: indexPath)
        
        let data = dataList![indexPath.row] as! NSDictionary

        let isOffline = data.response(forKey: "data")
        
        let image = self.withView(cell, tag: 11) as! UIImageView
        
        image.image = UIImage(named: "check_blue")
        
        image.isHidden = isOffline ? true : false

        let title = self.withView(cell, tag: 1) as! UILabel
        
        title.text = isOffline ? (data["data"] as! NSDictionary).getValueFromKey("event_name") : data["event_name"] as? String
        
        let des = self.withView(cell, tag: 2) as! UILabel
        
        des.text = isOffline ? (data["data"] as! NSDictionary).getValueFromKey("event_description") : data["event_description"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = dataList![indexPath.row] as! NSDictionary

        let isOffline = data.response(forKey: "data")

        if isOffline {
            DropAlert.shareInstance()?.alert(withInfor: ["title":"Đồng bộ dữ liệu", "message": "Bạn có muốn đồng bộ sự kiện " + ((data["data"] as! NSDictionary)["event_name"] as! String) , "buttons": ["Cập nhật"], "cancel":"Để sau"], andCompletion: { (index, obj) in
                if index == 0 {
                    self.didPressSubmit(data: data)
                }
            })
        } else {
            let eventInfo = PC_Event_Info_ViewController.init()
            
            eventInfo.eventInfo = data
            
            self.navigationController?.pushViewController(eventInfo, animated: true)
        }
    }
}
