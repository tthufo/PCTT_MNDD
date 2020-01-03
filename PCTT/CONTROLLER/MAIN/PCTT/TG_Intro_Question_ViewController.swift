//
//  TG_Intro_Question_ViewController.swift
//  PCTT
//
//  Created by Thanh Hai Tran on 11/8/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

import UIKit

import MarqueeLabel

class TG_Intro_Question_ViewController: UIViewController {

    @IBOutlet var titleLabel: MarqueeLabel!
    
    @IBOutlet var tableView: UITableView!

    @IBOutlet var tableCell: UITableViewCell!

    var qInfo: NSDictionary!
    
      @IBOutlet var headerImg: UIImageView!

      override func viewDidLoad() {
          super.viewDidLoad()
          
          if Information.check == "0" {
              headerImg.image = UIImage(named: "bg_text_dms")
          }
        
    }
    
    @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TG_Intro_Question_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableCell //tableView.dequeueReusableCell(withIdentifier:"PC_Info_Cell", for: indexPath)
        
        
        let image = self.withView(cell, tag: 11) as! UIImageView
        
        //        image.imageUrl(url: data.getValueFromKey("image"))
        
        image.image = UIImage(named: "question")
        
        let title = self.withView(cell, tag: 12) as! UILabel
        
        title.text = qInfo.getValueFromKey("question")
        
        let time = self.withView(cell, tag: 14) as! UILabel
        
        time.text = ""
        
        let content = self.withView(cell, tag: 15) as! UILabel

        content.text = qInfo.getValueFromKey("answer")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        self.navigationController?.pushViewController(TG_Intro_Question_ViewController.init(), animated: true)
    }
}

