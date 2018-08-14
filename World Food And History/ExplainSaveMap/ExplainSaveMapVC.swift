//
//  ExplainSaveMapVC.swift
//  World Food And History
//
//  Created by 岡田有加 on 2018/08/11.
//  Copyright © 2018年 Yoshitomo Kobatashi. All rights reserved.
//

import UIKit

class ExplainSaveMapVC: UIViewController {

    @IBOutlet weak var backToDetail: UILabel!
    var tapBackRecognizer:UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // ラベルにアンダーバーをつけるためにatrributedTextに代入
        backToDetail.attributedText = NSAttributedString(string: "前のページに戻る", attributes:
            [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        backToDetail.frame.size.height += 4
        tapBackRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        backToDetail.addGestureRecognizer(tapBackRecognizer)

    }

    @IBAction func leftEdgePan(_ sender: UIScreenEdgePanGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
        print("leftEdgePan")
    }
}

extension ExplainSaveMapVC {
    @objc func tapBack() {
        self.dismiss(animated: true, completion: nil)

    }
    
    
    
}
