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
    
//    @IBOutlet weak var header4TextView: UITextView!
    
    
    
    // データ受け取り用
    var getFoodDic:NSDictionary!
    var key:String!
    
    // Favorite
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    // Gesture
    var tapLinkRecognizer:UITapGestureRecognizer!
    
    override func loadView() {

        if let view = UINib(nibName: "DetailFoodView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = false
        //plistから読み出し処理
        image1ImageView.image = UIImage(named:"\(key!)_1")
        image2ImageView.image = UIImage(named: "\(key!)_2")
        image3ImageView.image = UIImage(named: "\(key!)_3")
        
        food_name_Label.text = getFoodDic["food_name"] as? String
        areaLabel.text = "発祥地域 \(getFoodDic["area"] as! String)"
        header1Label.text = getFoodDic["header1"] as? String
        header2Label.text = getFoodDic["header2"] as? String
        header3Label.text = getFoodDic["header3"] as? String
        
        header4Label.attributedText = NSAttributedString(string: (getFoodDic["header4"] as? String)!, attributes:
            [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
//        header4Label.text = getFoodDic["header4"] as? String

        legend1TextView.text = getFoodDic["legend1"] as? String
        legend2TextView.text = getFoodDic["legend2"] as? String
        legend3TextView.text = getFoodDic["legend3"] as? String

        legend1TextView.sizeToFit()
        legend2TextView.sizeToFit()
        legend3TextView.sizeToFit()
        legend1TextView.sizeThatFits(legend1TextView.contentSize)
        legend2TextView.sizeThatFits(legend2TextView.contentSize)
        legend3TextView.sizeThatFits(legend3TextView.contentSize)

//        header4TextView.text = getFoodDic["header4"] as? String
//        header4TextView.sizeToFit()
//
//        header4TextView.sizeThatFits(header4TextView.contentSize)
//
                print("レジェンド",legend1TextView.frame.height,legend2TextView.frame.height,legend3TextView.frame.height)
        legend1TextView.frame.size.height += 4
        legend2TextView.frame.size.height += 4

        print("レジェンド",legend1TextView.frame.height,legend2TextView.frame.height,legend3TextView.frame.height)
        
        // 各ラベルに代入処理
//        let nextVC = HogeViewController.instantiate() // これだけでStoryboardに紐づいたHogeViewControllerを取得
//        self.present(ViewControllerVC, animated: true, completion: nil) // presentする
//        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tapLinkRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapURL))
        header4Label.addGestureRecognizer(tapLinkRecognizer)
//        tapLinkRecognizer.delegate = self
    }
    
    @IBAction func tabFavorite(_ sender: UIButton) {
        saveFavorite()
    }
    
    @IBAction func tapHeader4(_ sender: UITapGestureRecognizer) {
        tapURL()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    

    @objc func tapURL () {
        let url = NSURL(string: getFoodDic["url"]! as! String)
        UIApplication.shared.openURL(url! as URL)
        
    }
    
    func saveFavorite () {
        //AppDelegateを使う用意をしておく（インスタンス化）
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //エンティティを操作する為のオブジェクト作成
        let viewContext = appDelegate.persistentContainer.viewContext
        //Favoriteエンティティオブジェクトを作成
        let favoriteEntity = NSEntityDescription.entity(forEntityName: "Favorite", in: viewContext)
        
        
        let query:NSFetchRequest<Favorite> = Favorite.fetchRequest()
        
        //値のセット
        let cuisine = getFoodDic["food_name"] as! String
        let country = getFoodDic["country"] as! String
        let id = getFoodDic["id"] as! Int
        
        
        //=== すでにお気に入りに入っているか確認 ===
        let favoritePredicate = NSPredicate(format: "id = %d", id)
        query.predicate = favoritePredicate
        
        do {
            let fetchResults = try viewContext.fetch(query)
            
            if( fetchResults.count == 0 ) {
                //Favoriteエンティティにレコード（行）を挿入する為のオブジェクトを作成
                let newRecord = NSManagedObject(entity: favoriteEntity!, insertInto: viewContext)
                
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
            }
        }catch{
            print(error, #function)
        }
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
