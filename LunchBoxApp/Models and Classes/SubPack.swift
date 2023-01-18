//
//  SubPack.swift
//  LunchBox
//
//  Created by Rama Parasuramuni on 11/2/22.
//

import Foundation
class SubPack : Identifiable{
    var packName: String
    var packPrice: Double
    var amountSaved: Double
    var packTypes: Array<String>
    init(packName: String, packPrice: Double, amountSaved: Double, packTypes: Array<String>) {
        self.packName = packName
        self.packPrice = packPrice
        self.amountSaved = amountSaved
        self.packTypes = packTypes
        
    }
    init(){
        packName = ""
        packPrice = 0.0
        amountSaved = 0.0
        packTypes = [""]
    }
    func makeDict()->[ String: Any]{
        var SubPackDict : Dictionary<String, Any>
        SubPackDict = [:]
        SubPackDict["PackName"] = packName
        SubPackDict["PackPrice"] = packPrice
        SubPackDict["AmountSaved"] = amountSaved
        SubPackDict["PackItems"] = packTypes
        return SubPackDict
    }
    
    
}
