//
//  DetailFoodView.swift
//  
//
//  Created by yuka on 2018/05/11.
//

import UIKit
import CoreData

class DetailFoodView: UIViewController
//    ,UIGestureRecognizerDelegate
    
{

    // MARK:- Varible
    @IBOutlet weak var detailScrollView: UIScrollView!
    
    // 画面表示用
    @IBOutlet weak var food_name_Label: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var favoriteStackView: UIStackView!
    
    @IBOutlet weak var image1ImageView: UIImageView!
    @IBOutlet weak var header1Label: UILabel!
    @IBOutlet weak var legend1TextView: UITextView!
    
    @IBOutlet weak var image2ImageView: UIImageView!
    @IBOutlet weak var header2Label: UILabel!
    
    @IBOutlet weak var legend2TextView: UITextView!
    
    @IBOutlet weak var image3ImageView: UIImageView!
    @IBOutlet weak var header3Label: UILabel!
    @IBOutlet weak var legend3TextView: UITextView!
    
    @IBOutlet weak var header4Label: UILabel!
    

    
    // データ受け取り用
    var getFoodDic:NSDictionary!

    // Favorite
    @IBOutlet weak var favoriteButton: UIButton!
    var isFavorite:Bool = false

    
    // Gesture
    var tapLinkRecognizer:UITapGestureRecognizer!
    
    // MARK: - display

    override func loadView() {

        if let view = UINib(nibName: "DetailFoodView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = false
        let id  = getFoodDic["id"] as! Int16

        //plistから読み出し処理
        image1ImageView.image = UIImage(named:"\(id)_01")
        if UIImage(named: "\(id)_02") == nil {
            image2ImageView.isHidden = true
        }
        else {
            image2ImageView.image = UIImage(named: "\(id)_02")
            
        }
        if UIImage(named: "\(id)_03") == nil {
            image3ImageView.isHidden = true
        }
        else {
            image3ImageView.image = UIImage(named: "\(id)_03")

        }
        
        
        food_name_Label.text = getFoodDic["food_name"] as? String
        areaLabel.text = "発祥地域 \(getFoodDic["area"] as! String)"
        header1Label.text = getFoodDic["header1"] as? String
        header2Label.text = getFoodDic["header2"] as? String
        header3Label.text = getFoodDic["header3"] as? String
        settingHeader4Label()
 
        
        legend1TextView.text = getFoodDic["legend1"] as? String
        legend2TextView.text = getFoodDic["legend2"] as? String
        legend3TextView.text = getFoodDic["legend3"] as? String

        legend1TextView.sizeToFit()
        legend2TextView.sizeToFit()
        legend3TextView.sizeToFit()
        legend1TextView.sizeThatFits(legend1TextView.contentSize)
        legend2TextView.sizeThatFits(legend2TextView.contentSize)
        legend3TextView.sizeThatFits(legend3TextView.contentSize)


        // StackViewで4pt空けているので足りないスペースをここで追加
        legend1TextView.frame.size.height += 4
        legend2TextView.frame.size.height += 4


        print(isFavorite)
        checkFavoriteCoreData()
        print(isFavorite)
        if isFavorite {
                favoriteButton.setImage(UIImage(named: "Favorites_Detail.png"), for: .normal)
        }
        

    }


    override func viewDidLayoutSubviews() {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        tapLinkRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapURL))
        header4Label.addGestureRecognizer(tapLinkRecognizer)
//        tapLinkRecognizer.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK; - Gesture
    @IBAction func tabFavorite(_ sender: UIButton) {
        saveOrDeleteFavorite()
    }
    
    @IBAction func tapHeader4(_ sender: UITapGestureRecognizer) {
        tapURL()
    }
    
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    

    @objc func tapURL () {
        let url = URL(string: getFoodDic["url"]! as! String)
//        UIApplication.shared.openURL(url! as URL)
        UIApplication.shared.open(url!, completionHandler: nil)
        
    }

    // MARK: - CoreData
    func saveOrDeleteFavorite () {
        let id = getFoodDic["id"] as! Int
        //AppDelegateを使う用意をしておく（インスタンス化）
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //エンティティを操作する為のオブジェクト作成
        let viewContext = appDelegate.persistentContainer.viewContext

        //=== すでにお気に入りに入っているか確認 ===
        if !isFavorite {  // 入ってないので追加
            //Favoriteエンティティオブジェクトを作成
            let favoriteEntity = NSEntityDescription.entity(forEntityName: "Favorite", in: viewContext)
            //Favoriteエンティティにレコード（行）を挿入する為のオブジェクトを作成
            let newRecord = NSManagedObject(entity: favoriteEntity!, insertInto: viewContext)

            //値のセット
            let cuisine = getFoodDic["food_name"] as! String
            let country = getFoodDic["country"] as! String

            newRecord.setValue(cuisine, forKey: "cuisine")  //hotel列に文字列をセット
            newRecord.setValue(country, forKey: "country")  //country列に文字列をセット
            newRecord.setValue(id, forKey: "id")  //country列に文字列をセット
            print("\(cuisine)","\(id)","\(country)")
            
            //レコード（行）の即時保存
            do{
                try viewContext.save()
                print("お気に入りに保存されました")
                
            }catch{
                //エラーが出た時に行う処理を書いておく場所
                print(error, #function)
            }
            
            isFavorite = true
            favoriteButton.setImage(UIImage(named: "Favorites_Detail.png"), for: .normal)
        }
        else {  //入っているので削除
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
            
            isFavorite = false
            favoriteButton.setImage(UIImage(named: "Favorites_Empty_Detail.png"), for: .normal)

            
        }

    }
    
    func checkFavoriteCoreData() {
        //AppDelegateを使う用意をしておく（インスタンス化）
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //エンティティを操作する為のオブジェクト作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query:NSFetchRequest<Favorite> = Favorite.fetchRequest()
        
        let id = getFoodDic["id"] as! Int
        
        
        //=== すでにお気に入りに入っているか確認 ===
        let favoritePredicate = NSPredicate(format: "id = %d", id)
        query.predicate = favoritePredicate
        
        do {
            let fetchResults = try viewContext.fetch(query)
            
            if( fetchResults.count != 0 ) {
                isFavorite = true
            }
            else {
                isFavorite = false
            }
        }catch{
            print(error, #function)
        }

        if isFavorite {
            favoriteButton.setImage(UIImage(named: "Favorites_Detail.png"), for: .normal)
        }
        else {
            favoriteButton.setImage(UIImage(named: "Favorites_Empty_Detail.png"), for: .normal)
        }
    }
    
    // MARK:- custom function
    
    // Header4は空のときは表示しない
    func settingHeader4Label() {
        guard let header4Text = getFoodDic["header4"] as? String
            
            else {
                header4Label.isHidden = true
                print("else側")
                return
        }
        if header4Text == "" {
            print("空白側")
            header4Label.isHidden = true
            return
        }
        print("普通側")
        // ラベルにアンダーバーをつけるためにatrributedTextに代入
        header4Label.attributedText = NSAttributedString(string: header4Text, attributes:
            [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        header4Label.frame.size.height += 4
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
