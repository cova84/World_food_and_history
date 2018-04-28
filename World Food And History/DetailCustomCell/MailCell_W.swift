//
//  MailCell_W.swift
//  Japanese Inn List
//
//  Created by 小林由知 on 2017/12/02.
//  Copyright © 2017年 Yoshitomo Kobatashi. All rights reserved.
//
//
import UIKit
import MessageUI

class mailCell_W: UITableViewCell, MFMailComposeViewControllerDelegate {


    @IBOutlet weak var background: UIView!
    @IBOutlet weak var buttonTitle: UIButton!
    
    //TableViewからurlを受け取るプロパティを作る。
    var mail:String = ""
    
    //リンク先のURL準備
    @IBAction func button(_ sender: UIButton) {
        let mailOpne = "mailto:\(self.mail)?subject=&body=メールでのご予約の際は、必ず、予約に必要な情報を確認してから、ご入力をお願い致します。\n\n\n\n------------------------------------------------\n世界の日本人宿一覧アプリ【Jinnilee】を利用し、\nお問い合わせをしております。\nアプリケーションについてのご意見・要望は、\n下記のHPへアクセスしコメントをお願い致します。\nhttps://life-of.net/2017/12/17/世界日本人宿まとめ一覧アプリjinnilee/ \n------------------------------------------------".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = NSURL(string: mailOpne!)
        UIApplication.shared.openURL(url as! URL)
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

