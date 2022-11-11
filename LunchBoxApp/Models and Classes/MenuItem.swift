//
//  MenuItem.swift
//  LunchBox
//
//  Created by Rama Parasuramuni on 11/2/22.
//

import Foundation

class MenuItem{
    var Itemname : String
    var Itemprice : Double
    var ItemDisc : String
    init(Itemname: String, Itemprice: Double, ItemDisc: String) {
        self.Itemname = Itemname
        self.Itemprice = Itemprice
        self.ItemDisc = ItemDisc
    }
}
