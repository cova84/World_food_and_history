//
//  customCellTableViewCell.swift
//  Japanese Inn List
//
//  Created by 小林由知 on 2017/11/29.
//  Copyright © 2017年 Yoshitomo Kobatashi. All rights reserved.
//

import UIKit

class customCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var hotelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //    textLabel?.font = UIFont(name: "Futura", size: 10)
        //    textLabel?.textColor = UIColor.black
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

