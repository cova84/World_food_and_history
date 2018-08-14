//
//  FirstViewController.swift
//  Japanese Inn List
//
//  Created by 小林由知 on 2017/11/16.
//  Copyright © 2017年 Yoshitomo Kobatashi. All rights reserved.
//


import UIKit

class FirstViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    //タップされたtopTableViewの配列を格納するメンバ変数
    var contentHotel:[NSDictionary] = []

    //選択されたエリア名を保存するメンバ変数
    var dataList:[NSDictionary] = []
    
    //toDetailセグエ用　plistの配列を保存するメンバ変数
    var selectedDic:NSDictionary!

    
    @IBOutlet weak var topTableView: UITableView!
    
    var area:[(title: String, no:Int, details: [Int], extended: Bool,category:Int)] = []
    
    var country:[(title: String, no:Int, details: [Int], extended: Bool,category:Int)] = []
    
    var food:[(title: String, no:Int, details: [Int], extended: Bool,category:Int)] = []

    //表示専用の配列
    var viewData:[(title: String, no:Int, details: [Int], extended: Bool,category:Int)] = []
    var colorOfCategory1:UIColor!
    var colorOfCategory2:UIColor!
    var colorOfCategory3:UIColor!

    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nibName: ""はswiftのタイトル
        let cellHeight:CGFloat = 30.0
        self.myTableView.register(UINib(nibName: "AreaCustomCell", bundle: nil), forCellReuseIdentifier: "TopAreaCell")
        self.myTableView.estimatedRowHeight = cellHeight
//        self.myTableView.rowHeight = UITableViewAutomaticDimension
        
        self.myTableView.register(UINib(nibName: "CountryCustomCell", bundle: nil), forCellReuseIdentifier: "TopCountryCell")
//        self.myTableView.estimatedRowHeight = cellHeight
//        self.myTableView.rowHeight = UITableViewAutomaticDimension
        
        self.myTableView.register(UINib(nibName: "CuisineCustomCell", bundle: nil), forCellReuseIdentifier: "TopHotelCell")
//        self.myTableView.estimatedRowHeight = cellHeight
//        self.myTableView.rowHeight = UITableViewAutomaticDimension
        
        colorOfCategory1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        colorOfCategory2 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.60)
        colorOfCategory3 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.45)
        
        //リストデータの作成
        createData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //文字列を表示するセルの取得（セルの再利用）
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //pNumberでスイッチ。Noを受け取り色分けする？^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        //開閉状態を一旦別変数へ退避
        let previousViewData = viewData
        let pNumber = indexPath.row
        
        switch previousViewData[pNumber].category {
        case 1 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopAreaCell", for: indexPath) as! areaCustomCell
            cell.varticalLabel.text = viewData[indexPath.row].title
            cell.tag = viewData[indexPath.row].no
            myTableView.separatorColor = UIColor.white
            
           
            
            cell.background.backgroundColor = colorOfCategory1
            
            return cell
            
            
        case 2 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopCountryCell", for: indexPath) as! countryCustomCell
            cell.varticalLabel.text = viewData[indexPath.row].title
            cell.tag = viewData[indexPath.row].no
            myTableView.separatorColor = UIColor.white
            
            
            cell.background.backgroundColor = colorOfCategory2

            
            return cell
            
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopHotelCell", for: indexPath) as! CuisineCustomCell
            cell.varticalLabel.text = viewData[indexPath.row].title
            let id = viewData[indexPath.row].no
            cell.foodImageView.image = UIImage(named:"\(viewData[indexPath.row].no)_01")
            let dic = readPlist(key: "\(id)")
            cell.detailLabel.text = dic!["legend1"] as? String
            cell.tag = viewData[indexPath.row].no
            myTableView.separatorColor = UIColor.white
            
            cell.background.backgroundColor = colorOfCategory3

            return cell
        }
    }
    
    
    /// MARK: UITableViewDelegate
    //セルがタップされた時のイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if viewData[indexPath.row].category == 3{
            //宿の場合、別画面に遷移するなどの処理を記載する
            print(viewData[indexPath.row].title)
            print(viewData[indexPath.row].no)
            
            //indexPathから読出ししたデータを取り出し
            let id = viewData[indexPath.row].no
            
            let key:String = "\(id)"
            
            // 0の時はダミーなのでセグエ発動しなくて良い
            if id != 0 {
                //Key(ディクショナリー型で)Plistから取り出し
                let dic = readPlist(key:key)
                selectedDic = dic!


                //セグエのidentifierを指定して、画面移動
                performSegue(withIdentifier: "toDetail", sender: self)
            }
            
            
        }else{
            //開閉処理
            if viewData[indexPath.row].extended {
                //閉じる
                viewData[indexPath.row].extended = false
                let changeRowNum = createViewData(indexNumber: indexPath.row)
                
                self.toContract(tableView, indexPath: indexPath,changeRowNum: changeRowNum)
            }else{
                //開く
                viewData[indexPath.row].extended = true
                
                let changeRowNum = createViewData(indexNumber: indexPath.row)
                
                self.toExpand(tableView, indexPath: indexPath,changeRowNum: changeRowNum)
            }
            
        }
        
        
    }
    
    // tap後、segue発動
    override func prepare(for segue:UIStoryboardSegue, sender:Any?){
        //次の画面のインスタンスを取得
        let dvc = segue.destination as! DetailFoodView
        //次の画面のプロパティにタップされたセルのkeyを渡す
        dvc.getFoodDic = self.selectedDic

    }
    
    
    /// close details.
    ///
    /// - Parameter tableView: self.tableView
    /// - Parameter indexPath: NSIndexPath
    fileprivate func toContract(_ tableView: UITableView, indexPath: IndexPath, changeRowNum:Int) {
        let startRow = indexPath.row + 1
        let endRow = indexPath.row + changeRowNum + 1
        
        var indexPaths: [IndexPath] = []
        for i in startRow ..< endRow {
            indexPaths.append(IndexPath(row: i , section:indexPath.section))
        }
        
        tableView.deleteRows(at: indexPaths,
                             with: UITableViewRowAnimation.fade)
    }
    
    /// open details.
    ///
    /// - Parameter tableView: self.tableView
    /// - Parameter indexPath: NSIndexPath
    fileprivate func toExpand(_ tableView: UITableView, indexPath: IndexPath, changeRowNum:Int) {
        let startRow = indexPath.row + 1
        let endRow = indexPath.row + changeRowNum + 1
        
        var indexPaths: [IndexPath] = []
        for i in startRow ..< endRow {
            indexPaths.append(IndexPath(row: i, section:indexPath.section))
        }
        
        tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.fade)
        
        // scroll to the selected cell.
        tableView.scrollToRow(at: IndexPath(
            row:indexPath.row, section:indexPath.section),
                              at: UITableViewScrollPosition.top, animated: true)
    }
    
    
    func createViewData(indexNumber:Int)->Int{
        
        var changeNum = 0
        //開閉状態を一旦別変数へ退避
        let previousViewData = viewData
        
        viewData = []
        
        var pNumber = 0
        var skipNumber = 0
        for data in previousViewData{
            if pNumber < indexNumber {
                viewData.append(data)
            }
            
            if indexNumber == pNumber {
                viewData.append(data)
                if previousViewData[pNumber].extended{
                    //開く（子データ追加）
                    let ids = previousViewData[pNumber].details
                    
                    //エリアの場合は紐づく国を追加
                    if previousViewData[pNumber].category == 1 {
                        
                        for deach in ids{
                            for ceach in country{
                                if ceach.no == deach{
                                    viewData.append((title: ceach.title,no: ceach.no,details:ceach.details,extended:false,category:2))
                                    changeNum += 1
                                }
                            }
                            
                        }
                        
                    }
                    
                    //国の場合は紐づく宿を追加
                    if previousViewData[pNumber].category == 2 {
                        
                        for deach in ids{
                            for ieach in food{
                                if ieach.no == deach{
                                    viewData.append((title: ieach.title,no: ieach.no,details:ieach.details,extended:false,category:3))
                                    changeNum += 1
                                }
                            }
                            
                        }
                        
                        
                    }
                    
                }else{
                    //閉じる（子データの削除）
                    //スキップするデータ数を計算
                    var sindex = 0
                    for sdata in previousViewData{
                        if sindex > pNumber {
                            if sdata.category > previousViewData[pNumber].category{
                                skipNumber += 1
                            }else{
                                break
                            }
                            
                        }
                        sindex += 1
                    }
                    
                    changeNum = skipNumber
                    
                    
                }
            }
            
            print(skipNumber)
            
            
            if pNumber > indexNumber {
                if pNumber > indexNumber + skipNumber{
                    viewData.append(data)
                }
            }
            
            pNumber += 1
        }
        
        
        return changeNum
    }
    
    
    
    
    func createData(){
        
        createAreaArray()
        
        createCountryArray()
        

        
        //plistの読み込み--------------------------------------------------------
        //ファイルパスを取得（エリア名が格納されているプロパティリスト）
        let path2 = Bundle.main.path(forResource: "food_list_Detail", ofType: "plist")
        //ファイルの内容を読み込んでディクショナリー型に格納
        let foodListDic = NSDictionary(contentsOfFile: path2!)



        for (_,data) in foodListDic! {
            
            let dic = data as! NSDictionary
            let foodNameDic = dic["food_name"]! as! String
            let idDic = dic["id"]! as! Int
            //let idNum = Int(atof(idDic))
            
            food.append((
                title: "\(foodNameDic)"
                , no: idDic
                , details: []
                , extended: false
                , category: 3
            ))
            
            
            
        }
        //最初はエリアだけを表示するためエリアのみを表示用の配列に保存しておく
        viewData = area
        
    }
    
    func createAreaArray() {
        area.append((title: "北アメリカ",no:    1    , details: [    110,    100,                                                        ], extended: false,category:1))
        area.append((title: "中南米",no:    2    , details: [    200,    210,    220,    230,    240,    250,    260,                                    ], extended: false,category:1))
        area.append((title: "アジア（北〜東〜東南アジア）",no:    3    , details: [    700,    710,    800,    810,    820,    830,                                        ], extended: false,category:1))
        area.append((title: "アジア（中央〜南〜西アジア）",no:    4    , details: [    900,    1100,                                                        ], extended: false,category:1))
        //area.append((title: "アジア（予備）",no:    5    , details: [                                                                ], extended: false,category:1))
        area.append((title: "ヨーロッパ",no:    6    , details: [    300,    310,    330,    340,    350,    360,    370,    381,    391,    400,    410,                    ], extended: false,category:1))
        area.append((title: "アフリカ",no:    7    , details: [    500,    510,                                                        ], extended: false,category:1))
        area.append((title: "オーストラリア・オセアニア",no:    8    , details: [    1300,    1310,                                                        ], extended: false,category:1))

    }
    
    func createCountryArray() {
        country.append((title: "アメリカ",no:    110    , details: [     ], extended: false,category:2))
        country.append((title: "カナダ",no:    100    , details: [    101,    102,    103,    105,    106,    107,    108,                                                    ], extended: false,category:2))
        country.append((title: "ジャマイカ",no:    200    , details: [    201,    202,                                                                            ], extended: false,category:2))
        country.append((title: "グアテマラ",no:    210    , details: [    211,    212,    213,    214,                                                                    ], extended: false,category:2))
        country.append((title: "パラグアイ",no:    220    , details: [    221,    222,                                                                            ], extended: false,category:2))
        country.append((title: "チリ",no:    230    , details: [    231,                                                                                ], extended: false,category:2))
        country.append((title: "エクアドル",no:    240    , details: [    241                                                                                ], extended: false,category:2))
        country.append((title: "ブラジル",no:    250    , details: [    251                                                                                ], extended: false,category:2))
        country.append((title: "メキシコ",no:    260    , details: [    261,    262,    263,    264,                                                                    ], extended: false,category:2))
        country.append((title: "フランス",no:    300    , details: [    301,    302,                                                                            ], extended: false,category:2))
        country.append((title: "イギリス",no:    310    , details: [    311,    312,    313,    314,    315,    316,    317,    318,    319,    320,    321,    322,    323,    324,                            ], extended: false,category:2))
        country.append((title: "スペイン",no:    330    , details: [    330,    331,    332,    333,    391,    392,                                                            ], extended: false,category:2))
        country.append((title: "ドイツ",no:    340    , details: [    341,    342,                                                                            ], extended: false,category:2))
        country.append((title: "スイス",no:    350    , details: [    351                                                                                ], extended: false,category:2))
        country.append((title: "ポーランド",no:    360    , details: [    361                                                                                ], extended: false,category:2))
        country.append((title: "ハンガリー",no:    370    , details: [    371,    372,    373,                                                                        ], extended: false,category:2))
        country.append((title: "オランダ",no:    381    , details: [    381                                                                                ], extended: false,category:2))
        country.append((title: "クロアチア",no:    400    , details: [    401,    402,                                                                            ], extended: false,category:2))
        country.append((title: "イタリア",no:    410    , details: [    411,    412,    413,    414,    415,    416,    417,                                                        ], extended: false,category:2))
        country.append((title: "タンザニア",no:    500    , details: [    501,                                                                                ], extended: false,category:2))
        country.append((title: "エジプト",no:    510    , details: [    511,                                                                                ], extended: false,category:2))
        country.append((title: "中国",no:    700    , details: [    702,                                                                                ], extended: false,category:2))
        country.append((title: "台湾",no:    710    , details: [    711,                                                                                ], extended: false,category:2))
        country.append((title: "カンボジア",no:    800    , details: [    801,    802,                                                                            ], extended: false,category:2))
        country.append((title: "タイ",no:    810    , details: [    811,    812,    813,                                                                        ], extended: false,category:2))
        country.append((title: "フィリピン",no:    820    , details: [    821,    822,    823,                                                                        ], extended: false,category:2))
        country.append((title: "インドネシア",no:    830    , details: [    831,    832,    833,                                                                        ], extended: false,category:2))
        country.append((title: "ネパール",no:    900    , details: [    901,    902,                                                                            ], extended: false,category:2))
        country.append((title: "キルギス",no:    1100    , details: [    1101,                                                                                ], extended: false,category:2))
        country.append((title: "オーストラリア",no:    1300    , details: [    1301,                                                                                ], extended: false,category:2))
        country.append((title: "ニュージーランド",no:    1310    , details: [     1314,                                                                    ], extended: false,category:2))

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
