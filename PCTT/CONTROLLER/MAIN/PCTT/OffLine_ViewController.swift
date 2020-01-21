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
        
        dataList.addObjects(from: Information.offLine as! [Any])
                
        tableView.withCell("PC_Event_Cell")
        
        if dataList.count == 0 {
            self.showToast("Chưa có dữ liệu", andPos: 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func didPressSubmit(data: NSDictionary) {
                
        LTRequest.sharedInstance()?.didRequestMultiPart(["CMD_CODE":"event/",
                                                       "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                       "data": data["data"],
                                                       "field": data["field"],
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

               let id = data.getValueFromKey("id")
               self.dataList.removeAllObjects()
               Information.removeOffline(order: id!)
               self.dataList.addObjects(from: Information.offLine as! [Any])
               self.tableView.reloadData()
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

        self.didPressSubmit(data: data)
    }
}
