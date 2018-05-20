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
        var urlLink = "https://www.instagram.com/sekai_no_saihate_de_waraitai/"

        switch sender.tag {
        case 1:
            urlLink = "https://www.facebook.com/mevoyaviajartodoelmundo/"
        default: // 2
            break
        }
        
        let url = URL(string: urlLink)!
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

