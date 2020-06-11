//
//  PatiencesHistory.swift
//  PatienceToMoney
//
//  Created by 松山響也 on 2020/06/12.
//  Copyright © 2020 Kyoya Matsuyama. All rights reserved.
//

import Foundation

class PatienceHistory{
    
    var title = String()
    var money = String()
    var created_at = String()
    var uid = String()
    
    init(title:String,money:String,created_at:String,uid:String){
        self.title = title
        self.money = money
        self.created_at = created_at
    }

    
    
}
