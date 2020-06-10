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

class IndexViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DetailViewControllerDelegate {

    let db = Firestore.firestore()
    var sumMoneyString = "0"
    var titleString = String()
    var money = Int()
    var descriptionString = String()
    var documentIdString = String()
    var patientsArray = [Patiences]()
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
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchData(uid: uid)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let titleCell = cell?.viewWithTag(1) as! UILabel
        let moneyCell = cell?.viewWithTag(2) as! UILabel
        let documentId = documentIdArray[indexPath.row]
        let description = patientsArray[indexPath.row].description
        titleCell.text = patientsArray[indexPath.row].title
        moneyCell.text =  String(patientsArray[indexPath.row].money)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        titleString = patientsArray[indexPath.row].title
        money = patientsArray[indexPath.row].money
        documentIdString = documentIdArray[indexPath.row] as! String
        descriptionString = patientsArray[indexPath.row].description
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! DetailViewController
        detailVC.delegate = self
        detailVC.titleString = titleString
        detailVC.descriptionString = descriptionString
        detailVC.moneyString = String(money)
        detailVC.sumMoneyString = sumMoneyLabel.text!
        detailVC.documentIdString = documentIdString
    }
    
    
    func fetchData(uid:String){
        let docRef = db.collection("patients")
        docRef.whereField("uid", isEqualTo: uid).getDocuments { (QuerySnapshot, err) in
            for document in QuerySnapshot!.documents {
                self.documentIdArray.append(document.documentID)
                let title = document.data()["title"]
                let money = document.data()["money"]
                let description = document.data()["description"]
                self.patientsArray.append(Patiences(title: title as! String, money: money as! Int, description: description as! String))
            }
            
            self.tableView.reloadData()
        }
       }
    
    func didAdded(sumMoney: Int) {
        sumMoneyLabel.text = String(sumMoney)
        UserDefaults.standard.set(String(sumMoney), forKey: "sumMoney")
    }
    
    @IBAction func create(_ sender: Any) {
        let inputVC = self.storyboard?.instantiateViewController(withIdentifier: "input")
        present(inputVC!, animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
