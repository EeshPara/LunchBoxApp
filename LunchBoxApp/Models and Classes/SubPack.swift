//
//  SubPack.swift
//  LunchBox
//
//  Created by Rama Parasuramuni on 11/2/22.
//

import Foundation
class SubPack{
    var packName: String
    var packPrice: Double
    var amountSaved: Double
    var pack: Array<MenuItem>
    init(packName: String, packPrice: Double, amountSaved: Double, pack: Array<MenuItem>) {
        self.packName = packName
        self.packPrice = packPrice
        self.amountSaved = amountSaved
        self.pack = pack
        
        for item in pack{
            item.Itemprice = 0
        }
    }
}
