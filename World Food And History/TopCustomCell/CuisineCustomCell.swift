//
//  CuisineCustomCell.swift
//  World Food And History
//
//  Created by yuka on 2018/04/28.
//  Copyright © 2018年 Yoshitomo Kobatashi. All rights reserved.
//

import UIKit

class CuisineCustomCell: UITableViewCell {

    @IBOutlet weak var varticalLabel: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //textLabelデザイン-----------------------------------------
//        varticalLabel?.font = UIFont(name: "Futura", size: 16)
//        varticalLabel?.textColor = UIColor.white

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        if selected {
            backgroundColor = UIColor.white
        } else {
            backgroundColor = UIColor.white
        }
    }
    

}
