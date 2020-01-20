//
//  PC_Province_ViewController.swift
//  PCTT
//
//  Created by Thanh Hai Tran on 12/13/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

import UIKit

import MarqueeLabel

class PC_Province_ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 70
        }
    }
    
    @IBOutlet var bg: UIImageView!
    
    @IBOutlet var blurView: UIView!
    
    @IBOutlet var cover: UIView!
    
    @IBOutlet var time: MarqueeLabel!
    
    @IBOutlet var titleLabel: MarqueeLabel!
        
    @IBOutlet var notification: UIButton!
    
    @IBOutlet var menu: DropButton!

    @IBOutlet var arrow: UIImageView!
    
    @IBOutlet var search: UITextField!

    var dataList: NSMutableArray!
    
    var tempList: NSMutableArray!
    
    var sortList: NSMutableArray!
    
    var sortList1: NSMutableArray!
    
    var filterList: NSMutableArray!

    var kb: KeyBoard!
    
    let refreshControl = UIRefreshControl()
    
    var sortValue: String = "1"
    
    var filterValue: String = "1"
    
    @IBOutlet var sortWidth: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataList = NSMutableArray.init()
        tempList = NSMutableArray.init()
        
        sortList = NSMutableArray.init()
        sortList1 = NSMutableArray.init()
        filterList = NSMutableArray.init()
        
        let list: NSArray = [
            ["description":"Sắp xếp giảm dần theo cấp báo động", "subscribed": 1, "value": "1"], ["description":"Sắp xếp tăng dần theo cấp báo động", "subscribed": 0, "value": "2"],
             ["description":"Sắp xếp theo tên tram", "subscribed": 0, "value": "3"],
                ["description":"Sắp xếp theo thứ tự từ Bắc xuống Nam", "subscribed": 0, "value": "4"],
            ["description":"Sắp xếp theo tên sông", "subscribed": 0, "value": "5"],
        ]
        
        sortList.addObjects(from: list.withMutable())
        
        let list2: NSArray = [
            ["description":"Sắp xếp giảm dần theo cấp báo động", "subscribed": 1, "value": "1"], ["description":"Sắp xếp tăng dần theo cấp báo động", "subscribed": 0, "value": "2"],
                ["description":"Sắp xếp theo thứ tự từ Bắc xuống Nam", "subscribed": 0, "value": "4"],
            ["description":"Sắp xếp theo tên tỉnh", "subscribed": 0, "value": "6"],

        ]
        
        sortList1.addObjects(from: list2.withMutable())
        
        
        
        let list1: NSArray = [["description":"Theo trạm", "subscribed": 1, "value": "1"],
                             ["description":"Theo tỉnh", "subscribed": 0, "value": "2"],
                ["description":"Theo lưu vực", "subscribed": 0, "value": "3"],
                ["description":"Các trạm gần đây", "subscribed": 0, "value": "4"],
        ]
        
        filterList.addObjects(from: list1.withMutable())
        
        kb = KeyBoard.shareInstance()
        
        tableView.withCell("Province_Cell")
        tableView.withCell("Province1")
        tableView.isSkeletonable = true
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        search.setClearButton(color: UIColor.white)
        search.addTarget(self, action: #selector(textIsChanging), for: .editingChanged)
        
        Permission.shareInstance()?.initLocation(false, andCompletion: { (type) in
            
        })
        
        arrow.action(forTouch: [:]) { (objc) in
            self.didPressFilter()
        }
        
        didRequestStation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutSkeletonIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        kb.keyboardOff()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        if Reachability.isConnectedToNetwork(){

        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.tableView.reloadData()
            })
            self.showToast("Mạng không khả dụng, mời bạn thử lại", andPos: 0)
        }

        kb.keyboard { (height, isOn) in
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: isOn ? (height - 0) : 0, right: 0)
            if #available(iOS 10.0, *) {
                self.tableView.refreshControl = isOn ? nil : self.refreshControl
            } else {
                if isOn {
                    self.refreshControl.removeFromSuperview()
                } else {
                    self.tableView.addSubview(self.refreshControl)
                }
            }
        }
    }
   
    @IBAction func didPressSort() {
        EM_MenuView.init(filter: ["data": (self.filterValue == "2" ? sortList1 : sortList) as Any]).show { (indexing, obj, menu) in
                  let ids = (obj as! NSDictionary)["data"] as! NSDictionary
                  if indexing == 100 {
                    self.sortValue = ids.getValueFromKey("value")
                    self.didRequestStation()
                  menu?.close()
              }
          }
    }
    
    @IBAction func didPressFilter() {
        menu.didDropDown(withData: (filterList as! [Any])) { (objc) in
            if objc != nil {
                let result = ((objc as! NSDictionary)["data"] as! NSDictionary)["description"]
                
                let filter = ((objc as! NSDictionary)["data"] as! NSDictionary)["value"]
                                               
                self.menu.setTitle(result as? String, for: .normal)
                
                self.filterValue = filter as! String
                self.sortWidth.constant = self.filterValue == "3" || self.filterValue == "4" ? 0 : 44
                self.sortValue = "1"
                for dict in self.sortList {
                    (dict as! NSMutableDictionary)["subscribed"] = self.sortList.index(of: dict) == 0 ? 1 : 0
                }
                for dict in self.sortList1 {
                    (dict as! NSMutableDictionary)["subscribed"] = self.sortList1.index(of: dict) == 0 ? 1 : 0
                }
                self.didRequestStation()
            }
        }
//        EM_MenuView.init(filter: ["data": filterList as Any]).show { (indexing, obj, menu) in
//            let ids = (obj as! NSDictionary)["data"] as! NSDictionary
//                 if indexing == 100 {
//                    self.filterValue = ids.getValueFromKey("value")
//                    self.sortWidth.constant = self.filterValue == "3" || self.filterValue == "4" ? 0 : 44
//                    self.sortValue = "1"
//                    for var dict in self.sortList {
//
//                        (dict as! NSMutableDictionary)["subscribed"] = self.sortList.index(of: dict) == 0 ? 1 : 0
//                    }
//                    for var dict in self.sortList1 {
//                        (dict as! NSMutableDictionary)["subscribed"] = self.sortList1.index(of: dict) == 0 ? 1 : 0
//                    }
//                    self.didRequestStation()
//                    menu?.close()
//             }
//         }
    }

    func didRequestStation() {
        
        var lat = "0"
               
        var lng = "0"

        if (Permission.shareInstance()?.isLocationEnable())! {
            let location = Permission.shareInstance()?.currentLocation()! as! NSDictionary
           
            lat = location.getValueFromKey("lat")
           
            lng = location.getValueFromKey("lng")
        }
        
//        waterlevel?keyword=&lon=&lat=&basinCode=&riverCode=0&provinceCode=&orderBy=1
        
//        v2/station/waterlevel?keyword=&lon=105.832818&lat=21.007733&basinCode=&riverCode=0&provinceCode=&orderBy=
        
        var postFix = "v2/station/waterlevel?keyword=&lon=&lat=&basinCode=&riverCode=0&provinceCode="

        let postFix1 = "province"
        
        let postFix2 = "basin"
        
        let postFix3 = "v2/station/waterlevel?keyword=&lon=%@&lat=%@&basinCode=&riverCode=0&provinceCode=&orderBy=".format(parameters: lng, lat)
        
        if filterValue == "1" {
            postFix = postFix + "&orderby=%@".format(parameters: self.sortValue)
        }
        
        if filterValue == "2" {
            postFix = postFix1 + "?orderby=%@".format(parameters: self.sortValue)
        }
        
        if filterValue == "3" {
            postFix = postFix2
        }
        
        if filterValue == "4" {
            postFix = postFix3
        }
        
        LTRequest.sharedInstance()?.didRequestInfo(["absoluteLink": "".urlGet(postFix: postFix),
                                                    "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                    "overrideAlert":"1",
                                                    "overrideLoading":"1",
                                                    ], withCache: { (cacheString) in
        }, andCompletion: { (response, errorCode, error, isValid, object) in
            let result = response?.dictionize() ?? [:]
            self.refreshControl.endRefreshing()
            
            if (error != nil) || result.getValueFromKey("status") != "OK" {
               self.showToast(response?.dictionize().getValueFromKey("data") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("data"), andPos: 0)
               return
           }
            
            if response?.dictionize()["data"] is String {
                self.showToast(response?.dictionize().getValueFromKey("data") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("data"), andPos: 0)
                self.dataList.removeAllObjects()
                self.tempList.removeAllObjects()
                self.tableView.reloadData()
                return
            }
            
            print(result)
            
            self.dataList.removeAllObjects()
            self.dataList.addObjects(from: response?.dictionize()["data"] as! [Any])
                       
            self.tempList.removeAllObjects()
            self.tempList.addObjects(from: response?.dictionize()["data"] as! [Any])
           self.tableView.reloadData()
        })
    }
    
    @IBAction func didPressSetting() {
        self.view.endEditing(true)
        self.navigationController?.pushViewController(PC_Setting_ViewController.init(), animated: true)
    }
    
    @IBAction func didPressForcast() {
        self.navigationController?.pushViewController(PC_Global_ViewController.init(), animated: true)
    }
    
    @IBAction func didPressNotification() {
        self.view.endEditing(true)
        self.navigationController?.pushViewController(PC_Notification_ViewController.init(), animated: true)
    }
    
    @IBAction func didPressBack() {
       self.view.endEditing(true)
       self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func textIsChanging(_ textField:UITextField) {

        if textField.text == "" {
            dataList.removeAllObjects()
            dataList.addObjects(from: tempList as! [Any])
            tableView.reloadData()
            return
        }
        
        let filtered = NSMutableArray.init()
        
        for dict in tempList {
            let search = (dict as! NSDictionary).response(forKey: "station_info") ? ((dict as! NSDictionary)["station_info"] as! NSDictionary).getValueFromKey("vi_tri") : strip((dict as! NSDictionary).getValueFromKey("vi_tri")!)
            if (search!.replacingOccurrences(of: "Đ", with: "D").replacingOccurrences(of: "đ", with: "d")).containsIgnoringCase(find: strip(textField.text!)) {
                filtered.add(dict)
            }
        }
        
        dataList.removeAllObjects()
        dataList.addObjects(from: filtered as! [Any])
        tableView.reloadData()
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        search.text = ""
        self.didRequestStation()
    }
    
    let strip: (String) -> String = {
        var mStringRef = NSMutableString(string: $0) as CFMutableString
        CFStringTransform(mStringRef, nil, kCFStringTransformStripCombiningMarks, Bool(truncating: 0))
        return String(mStringRef)
    }
}

extension PC_Province_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let data = (dataList[indexPath.row] as! NSDictionary).response(forKey: "station_info") ? (dataList[indexPath.row] as! NSDictionary)["station_info"] as! NSDictionary : dataList[indexPath.row] as! NSDictionary
                
        let cell = tableView.dequeueReusableCell(withIdentifier: data.getValueFromKey("xuthe") == "0" ? "Province_Cell" : "Province1", for: indexPath)
        
        let name = self.withView(cell, tag: 11) as! UILabel
                       
        name.text = data.getValueFromKey("vi_tri")
        
        
        let desc = self.withView(cell, tag: 12) as! UILabel
                       
        desc.text = data.getValueFromKey("vitri_de")
        
        
        let value = self.withView(cell, tag: 14) as! UILabel
                              
       value.text = data.getValueFromKey("mucnuoc_hientai") + "m"
       
       
       let time = self.withView(cell, tag: 15) as! UILabel
                      
       time.text = data.getValueFromKey("thoigian_capnhat")
        
        
        let icon = self.withView(cell, tag: 16) as! UIImageView
        
        icon.isHidden = data.getValueFromKey("xuthe") == "0"
        
        icon.heightConstaint!.constant = data.getValueFromKey("xuthe") == "0" ? 0 : 27
                             
        
        let red = self.withView(cell, tag: 1000) as! UIView

        red.alpha = data.getValueFromKey("cap_baodong") != "0" ? 0.7 : 0
        
        
//        if data.getValueFromKey("SoSanhBaoDong") != "" {
//
//            let arr = data.getValueFromKey("SoSanhBaoDong")?.components(separatedBy: ":")
//
//            let bd = self.withView(cell, tag: 17) as! UILabel
//
//            bd.text = arr![0]
//
//            print(arr)
//
//
//            let mm = self.withView(cell, tag: 18) as! UILabel
//
//            mm.text = arr![1]
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if dataList.count == 0 {
            return
        }
        
        
          let data = (dataList![indexPath.row] as! NSDictionary)

            var lat = "21.0077147"

            var lng = "105.832827"

            if (Permission.shareInstance()?.isLocationEnable())! {
                let location = Permission.shareInstance()?.currentLocation()! as! NSDictionary

                lat = location.getValueFromKey("lat")

                lng = location.getValueFromKey("lng")
            }

            let web = PC_Inner_Map_ViewController.init()

            web.directUrl = "http://eladmin.gisgo.vn/?cmd=station&id_kttv=%@&id_vitrimucnuoc=%@&x=@&y=%@&lat=%@&lng=%@".format(parameters: data.getValueFromKey("idtram"), data.getValueFromKey("id_vitrimucnuoc"), data.getValueFromKey("kinhdo"), data.getValueFromKey("vido"), lat, lng ) as NSString

            self.navigationController?.pushViewController(web, animated: true)
        
    }
}
