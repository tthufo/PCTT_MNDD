//
//  PlayerCell1.swift
//  PCTT
//
//  Created by Thanh Hai Tran on 1/5/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

import UIKit

class PlayerCell1: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
     var data:DataObj? {
            didSet {
    //            self.imgView.image = data?.image
    //            self.labTitle.text = data?.title
            }
        }
    
    @IBOutlet weak var imgView: UIImageView!
//    @IBOutlet weak var labTitle: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.isHidden = false
        data = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
