//
//  custom.swift
//  World Food And History
//
//  Created by yuka on 2018/05/12.
//  Copyright © 2018年 Yoshitomo Kobatashi. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardInstantiable {
    static var storyboardName: String { get }
    static var bundle: Bundle? { get }
}

extension StoryboardInstantiable where Self: UIViewController {
    static var bundle: Bundle? {
        return nil
    }
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return storyboard.instantiateInitialViewController() as! Self
    }
}

extension DetailFoodView:StoryboardInstantiable {
    static var storyboardName: String {
        return "DetailFoodView"
    }
    
    
}

protocol MovableDetailView {
    static var name: String{ get }
}


extension MovableDetailView where Self: UIViewController {
    
    
    // keyからPlistのデータを取得する
    func readPlist(key: String) -> NSDictionary? {
        //ファイルパスを取得（エリア名が格納されているプロパティリスト）
        let path = Bundle.main.path(forResource: "food_list_Detail", ofType: "plist")
        //ファイルの内容を読み込んでディクショナリー型に格納
        let dic = NSDictionary(contentsOfFile: path!)
        
        
        return dic![key] as? NSDictionary
    }

    func moveDetailView(keyDic:NSDictionary,key:String) {
        let storyboard = UIStoryboard(name: "DetailFoodView", bundle: nil) // storyboardのインスタンスを名前指定で取得
        let nextVC = storyboard.instantiateInitialViewController() as! DetailFoodView // storyboard内で"is initial"に指定されているViewControllerを取得
        self.view.insertSubview(nextVC.view, belowSubview: (self.tabBarController?.tabBar)!)

        nextVC.getFoodDic = keyDic
        self.present(nextVC, animated: true, completion: nil)
        
    }
    


}

extension ThirdViewController:MovableDetailView {

    
    static var name: String {
        get {
            return "ThirdViewController"
        }

    }
    
}

extension FirstViewController:MovableDetailView {
    static var name: String {
        get {
            return "FirstViewController"
        }
    }

    

}

