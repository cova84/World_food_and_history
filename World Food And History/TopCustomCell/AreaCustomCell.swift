//
//  AreaCustomCell.swift
//  Japanese Inn List
//
//  Created by 小林由知 on 2017/12/02.
//  Copyright © 2017年 Yoshitomo Kobatashi. All rights reserved.
//

import UIKit
//import CoreGraphics

class areaCustomCell: UITableViewCell {

    @IBOutlet weak var varticalLabel: UILabel!
    @IBOutlet weak var background: UIView!
    
    override func awakeFromNib() {
    super.awakeFromNib()
            
        //textLabelデザイン-----------------------------------------
        varticalLabel?.font = UIFont(name: "Futura", size: 16)
        varticalLabel?.textColor = UIColor.white

    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        if selected {
            backgroundColor = UIColor.white
        } else {
            backgroundColor = UIColor.white
        }
    }
    
}

//------------------------------------------------------------------------------------------------
//カラー                                                   red    green    blue      idMini    idMax
//北アメリカ    northAmerican                               248    49       98        100       199
//中南米    latinAmerica                                   246    49       241       200       299
//アジア（北〜東〜東南アジア）    asia_north_east_southeast    42     37       255       600       899
//アジア（中央〜南〜西アジア）    asia_center_south_west       39     162      255       900       1299
//アジア（予備）
//ヨーロッパ    europe                                      16     107      20        300       499
//アフリカ    africa                                        255    193      37        500       599
//オーストラリア・オセアニア    australia_oceania               28    190       34       1300      1399
//------------------------------------------------------------------------------------------------

