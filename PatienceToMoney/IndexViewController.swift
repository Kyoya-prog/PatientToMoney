//
//  IndexViewController.swift
//  PatienceToMoney
//
//  Created by 松山響也 on 2020/06/09.
//  Copyright © 2020 Kyoya Matsuyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class IndexViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    let db = Firestore.firestore()
    var titleString = String()
    var moneyString = String()
    var descriptionString = String()
    var documentIdString = String()
    var patiencesArray = [Patiences]()
    var documentIdArray:[Any] = []
    let uid = Auth.auth().currentUser!.uid
    
    @IBOutlet weak var sumMoneyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sumMoney = UserDefaults.standard.object(forKey: "sumMoney"){
            sumMoneyLabel.text = sumMoney as? String
        }else{
            sumMoneyLabel.text = "0"
        }
        fetchData(uid: uid)
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let sumMoney = UserDefaults.standard.object(forKey: "sumMoney"){
            sumMoneyLabel.text = sumMoney as? String
        }else{
            sumMoneyLabel.text = "0"
        }
        tableView.reloadData()
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patiencesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let titleCell = cell?.viewWithTag(1) as! UILabel
        let moneyCell = cell?.viewWithTag(2) as! UILabel
        let documentId = documentIdArray[indexPath.row]
        let description = patiencesArray[indexPath.row].description
        titleCell.text = patiencesArray[indexPath.row].title
        moneyCell.text =  patiencesArray[indexPath.row].money
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        titleString = patiencesArray[indexPath.row].title
        moneyString = patiencesArray[indexPath.row].money
        documentIdString = documentIdArray[indexPath.row] as! String
        descriptionString = patiencesArray[indexPath.row].description
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! DetailViewController
        detailVC.titleString = titleString
        detailVC.descriptionString = descriptionString
        detailVC.moneyString = moneyString
        print(detailVC.moneyString)
        detailVC.sumMoneyString = sumMoneyLabel.text!
        detailVC.documentIdString = documentIdString
    }

    func fetchData(uid:String){
        let docRef = db.collection("patiences")
        docRef.whereField("uid", isEqualTo: uid).getDocuments { (QuerySnapshot, err) in
            for document in QuerySnapshot!.documents {
                self.documentIdArray.append(document.documentID)
                let title = document.data()["title"]
                let money = document.data()["money"]
                let description = document.data()["description"]
                self.patiencesArray.append(Patiences(title: title as! String, money: money as! String, description: description as! String))
                }
            self.tableView.reloadData()
        }
       }
    
    @IBAction func create(_ sender: Any) {
        let inputVC = self.storyboard?.instantiateViewController(withIdentifier: "input")
        present(inputVC!, animated: true, completion: nil)
    }
    
    @IBAction func lookHistory(_ sender: Any) {
        let historyVC = self.storyboard?.instantiateViewController(identifier: "history") as! PatiencesHistoryViewController
        historyVC.modalPresentationStyle = .fullScreen
        present(historyVC, animated: true, completion: nil)
    }
}
