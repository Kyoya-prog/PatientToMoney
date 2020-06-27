//
//  PatiencesHistoryViewController.swift
//  PatienceToMoney
//
//  Created by 松山響也 on 2020/06/12.
//  Copyright © 2020 Kyoya Matsuyama. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import MBCircularProgressBar
protocol DidDeletePatienceDelegate{
    
}

class PatiencesHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var activityIndicatorView = UIActivityIndicatorView()
    var resultMoney = Int()
    var titleString = String()
    var moneyString = String()
    var created_atString = String()
    var documentIdOfPatiencesHistoryArray:[Any] = []
    var uid = Auth.auth().currentUser!.uid
    var patiencesHistoryArray = [PatienceHistory]()
    var sumMoney = Int()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sumMoneyLabel: UILabel!
    @IBOutlet weak var progressBarView: MBCircularProgressBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.layer.cornerRadius = 50.0
        
        fetchData(uid: uid)
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .large
        activityIndicatorView.color = .purple
        if patiencesHistoryArray.count > 0{
        view.addSubview(activityIndicatorView)
        }
        sumMoney = Int(UserDefaults.standard.object(forKey: "sumMoney") as! String)!
        progressBarView.maxValue = CGFloat(100000)
        progressBarView.value = CGFloat(sumMoney)
        sumMoneyLabel.text = UserDefaults.standard.object(forKey: "sumMoney") as! String
        progressBarView.progressLineWidth = 20
        progressBarView.emptyLineWidth = 20
        progressBarView.progressCapType = 2
        progressBarView.progressAngle = 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patiencesHistoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let titleCell = cell?.viewWithTag(1) as! UILabel
        let moneyCell = cell?.viewWithTag(2) as! UILabel
        let created_atCell = cell?.viewWithTag(3) as! UILabel
        titleCell.text = patiencesHistoryArray[indexPath.row].title
        moneyCell.text = patiencesHistoryArray[indexPath.row].money
        created_atCell.text = "\(patiencesHistoryArray[indexPath.row].created_at)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let documentId = self.documentIdOfPatiencesHistoryArray[indexPath.row]
            let db = Firestore.firestore()
            db.collection("patiencesHistory").document(documentId as! String).delete { (error) in
                if error != nil{
                    print(error)
                }else{
                    self.didDelete(money: self.patiencesHistoryArray[indexPath.row].money)
                    self.patiencesHistoryArray.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }


    
    @IBAction func backToIndex(_ sender: Any) {
        let indexVC = self.storyboard?.instantiateViewController(identifier: "index") as! IndexViewController
        indexVC.modalPresentationStyle = .fullScreen
        present(indexVC, animated: true, completion: nil)
        
    }
    
    func didDelete(money:String){
        let sumMoney = UserDefaults.standard.object(forKey: "sumMoney") as! NSString
        resultMoney = Int(sumMoney as String)!
        let minusMoney = Int(money)
        resultMoney = resultMoney - minusMoney!
        UserDefaults.standard.set("\(resultMoney)", forKey: "sumMoney")
        sumMoneyLabel.text = UserDefaults.standard.object(forKey: "sumMoney") as! String
        let sumMoneyInt = Int(sumMoneyLabel.text!)
        progressBarView.value = CGFloat(sumMoneyInt!)
       }
    
    func fetchData(uid:String){
        activityIndicatorView.startAnimating()
        let db = Firestore.firestore()
        let docRef = db.collection("patiencesHistory")
        docRef.whereField("uid", isEqualTo:uid).getDocuments { (QuerySnapshot, err) in
                for document in QuerySnapshot!.documents{
                 self.documentIdOfPatiencesHistoryArray.append(document.documentID)
                 let title = document.data()["title"]
                 let money = document.data()["money"]
                 let created_at = document.data()["created_at"] as! String
                    self.patiencesHistoryArray.append(PatienceHistory(title: title as! String, money: money as! String, created_at: created_at, uid: self.uid))
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                    self.activityIndicatorView.stopAnimating()
            }
        }
    }
}
