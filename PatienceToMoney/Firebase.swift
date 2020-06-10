//
//  Firebase.swift
//  PatienceToMoney
//
//  Created by 松山響也 on 2020/06/09.
//  Copyright © 2020 Kyoya Matsuyama. All rights reserved.
//

import Foundation
import Firebase

class Firebase{

    //uidの取得
    let uid = Auth.auth().currentUser?.uid
    //追加時のデータの挿入
    func insertData(title:String,money:Int,description:String,uid:String) {
        let patienceDB = Database.database().reference().child("patiences")
        let patienceInfo = ["title":title,"money":money,"description":description,"uid":uid,] as [String : Any]
        patienceDB.childByAutoId().setValue(patienceInfo)
    }
    //一覧表示時のデータの取得
   
    //編集時のデータの上書き
    
    
    
    
}
