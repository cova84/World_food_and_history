//
//  URLCell_W.swift
//  Japanese Inn List
//
//  Created by 小林由知 on 2017/12/02.
//  Copyright © 2017年 Yoshitomo Kobatashi. All rights reserved.
//

import UIKit
//import CoreGraphics

class urlCell_W: UITableViewCell {


    @IBOutlet weak var background: UIView!
    @IBOutlet weak var buttonTitle: UIButton!
    //TableViewからurlを受け取るプロパティを作る。
    var url:String = ""
    
    @IBAction func button(_ sender: UIButton) {
        let url = URL(string: self.url)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    override func awakeFromNib() {
    super.awakeFromNib()
        //Viewの背景、囲い線-----------------------------------------
        background?.backgroundColor = UIColor(
              red: 246/255.0
            , green: 246/255.0
            , blue: 246/255.0
            , alpha: 1.0
        )
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

