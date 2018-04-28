//
//  FourthViewController.swift
//  Japanese Inn List
//
//  Created by 小林由知 on 2017/11/16.
//  Copyright © 2017年 Yoshitomo Kobatashi. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController {
    
    @IBAction func tapLifeofLink(_ sender: UIButton) {
    
        let url = URL(string: "https://life-of.net/2017/12/17/%E4%B8%96%E7%95%8C%E6%97%A5%E6%9C%AC%E4%BA%BA%E5%AE%BF%E3%81%BE%E3%81%A8%E3%82%81%E4%B8%80%E8%A6%A7%E3%82%A2%E3%83%97%E3%83%AAjinnilee/")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

