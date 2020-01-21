//
//  PC_Event_Info_ViewController.swift
//  PCTT
//
//  Created by Thanh Hai Tran on 12/13/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MMPlayerView


class PC_Event_Info_ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    @IBOutlet var cell: UITableViewCell!
    
    @IBOutlet var titleText: InsetLabel!

    @IBOutlet var descText: InsetLabel!
    
    @IBOutlet var latField: UITextField!

    @IBOutlet var lngField: UITextField!

    var dataList: NSMutableArray!
    
    @objc var eventInfo = NSDictionary()

   var offsetObservation: NSKeyValueObservation?
    
    lazy var mmPlayerLayer: MMPlayerLayer = {
        let l = MMPlayerLayer()
    
        l.cacheType = .memory(count: 5)
        l.coverFitType = .fitToPlayerView
        l.videoGravity = AVLayerVideoGravity.resizeAspect
        l.replace(cover: CoverA.instantiateFromNib())
        l.repeatWhenEnd = true
        return l
    }()
    
    @IBOutlet weak var playerCollect: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerCollect.withCell("PlayerCell")
        
        playerCollect.withCell("CoverB")
        
        playerCollect.withCell("InfoCell")

        tableView.withCell("PC_Event_Info_Cell")
            
        tableView.withCell("PlayerCell1")
        
        tableView.withCell("VideoTableViewCell");
        
//        (playerCollect.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        (playerCollect.collectionViewLayout as! UICollectionViewFlowLayout).sectionInsetReference = .fromLayoutMargins
        
        MMPlayerDownloader.cleanTmpFile()
        self.navigationController?.mmPlayerTransition.push.pass(setting: { (_) in
            
        })
        offsetObservation = playerCollect.observe(\.contentOffset, options: [.new]) { [weak self] (_, value) in
            guard let self = self, self.presentedViewController == nil else {return}
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(self.startLoading), with: nil, afterDelay: 0.2)
        }
        playerCollect.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right:0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.updateByContentOffset()
            self?.startLoading()
        }
        
        mmPlayerLayer.getStatusBlock { [weak self] (status) in
            switch status {
            case .failed(let err):
                let alert = UIAlertController(title: "err", message: err.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            case .ready:
                print("Ready to Play")
            case .playing:
                print("Playing")
            case .pause:
                print("Pause")
            case .end:
                print("End")
            default: break
            }
        }
        mmPlayerLayer.getOrientationChange { (status) in
            print("Player OrientationChange \(status)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func shrinkAction() {

    }
    
    deinit {
        offsetObservation?.invalidate()
        offsetObservation = nil
        print("ViewController deinit")
    }
    
    @IBAction func didPressBack() {
        mmPlayerLayer.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressDetete() {
        DropAlert.shareInstance()?.alert(withInfor: ["title":"Thông báo", "message": "Bạn có chắc chắn muốn xóa sự kiện " + eventInfo.getValueFromKey("event_name"), "buttons": ["Có"], "cancel":"Không"], andCompletion: { (index, obj) in

            if index == 0 {
                self.requestDeleteEvent(id: self.eventInfo.getValueFromKey("id"))
            }
        })
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
            
            self.showToast("Xoá thành công", andPos: 0)
            
            self.didPressBack()
         })
      }
}

extension PC_Event_Info_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? UITableView.automaticDimension : CGFloat(self.screenWidth() * 9 / 16)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (eventInfo["EventSharingAttachments"] as! NSArray).count + 1
    }

    
        fileprivate func updateByContentOffset() {
    //        if mmPlayerLayer.isShrink {
    //            return
    //        }
            
            if let path = findCurrentPath(),
                self.presentedViewController == nil {
                self.updateCell(at: path)
                //Demo SubTitle
    //            if path.row == 0, self.mmPlayerLayer.subtitleSetting.subtitleType == nil {
    //                let subtitleStr = Bundle.main.path(forResource: "srtDemo", ofType: "srt")!
    //                if let str = try? String.init(contentsOfFile: subtitleStr) {
    //                    self.mmPlayerLayer.subtitleSetting.subtitleType = .srt(info: str)
    //                    self.mmPlayerLayer.subtitleSetting.defaultTextColor = .red
    //                    self.mmPlayerLayer.subtitleSetting.defaultFont = UIFont.boldSystemFont(ofSize: 20)
    //                }
    //            }
            }
        }

        fileprivate func updateDetail(at indexPath: IndexPath) {
    //        let value = DemoSource.shared.demoData[indexPath.row]
    //        if let detail = self.presentedViewController as? DetailViewController {
    //            detail.data = value
    //        }
    //
    //        self.mmPlayerLayer.thumbImageView.image = value.image
    //        self.mmPlayerLayer.set(url: DemoSource.shared.demoData[indexPath.row].play_Url)
    //        self.mmPlayerLayer.resume()
            
        }
        
        fileprivate func presentDetail(at indexPath: IndexPath) {
            self.updateCell(at: indexPath)
            mmPlayerLayer.resume()

    //        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
    //            vc.data = DemoSource.shared.demoData[indexPath.row]
    //            self.present(vc, animated: true, completion: nil)
    ////            self.navigationController?.pushViewController(vc, animated: true)
    //        }
        }
        
        fileprivate func updateCell(at indexPath: IndexPath) {
    //        if let cell = playerCollect.cellForItem(at: indexPath) as? PlayerCell, let playURL = cell.data?.play_Url {
    //            // this thumb use when transition start and your video dosent start
    ////            mmPlayerLayer.thumbImageView.image = cell.imgView.image
    //            // set video where to play
    //            mmPlayerLayer.playView = cell.imgView
    //            mmPlayerLayer.set(url: playURL)
    //        }
            
            let indexing = IndexPath(row: indexPath.row + 1, section: 0)
            
//            print(indexPath.row)
            
            if let cell = tableView.cellForRow(at: indexing) as? PlayerCell1, let playURL = cell.data?.play_Url {
                        // this thumb use when transition start and your video dosent start
            //            mmPlayerLayer.thumbImageView.image = cell.imgView.image
                        // set video where to play
                print(cell.data?.play_Url)
                        mmPlayerLayer.playView = cell.imgView
                        mmPlayerLayer.set(url: playURL)
                    }
        }
        
        @objc fileprivate func startLoading() {
            self.updateByContentOffset()
            if self.presentedViewController != nil {
                return
            }
            // start loading video
            mmPlayerLayer.resume()
        }
        
        private func findCurrentPath() -> IndexPath? {
            let p = CGPoint(x: tableView.frame.width/2, y: tableView.contentOffset.y + tableView.frame.width/2)
            return tableView.indexPathForRow(at: p)
        }
        
        private func findCurrentCell(path: IndexPath) -> UITableViewCell {
            return tableView.cellForRow(at: path)!
        }
    
       
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           guard let videoCell = cell as? VideoTableViewCell else { return };
           
           videoCell.playerView.player?.pause();
           videoCell.playerView.player = nil;
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row != 0 {
        let obj = ((eventInfo["EventSharingAttachments"] as! NSArray)[indexPath.row - 1] as! NSDictionary)
        
            print(obj)
            
        if obj.getValueFromKey("file_type") == "Video" {
             let videoCell = tableView.dequeueReusableCell(withIdentifier:  "PlayerCell1", for: indexPath) as! PlayerCell1
            
            let url = NSURL(string: (eventInfo["fileAttachmentPath"] as! NSArray)[indexPath.row - 1] as! String);
            
            videoCell.data = DataObj(image: #imageLiteral(resourceName: "seven"),
                                     play_Url: url as URL?,
            title: "",
            content: "")

            return videoCell
        }
    }
        
        let cellCell = indexPath.row == 0 ? cell! : tableView.dequeueReusableCell(withIdentifier: ((eventInfo["EventSharingAttachments"] as! NSArray)[indexPath.row - 1] as! NSDictionary).getValueFromKey("file_type") == "Image" ? "PC_Event_Info_Cell" : "PlayerCell1", for: indexPath)
        

        if indexPath.row == 0 {
            latField.text = "Kinh độ: %@".format(parameters: eventInfo.getValueFromKey("lat"))
            lngField.text = "Vĩ độ: %@".format(parameters: eventInfo.getValueFromKey("lon"))
            self.titleText.text = eventInfo.getValueFromKey("event_name")
            self.descText.text = eventInfo.getValueFromKey("event_description")
        } else {
            if ((eventInfo["EventSharingAttachments"] as! NSArray)[indexPath.row - 1] as! NSDictionary).getValueFromKey("file_type") == "Image" {
                (self.withView(cellCell, tag: 11) as! UIImageView).imageUrl(url: (eventInfo["fileAttachmentPath"] as! NSArray)[indexPath.row - 1] as! String)
                print("--->", (eventInfo["fileAttachmentPath"] as! NSArray)[indexPath.row - 1] as! String)
            } else {
//                let url = NSURL(string: (eventInfo["fileAttachmentPath"] as! NSArray)[indexPath.row - 1] as! String);
//                let avPlayer = AVPlayer(url: url! as URL);
//                (cellCell as! VideoTableViewCell).playerView?.playerLayer.player = avPlayer;
//
//                (cellCell as! PlayerCell1).data = DemoSource.shared.demoData[0]
            }
        }

        return cellCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

//        let data = dataList![indexPath.row] as! NSDictionary

//        DropAlert.shareInstance()?.alert(withInfor: ["title":"Thông báo", "message": "Bạn có chắc chắn muốn xóa sự kiện " + data.getValueFromKey("event_name"), "buttons": ["Có"], "cancel":"Không"], andCompletion: { (index, obj) in
//
//            if index == 0 {
//                self.requestDeleteEvent(id: data.getValueFromKey("id"))
//            }
//        })
    }
}

extension PC_Event_Info_ViewController: MMPlayerFromProtocol {
    // when second controller pop or dismiss, this help to put player back to where you want
    // original was player last view ex. it will be nil because of this view on reuse view
    func backReplaceSuperView(original: UIView?) -> UIView? {
        guard let path = self.findCurrentPath() else {
            return original
        }
        
        let cell = self.findCurrentCell(path: path) as! PlayerCell1
        return cell.imgView
    }

    // add layer to temp view and pass to another controller
    var passPlayer: MMPlayerLayer {
        return self.mmPlayerLayer
    }
    func transitionWillStart() {
    }
    // show cell.image
    func transitionCompleted() {
        self.updateByContentOffset()
        self.startLoading()
    }
}

extension PC_Event_Info_ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let m = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)

        return indexPath.item == 0 ? CGSize(width: m, height: m*0.75) : CGSize(width: m, height: m*0.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       DispatchQueue.main.async { [unowned self] in
//        if self.presentedViewController != nil || self.mmPlayerLayer.isShrink == true {
//                self.playerCollect.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
//                self.updateDetail(at: indexPath)
//            } else {
//                self.presentDetail(at: indexPath)
//            }
        }
    }
    
//    fileprivate func updateByContentOffset() {
////        if mmPlayerLayer.isShrink {
////            return
////        }
//
//        if let path = findCurrentPath(),
//            self.presentedViewController == nil {
//            self.updateCell(at: path)
//            //Demo SubTitle
////            if path.row == 0, self.mmPlayerLayer.subtitleSetting.subtitleType == nil {
////                let subtitleStr = Bundle.main.path(forResource: "srtDemo", ofType: "srt")!
////                if let str = try? String.init(contentsOfFile: subtitleStr) {
////                    self.mmPlayerLayer.subtitleSetting.subtitleType = .srt(info: str)
////                    self.mmPlayerLayer.subtitleSetting.defaultTextColor = .red
////                    self.mmPlayerLayer.subtitleSetting.defaultFont = UIFont.boldSystemFont(ofSize: 20)
////                }
////            }
//        }
//    }
//
//    fileprivate func updateDetail(at indexPath: IndexPath) {
////        let value = DemoSource.shared.demoData[indexPath.row]
////        if let detail = self.presentedViewController as? DetailViewController {
////            detail.data = value
////        }
////
////        self.mmPlayerLayer.thumbImageView.image = value.image
////        self.mmPlayerLayer.set(url: DemoSource.shared.demoData[indexPath.row].play_Url)
////        self.mmPlayerLayer.resume()
//
//    }
//
//    fileprivate func presentDetail(at indexPath: IndexPath) {
//        self.updateCell(at: indexPath)
//        mmPlayerLayer.resume()
//
////        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
////            vc.data = DemoSource.shared.demoData[indexPath.row]
////            self.present(vc, animated: true, completion: nil)
//////            self.navigationController?.pushViewController(vc, animated: true)
////        }
//    }
//
//    fileprivate func updateCell(at indexPath: IndexPath) {
////        if let cell = playerCollect.cellForItem(at: indexPath) as? PlayerCell, let playURL = cell.data?.play_Url {
////            // this thumb use when transition start and your video dosent start
//////            mmPlayerLayer.thumbImageView.image = cell.imgView.image
////            // set video where to play
////            mmPlayerLayer.playView = cell.imgView
////            mmPlayerLayer.set(url: playURL)
////        }
//
//        if let cell = tableView.cellForRow(at: indexPath) as? PlayerCell1, let playURL = cell.data?.play_Url {
//                    // this thumb use when transition start and your video dosent start
//        //            mmPlayerLayer.thumbImageView.image = cell.imgView.image
//                    // set video where to play
//            print(cell.data?.play_Url)
//                    mmPlayerLayer.playView = cell.imgView
//                    mmPlayerLayer.set(url: playURL)
//                }
//    }
//
//    @objc fileprivate func startLoading() {
//        self.updateByContentOffset()
//        if self.presentedViewController != nil {
//            return
//        }
//        // start loading video
//        mmPlayerLayer.resume()
//    }
//
//    private func findCurrentPath() -> IndexPath? {
//        let p = CGPoint(x: playerCollect.frame.width/2, y: playerCollect.contentOffset.y + playerCollect.frame.width/2)
//        return playerCollect.indexPathForItem(at: p)
//    }
//
//    private func findCurrentCell(path: IndexPath) -> UICollectionViewCell {
//        return playerCollect.cellForItem(at: path)!
//    }
}

extension PC_Event_Info_ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DemoSource.shared.demoData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = indexPath.item == 0 ? collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCell", for: indexPath) : collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCell", for: indexPath) as? PlayerCell {
            if indexPath.item != 0 {
                (cell as! PlayerCell).data = DemoSource.shared.demoData[indexPath.row - 1]
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

class InsetLabel: UILabel {
    let topInset = CGFloat(10)
    let bottomInset = CGFloat(10)
    let leftInset = CGFloat(10)
    let rightInset = CGFloat(10)

    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}
