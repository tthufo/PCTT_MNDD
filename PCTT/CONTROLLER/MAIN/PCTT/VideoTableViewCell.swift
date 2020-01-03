//
//  VideoTableViewCell.swift
//  PCTT
//
//  Created by Thanh Hai Tran on 12/28/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var playerView: PlayerView!
    
    @IBOutlet weak var playButton: UIButton!

    @IBAction func didPress() {
        playerView.player?.play()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
