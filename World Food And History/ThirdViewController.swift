//
//  ThirdViewController.swift
//  Japanese Inn List
//
//  Created by 小林由知 on 2017/11/16.
//  Copyright © 2017年 Yoshitomo Kobatashi. All rights reserved.


import UIKit
import CoreData


class ThirdViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var favoriteTableView: UITableView!

    //toDetailセグエ用　plistの配列を保存するメンバ変数
    var selectedDic:NSDictionary!

    
    //Favorite（内容を）格納する配列TabelViewを準備
    var contentCuisine:[NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        deleteAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //CoreDataを読み込む処理
        readCoreDataAll()
    }
    
    //すでに存在するデータの読み込み処理
    func readCoreDataAll() {
        
        //一旦からにする（初期化）
        contentCuisine = []
        //AppDelegateを使う用意をしておく
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //エンティティを操作する為のオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        //どのエンティティからデータを取得してくるか設定（Favoriteエンティティ）
        let query:NSFetchRequest<Favorite> = Favorite.fetchRequest()
        
        do{
            //データを一括取得
            let fetchResults = try viewContext.fetch(query)
            
            //きちんと保存できてるか、１行ずつ表示（デバックエリア）
            for result: AnyObject in fetchResults{
                let cuisine :String? = result.value(forKey:"cuisine") as? String
                let country :String? = result.value(forKey:"country") as? String
                let id :Int16? = result.value(forKey:"id") as? Int16
                
                let dic = ["id":id!,"cuisine":cuisine!,"country":country!] as [String : Any]
                print("cuisine:\(cuisine!) country:\(country!) ")
                contentCuisine.append(dic as NSDictionary)

            }
        }catch{
        }
        
        favoriteTableView.isUserInteractionEnabled = true
        //登録が一つも無かったら表示するようのダミー定義
        if contentCuisine.count == 0 {
            let dummy = ["id":0,"cuisine":"お気に入りの登録がありません","country":""] as [String : Any]
            contentCuisine.append(dummy as NSDictionary)
            favoriteTableView.isUserInteractionEnabled = false
        }
        favoriteTableView.reloadData()
    }
    
    
    @IBAction func tapAllDelete(_ sender: UIButton) {
        
        deleteAll()
    }

    func deleteAll(){
        //部品となるアラート作成
        let alert = UIAlertController(
            title: "All Delete", message: "全ての登録が削除されます。よろしいですか？", preferredStyle: .alert)
        
        
        
        //アラートの表示
        //completion: 動作が完了した後に発動される処理を指示
        //present(alert, animated: true, completion: nil)
        present(alert, animated: true, completion: {() -> Void in print("選択画面が表示されました。")})
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .default, handler: nil))
        //アラートにOKボタンを追加
        //handler : OKボタンが押された時に、行いたい処理に指定する場所
        //alert.addAction(UIAlertAction(title: "OPPAI", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in print("OKが押されました。")
            
            //AppDelegate使う準備をする（インスタンス化）
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            //エンティティを操作する為のオブジェクトを作成
            let viewContext = appDelegate.persistentContainer.viewContext
            //どのエンティティからデータを取得するか設定（Favoriteエンティティ）
            let query:NSFetchRequest<Favorite> = Favorite.fetchRequest()
            
            //削除したデータを取得（今回は全て取得）
            do{
                //削除するデータを取得(今回は全て)
                let fetchResulte = try viewContext.fetch(query)
                //１行ずつ（取り出した上で）削除
                for result:AnyObject in fetchResulte{
                    //削除処理を行うために型変換
                    let record = result as! NSManagedObject
                    viewContext.delete(record)
                }
                //削除した状態を保存
                try viewContext.save()
            }catch{
            }
            //再読み込み
            self.readCoreDataAll()
        }))
        
    }
    
    //TabelView用処理
    //行数の決定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentCuisine.count
    }
    
    
    //リストに表示する文字列を決定し、表示（cellForRowAtを検索）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //文字列を表示するセルの取得（セルの再利用）
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! customCellTableViewCell
        //表示したい文字の設定（セルの中には文字、画像も入る）
        let dic = contentCuisine[indexPath.row]
        
        cell.cuisineLabel.text = dic["cuisine"] as? String
        //文字を設定したセルを返す
        return cell
    }
    
    
    
    //セルがタップされた時のイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //okayumemo Favoriteデータから読出ししたデータを取り出し
        let cuisineDic = contentCuisine[indexPath.row]
        let id = cuisineDic["id"] as! Int16
        let key:String = "\(id)"
        
        // 0の時はダミーなのでセグエ発動しなくて良い
//        if id != 0 {
            //Key(ディクショナリー型で)Plistから取り出し
            let dic = readPlist(key:key)
            selectedDic = dic!
            //セグエのidentifierを指定して、画面移動
            performSegue(withIdentifier: "toDetail", sender: self)

//        }
        

        
    }
    
    

//    セグエを使って画面移動する時発動
    override func prepare(for segue:UIStoryboardSegue, sender:Any?){
        //次の画面のインスタンスを取得
        let dvc = segue.destination as! DetailFoodView
        //次の画面のプロパティにタップされたセルのkeyを渡す
        dvc.getFoodDic = self.selectedDic



    }
    


    //ボタンの装飾付き　ボタンを押した時の処理
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print(#function,indexPath)
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) -> Void in
            print(index,self.contentCuisine)
            let id = self.contentCuisine[index.row]["id"] as! Int

            self.contentCuisine.remove(at: index.row)
            self.favoriteTableView.deleteRows(at: [index], with: .automatic)
            self.deleteOne(id: id,index: index)
        
        }
        deleteButton.backgroundColor = UIColor.red

        return [deleteButton]
    }
    
    func deleteOne(id: Int,index:IndexPath){
        print(#function,id)
        //AppDelegate使う準備をする（インスタンス化）
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            //エンティティを操作する為のオブジェクトを作成
            let viewContext = appDelegate.persistentContainer.viewContext
            //どのエンティティからデータを取得するか設定（Favoriteエンティティ）
            let query:NSFetchRequest<Favorite> = Favorite.fetchRequest()
        
            let favoritePredicate = NSPredicate(format: "id = %d", id)
            query.predicate = favoritePredicate

            //削除したデータを取得（今回は全て取得）
            do{
                //削除するデータを取得(今回は全て)
                let fetchResults = try viewContext.fetch(query)
                    //削除処理を行うために型変換
                let record = fetchResults[0] as NSManagedObject
                viewContext.delete(record)
                //削除した状態を保存
                try viewContext.save()
                
            }catch{
                print(error)
            }
            //再読み込み
            self.readCoreDataAll()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print(#function)
        
    }
    
    
}

