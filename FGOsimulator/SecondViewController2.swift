//
//  SecondViewController2.swift
//  FGOsimulator
//
//  Created by Yasuteru on 2018/07/26.
//  Copyright © 2018年 Yasuteru. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController2: UIViewController ,UICollectionViewDelegate ,UICollectionViewDataSource ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate ,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    var CustomImageCell : CustomCollectionViewCell!
    var Images:[Image] = []
    // 詳細画面で表示されるTask
    var passedEvent: Event?
    var passedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getData()
        myCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        CustomImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventImg", for: indexPath) as! CustomCollectionViewCell
        CustomImageCell.myEventImage.image = readJpgImageInDocument(nameOfImage: Images[indexPath.row].imgname!)
        
        return CustomImageCell
    }
    
    // ＋ボタンを押した時に発動
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        // ピクチャフォルダから貼り付けイメージを選択
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            // UIImagePickerControllerのインスタンス化
            let picker = UIImagePickerController()
            // 使用するソースの設定
            picker.sourceType = .savedPhotosAlbum
            // デリゲートメソッドの設定
            picker.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            // 選択した画像を表示
            present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapSaveButton(_ sender: UIBarButtonItem) {
        // create処理
        // ユニークIDを生成する。
        let pictureId = NSUUID().uuidString
        // AppDelegateのインスタンス化
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let manageContext = appDelegate.persistentContainer.viewContext
        // エンティティ
        let image = NSEntityDescription.entity(forEntityName: "Image", in: manageContext)
        // contextにレコード追加
        let newRecord = NSManagedObject(entity: image!, insertInto: manageContext) as! Image
        // レコードに値の設定
        // newRecord.setValue(pictureId, forKey: "imgname")
        newRecord.imgname = pictureId
        newRecord.event = passedEvent
        do {
            try manageContext.save() // throwはdo catch とセットで使う
            self.getData()
            // TableView再読み込み.
            self.myCollectionView.reloadData()
        } catch {
            print("error:",error) // catchとセットで使う
        }
    }
    
    // フォトライブラリから選択した時にも発動
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        // infoの中から撮影したイメージを取り出し
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // 表示
        CustomImageCell.myEventImage.image = selectedImage
        
        // viewを作成
        // let pasteView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 250, height: 250))
        // self.view.addSubview(pasteView)
        
        // モーダルで表示した撮影モード画面を閉じる
        dismiss(animated: true, completion: nil)
    }
    
    // documentDirectoryはユーザが生成したデータをアプリ内に保存する
    // 他にもtmp,Libray/Cacheなどがある
    func storeJpgImageInDocument(image: UIImage , name: String) {
        let documentDirectory =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) // [String]型
        let dataUrl = URL.init(fileURLWithPath: documentDirectory[0], isDirectory: true) //URL型 Documentpath
        let dataPath = dataUrl.appendingPathComponent(name)
        //URL型 documentへのパス + ファイル名
        // UIImageJPEGRepresentationの後ろは1が最大のクオリティ
        // https://qiita.com/marty-suzuki/items/159b1c5d47fb00c11fda
        let myData = UIImageJPEGRepresentation(image, 1.0)! as NSData // Data?型　→ NSData型
        myData.write(toFile: dataPath.path , atomically: true) // NSData型の変数.write(String型,Bool型)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // CoreDataからデータをfetch
    func getData() {
        // データ保存時と同様にcontextを定義
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            // CoreDataからデータをfetchしてtasksに格納
            let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
            Images = try context.fetch(fetchRequest)
        } catch {
            print("Fetching Failed.")
        }
    }
    
    func readJpgImageInDocument(nameOfImage: String) -> UIImage? {
        let documentDirectory =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) // [String]型
        let dataUrl = URL.init(fileURLWithPath: documentDirectory[0], isDirectory: true)  //URL型 Documentpath
        let dataPath = dataUrl.appendingPathComponent(nameOfImage)
        
        do {
            let myData = try Data(contentsOf: dataPath, options: [])
            let image =  UIImage.init(data: myData)
            return image
        }catch {
            print(error)
            return nil
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
