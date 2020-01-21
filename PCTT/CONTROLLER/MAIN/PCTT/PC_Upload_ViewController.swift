//
//  PC_Upload_ViewController.swift
//  PCTT
//
//  Created by Thanh Hai Tran on 11/18/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

import UIKit

import Photos

import PhotosUI

import DKImagePickerController

import AFNetworking

class PC_Upload_ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet var header: UIView!

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var tableViewFiles: UITableView!

    @IBOutlet var cell: UITableViewCell!

    @IBOutlet var textField: UITextField!
    
    @IBOutlet var latField: UITextField!

    @IBOutlet var lngField: UITextField!

    @IBOutlet var textView: UITextView!

    @IBOutlet var submit: UIButton!
    
    @IBOutlet var save: UIButton!

    @IBOutlet var back: UIButton!
    
    @objc var latLng: NSDictionary!
    
    var dataList: NSMutableArray!
        
    var inner: Bool = true

      @IBOutlet var headerImg: UIImageView!

      override func viewDidLoad() {
          super.viewDidLoad()
          
          if Information.check == "0" {
              headerImg.image = UIImage(named: "bg_text_dms")
          }

        textView.inputAccessoryView = self.toolBar()

        textField.addTarget(self, action: #selector(textIsChanging), for: .editingChanged)

        self.view.action(forTouch: [:]) { (objc) in
            self.view.endEditing(true)
        }
        
        dataList = NSMutableArray.init()
                      
        tableViewFiles.withCell("PC_File_Cell")
        
        var lat = "0"
               
        var lng = "0"

       if (Permission.shareInstance()?.isLocationEnable())! {
           let location = Permission.shareInstance()?.currentLocation()! as! NSDictionary
           
           lat = location.getValueFromKey("lat")
           
           lng = location.getValueFromKey("lng")
       }
        
        latField.text = "Kinh độ: %@".format(parameters: latLng == nil ? lat : latLng.getValueFromKey("lat"))
        
        lngField.text = "Vĩ độ: %@".format(parameters: latLng == nil ? lng : latLng.getValueFromKey("lng"))
    }

    func toolBar() -> UIToolbar {
           
           let toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: Int(self.screenWidth()), height: 50))
           
           toolBar.barStyle = .default
           
           toolBar.items = [UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                            UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                            UIBarButtonItem.init(title: "Thoát", style: .done, target: self, action: #selector(disMiss))]
           return toolBar
       }
       
       @objc func disMiss() {
           self.view.endEditing(true)
       }
    
    @IBAction func didPressSave() {
       self.view.endEditing(true)
               
        if dataList.count == 0 {
            self.showToast("Hãy chọn tệp đính kèm", andPos: 0)
            
            return
        }
       let array = NSMutableArray.init()
       
       for dict in dataList {
           let d = dict as! NSDictionary
           array.add(["file": d["file"] , "fileName": d["fileName"], "key":"ds"])
       }
       
        var lat = "0"
        
        var lng = "0"

        if (Permission.shareInstance()?.isLocationEnable())! {
            let location = Permission.shareInstance()?.currentLocation()! as! NSDictionary
            
            lat = location.getValueFromKey("lat")
            
            lng = location.getValueFromKey("lng")
        }
        
        let autoId = self.getValue("autoId")
                
        Information.addOffline(request: ["id": autoId, "field": array, "data":[
        "event_name": textField.text as Any,
        "event_description": textView.text as Any,
        "lat": lat,
        "lon": lng]])
        
        let auto:Int? = Int(autoId ?? "0")

        self.addValue(String(auto! + 1), andKey: "autoId")
                
        self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func didPressSubmit() {
        self.view.endEditing(true)
    
        if dataList.count == 0 {
            self.showToast("Hãy chọn tệp đính kèm", andPos: 0)
            
            return
        }
        
        let array = NSMutableArray.init()
        
        for dict in dataList {
            let d = dict as! NSDictionary
            array.add(["file": d["file"] , "fileName": d["fileName"], "key":"ds"])
        }
        
        var lat = "0"
        
        var lng = "0"

        if (Permission.shareInstance()?.isLocationEnable())! {
            let location = Permission.shareInstance()?.currentLocation()! as! NSDictionary
            
            lat = location.getValueFromKey("lat")
            
            lng = location.getValueFromKey("lng")
        }
        
        LTRequest.sharedInstance()?.didRequestMultiPart(["CMD_CODE":"event/",
                                                    "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                    "data":[
                                                    "event_name": textField.text as Any,
                                                    "event_description": textView.text as Any,
                                                    "lat": lat,
                                                    "lon": lng],
                                                    "field": dataList.count != 0 ? array : [],
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
            
            self.showToast("Cập nhật thông tin thiên tai thành công", andPos: 0)
            
            self.navigationController?.popViewController(animated: true)
            
        })
    }
    
    @IBAction func didPressBack() {
           self.view.endEditing(true)
           self.navigationController?.popViewController(animated: true)
       }
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img//?.imageString() as NSString?
    }
    
    @IBAction func didPressAttach() {
         let pickerController = DKImagePickerController()
 
         pickerController.maxSelectableCount = 4
 
         pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            self.dataList.removeAllObjects()
            
            for asset in assets {
                if asset.type == .video {
                    let resourse = PHAssetResource.assetResources(for: asset.originalAsset!)

                    let name = resourse.first?.originalFilename
                                        
                    var sizeOnDisk: Int64? = 0

                    if let resource = resourse.first {
                      let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
                      sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
                    }
                    
                    if Float(sizeOnDisk!) / (1024 * 1024) <= 30 {
                        PHImageManager.default().requestAVAsset(forVideo: asset.originalAsset!, options: nil, resultHandler: { (ass, mix, nil) in
                            let myAsset = ass as? AVURLAsset
//                            do {
////                                asset.originalAsset?.getURL(completionHandler: { (url) in
////                                    self.dataList.add(["fileName": name!, "file": url!.absoluteString  ])
////                                })
////                                let videoData = try Data(contentsOf: (myAsset?.url)!)
////                                self.dataList.add(["fileName": ur, "file": String(decoding: videoData, as: UTF8.self)])
//                            } catch  {
//                                print("exception catch at block - while uploading video")
//                            }
                            asset.originalAsset?.getURL(completionHandler: { (url) in
                               self.dataList.add(["fileName": name!, "file": url!.absoluteString  ])
                                 DispatchQueue.main.async {
                                    self.tableViewFiles.reloadData()
                                }
                           })
                        })
                    } else {
                        self.showToast(name! + " dung lượng lớn hơn 30MB", andPos: 0)
                    }
                } else {
                    let resourse = PHAssetResource.assetResources(for: asset.originalAsset!)

                    let name = resourse.first?.originalFilename
                                                                                
                    asset.originalAsset?.getURL(completionHandler: { (url) in
                        self.dataList.add(["fileName": name!, "file": url!.absoluteString  ])
                        self.tableViewFiles.reloadData()
                    })
              }
            }
            self.tableViewFiles.reloadData()
         }
 
         self.present(pickerController, animated: true) {
 
         }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    @objc func textIsChanging(_ textField:UITextField) {
        submit.isEnabled = textField.text?.count != 0 && textView.text?.count != 0
        submit.alpha = textField.text?.count != 0 && textView.text?.count != 0 ? 1 : 0.5
        save.isEnabled = textField.text?.count != 0 && textView.text?.count != 0
        save.alpha = textField.text?.count != 0 && textView.text?.count != 0 ? 1 : 0.5
    }
    
    func textViewDidChange(_ textView: UITextView) {
        submit.isEnabled = textField.text?.count != 0 && textView.text?.count != 0
        submit.alpha = textField.text?.count != 0 && textView.text?.count != 0 ? 1 : 0.5
        save.isEnabled = textField.text?.count != 0 && textView.text?.count != 0
        save.alpha = textField.text?.count != 0 && textView.text?.count != 0 ? 1 : 0.5
    }
}

extension PC_Upload_ViewController: UITableViewDataSource, UITableViewDelegate {

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView == tableViewFiles ? 38 : 645 - 0
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableView == tableViewFiles ? dataList.count : 1
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if tableView == tableViewFiles {
        let cellFile = tableView.dequeueReusableCell(withIdentifier:"PC_File_Cell", for: indexPath)
               
        let data = dataList![indexPath.row] as! NSDictionary
        
        let title = self.withView(cellFile, tag: 11) as! UILabel
        
        title.text = data["fileName"] as? String
        
        let x = self.withView(cellFile, tag: 12) as! UIButton

        x.action(forTouch: [:]) { (obj) in
            self.dataList.removeObject(at: indexPath.row)
            
            self.tableViewFiles.reloadData()
        }
        
        return cellFile
    }
    
    return cell
}

}
