//
//  PC_List_Event_ViewController.swift
//  PCTT
//
//  Created by Thanh Hai Tran on 11/18/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

import UIKit

class OffLine_ViewController: UIViewController {

     @IBOutlet var tableView: UITableView!
            
    var dataList: NSMutableArray!

      @IBOutlet var headerImg: UIImageView!

      override func viewDidLoad() {
          super.viewDidLoad()
          
          if Information.check == "0" {
              headerImg.image = UIImage(named: "bg_text_dms")
          }
        
        dataList = NSMutableArray.init()
        
        dataList.addObjects(from: Information.offLine as! [Any])
        
        print(dataList)
        
        tableView.withCell("PC_Event_Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func didPressSubmit(object: NSDictionary) {
        
        print(object)
//           let array = NSMutableArray.init()
//
//           for dict in dataList {
//               let d = dict as! NSDictionary
//               array.add(["file": d["file"] , "fileName": d["fileName"], "key":"ds"])
//           }
//
//           var lat = "0"
//
//           var lng = "0"
//
//           if (Permission.shareInstance()?.isLocationEnable())! {
//               let location = Permission.shareInstance()?.currentLocation()! as! NSDictionary
//
//               lat = location.getValueFromKey("lat")
//
//               lng = location.getValueFromKey("lng")
//           }
              
//        let id = object.getValueFromKey("id")
//        print(id)
//           Information.removeOffline(order: id as! String)
//           self.dataList.removeAllObjects()
//           self.dataList.addObjects(from: Information.offLine as! [Any])
//           self.tableView.reloadData()
                
        LTRequest.sharedInstance()?.didRequestMultiPart(["CMD_CODE":"event/",
                                                       "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                       "data": object["data"],
                                                       "field": object["field"],
                                                       "overrideAlert":"1",
                                                       "overrideLoading":"1",
                                                       "postFix":"event/",
                                                       "host":self], withCache: { (cacheString) in
           }, andCompletion: { (response, errorCode, error, isValid, object) in
               let result = response?.dictionize() ?? [:]

               if result.getValueFromKey("status") != "OK" {
                   self.showToast(response?.dictionize().getValueFromKey("data") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("data"), andPos: 0)
                   return
               }

               self.showToast("Cập nhật thông tin thành công", andPos: 0)

//                let id = object!["id"]
//                Information.removeOffline(order: id as! String)
//                self.dataList.removeAllObjects()
//                self.dataList.addObjects(from: Information.offLine as! [Any])
//                self.tableView.reloadData()
           })
       }
    
    @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
}


extension OffLine_ViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            let id = (dataList![indexPath.row] as! NSDictionary)["id"]
            Information.removeOffline(order: id as! String)
            self.dataList.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"PC_Event_Cell", for: indexPath)
        
        let data = (dataList![indexPath.row] as! NSDictionary)["data"] as! NSDictionary


        let image = self.withView(cell, tag: 11) as! UIImageView

        image.image = UIImage(named: "event")

        let title = self.withView(cell, tag: 1) as! UILabel

        title.text = data["event_name"] as? String

        let des = self.withView(cell, tag: 2) as! UILabel

        des.text = data["event_description"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let data = (dataList![indexPath.row] as! NSDictionary)

        self.didPressSubmit(object: data)
    }
}
