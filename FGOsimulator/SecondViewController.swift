//
//  SecondViewController.swift
//  FGOsimulator
//
//  Created by Yasuteru on 2018/07/26.
//  Copyright © 2018年 Yasuteru. All rights reserved.
//

import UIKit
import CoreData
var events:[Event] = []

class SecondViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    
    @IBOutlet weak var myTableView2: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView2.delegate = self
        myTableView2.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        getData()
        // taskTableViewを再読み込みする
        myTableView2.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventLabel", for: indexPath)
        cell.textLabel?.text = events[indexPath.row].name
        return cell
    }
    var selectedTask:Event?
    var selectedIndex:Int?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTask = events[indexPath.row]
        selectedIndex = indexPath.row
        print(selectedIndex)
        performSegue(withIdentifier: "segue2", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // coredataの削除処理
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let manageContext = appDelegate.persistentContainer.viewContext
            let fetchRequest:NSFetchRequest<Event> = Event.fetchRequest()
            let predicate = NSPredicate(format: "%K = %@", "name", (events[indexPath.row].name)!)
            fetchRequest.predicate = predicate
            do {
                let fetchResults = try manageContext.fetch(fetchRequest)
                for result: AnyObject in fetchResults {
                    let record = result as! NSManagedObject
                    manageContext.delete(record)
                }
                try manageContext.save()
            } catch {
            }
            events.remove(at: indexPath.row)
            myTableView2.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIBarButtonItem) {
        showTextInputAlert()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let svc2:SecondViewController2 = segue.destination as! SecondViewController2
        svc2.passedEvent = selectedTask
        svc2.passedIndex = selectedIndex
        
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
            let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
            events = try context.fetch(fetchRequest)
        } catch {
            print("Fetching Failed.")
        }
    }
    
    // テキストフィールド付きアラート表示
    func showTextInputAlert() {
        let alert = UIAlertController(title: "イベントを入力してください", message: "", preferredStyle: .alert)
        // OKボタンの設定
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            // OKを押した時入力されていたテキストを表示
            if let textFields = alert.textFields {
                // アラートに含まれるすべてのテキストフィールドを調べる
                for textField in textFields {
                    // print(textField.text!)
                    // create処理
                    // AppDelegateのインスタンス化
                    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    let manageContext = appDelegate.persistentContainer.viewContext
                    // エンティティ
                    let event = NSEntityDescription.entity(forEntityName: "Event", in: manageContext)
                    // contextにレコード追加
                    let newRecord = NSManagedObject(entity: event!, insertInto: manageContext)
                    // レコードに値の設定
                    newRecord.setValue(textField.text!, forKey: "name")
                    do {
                        try manageContext.save() // throwはdo catch とセットで使う
                        self.getData()
                        // TableView再読み込み.
                        self.myTableView2.reloadData()
                    } catch {
                        print("error:",error) // catchとセットで使う
                    }
                }
            }
        })
        alert.addAction(okAction)
        // キャンセルボタンの設定
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        // テキストフィールドを追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "空白は避け固有の名前をつけてください"
        })
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func exitView(segue:UIStoryboardSegue) {}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
