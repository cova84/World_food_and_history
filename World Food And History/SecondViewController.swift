//
//  SecondViewController.swift
//  Japanese Inn List
//
//  Created by 小林由知 on 2017/11/16.
//  Copyright © 2017年 Yoshitomo Kobatashi. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController,MKMapViewDelegate {

    @IBAction func hybrid(_ sender: UIButton) {
        mapView.mapType = MKMapType.hybridFlyover
    }

    @IBAction func standard(_ sender: UIButton) {
        mapView.mapType = MKMapType.standard
    }

    @IBOutlet weak var mapView: MKMapView!

    //plistの配列を一時保存するメンバ変数
    var selectPinKeyDic = NSDictionary()
    //toDitailセグエ用　plistの配列を保存するメンバ変数
    var getKeyDic = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //はじめの世界地図表示----------------------------------------------------------------------------
        // 1.中心となる場所の座標オブジェクトを作成
        let coodineate = CLLocationCoordinate2DMake(35.658581,139.745433)
        // 2.縮尺を設定    (0.1, 0.1)で縮尺を指示(1, 1)が国全体
        let span = MKCoordinateSpanMake(100, 100)
        // 3.範囲オブジェクトを作成
        let region = MKCoordinateRegionMake(coodineate, span)
        // 4.MapViewに範囲オブジェクトを設定
        mapView.setRegion(region, animated: true)
        
        //plistの読み込み02--------------------------------------------------------
        //ファイルパスを取得（エリア名が格納されているプロパティリスト）
        let path = Bundle.main.path(forResource: "hotel_list_Detail", ofType: "plist")
        //ファイルの内容を読み込んでディクショナリー型に格納
        let dic = NSDictionary(contentsOfFile: path!)
        
        //配列の中身を高速
        for (key,data) in dic! {
            //Any型からDictionary型へ変換
            var dic = data as! NSDictionary
            //Dictionaryからキー指定で取り出すと必ずAny型になるので、ダウンキャスト変換が必要
            print(dic["hotelName"] as! String)
            print(dic["latitude"] as! String)
            print(dic["longitude"] as! String)
            
            //座標オブジェクト //地図
            let hotelName = dic["hotelName"] as! String
            let latitude = dic["latitude"] as! String
            let longitude = dic["longitude"] as! String
            
            //型変換が必要。String型〜Double型へ。atof()でくくると変わる。
            let coodineate = CLLocationCoordinate2DMake(atof(latitude), atof(longitude))
                        
            //地図にセット
            mapView.setRegion(region,animated: true)
            //1.pinオブシェクトを生成（）内は不要
            //mapKeyStorageで値を保存
            let myPin = getDicMap()
            myPin.pinKeyDic = dic
            //2.pinの座標を設定
            myPin.coordinate = coodineate
            //3.タイトル、サブタイトルを設定（タップした時に出る、吹き出しの情報）
            myPin.title = "\(hotelName)"
            self.mapView.addAnnotation(myPin)
            //4.mapViewにPinを追加
            mapView.addAnnotation(myPin)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MKMapView delegate
    // Called when the region displayed by the map view is about to change
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        //print(#function)
    }
    
    // Called when the annotation was added
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView //MKAnnotationViewに変えるとピン編集可能
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            //落下アクション
            pinView?.animatesDrop = true
            pinView?.isDraggable = true
            
            //ピンを画像に変更
            //MKPinAnnotationViewをMKAnnotationViewに変えると画像に変更可能
            //pinView.image = [UIImage imageNamed: "minus.png"]
            
            //ピンをテキストに変更
            //MKAnnotationViewをMKPinAnnotationViewに変えるとピン編集可能
            //pinView?.image = UIImage(named: "Laugh")
            
            //But01:バルーンにボタンを付けてみる
            pinView?.canShowCallout = true
            //But02:UIButton を生成して rightCalloutAccessoryView プロパティにセットします。
            let rightButton: AnyObject! = UIButton(type: UIButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = rightButton as? UIView
        }
        else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    //But03:ボタンがタップされると calloutAccessoryControlTapped デリゲートが呼ばれます。ここに必要な処理を書いていくと良いでしょう。
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            //Key(ディクショナリー型で)値の保存
            var pin:getDicMap = view.annotation as! getDicMap
            selectPinKeyDic = pin.pinKeyDic
//            print("view.annotation : \(view.annotation!)")
//            print("pin.pinKeyDic : \(pin.pinKeyDic)")
//
            //セグエのidentifierを指定して、画面移動
            performSegue(withIdentifier: "toDetail", sender: self)
        }
    }
    
    //セグエを使って画面移動する時発動
    override func prepare(for segue:UIStoryboardSegue, sender:Any?){
        
        //次の画面のインスタンスを取得
        var dvc = segue.destination as! DetailView
        
        //次の画面のプロパティにタップされたピンのIDを渡す
        dvc.getKeyDic = selectPinKeyDic

    }
}
