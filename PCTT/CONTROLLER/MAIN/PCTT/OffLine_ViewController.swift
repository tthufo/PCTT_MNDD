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
        
        tableView.withCell("PC_Event_Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            let data = dataList![indexPath.row] as! NSDictionary
            self.requestDeleteEvent(id: data.getValueFromKey("id"))
            self.dataList.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"PC_Event_Cell", for: indexPath)
        
//        let data = dataList![indexPath.row] as! NSDictionary
//
//        
//        let image = self.withView(cell, tag: 11) as! UIImageView
//
//        image.image = UIImage(named: "event")
//        
//        let title = self.withView(cell, tag: 1) as! UILabel
//        
//        title.text = data["event_name"] as? String
//        
//        let des = self.withView(cell, tag: 2) as! UILabel
//        
//        des.text = data["event_description"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = dataList![indexPath.row] as! NSDictionary

        let eventInfo = PC_Event_Info_ViewController.init()
        
        eventInfo.eventInfo = data
        
        self.navigationController?.pushViewController(eventInfo, animated: true)
    }
}
