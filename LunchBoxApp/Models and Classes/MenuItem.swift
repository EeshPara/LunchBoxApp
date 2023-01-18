//
//  MenuItem.swift
//  LunchBox
//
//  Created by Rama Parasuramuni on 11/2/22.
//

import Foundation

class MenuItem : Identifiable, ObservableObject, Hashable{
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    func hash(into hasher: inout Hasher) {
        
    }
    
    @Published var Itemname : String
    var Itemprice : Double
    var ItemDisc : String
    var type: String
    var discountOfTheDay : Bool
    var itemRestaurant : String
    var itemImage : String
    init(Itemname: String, Itemprice: Double, ItemDisc: String, type:String, discountofTheDay: Bool, itemRestaurant: String) {
        self.Itemname = Itemname
        self.Itemprice = Itemprice
        self.ItemDisc = ItemDisc
        self.type = type
        self.discountOfTheDay = discountofTheDay
        self.itemRestaurant = itemRestaurant
        itemImage = ""
    }
    init(){
        Itemname = ""
        Itemprice = 0.0
        ItemDisc = ""
        type = ""
        discountOfTheDay = false
        itemRestaurant = ""
        itemImage = ""
    }
    
    func makeDict()->[ String: Any]{
        var menuItemDict : Dictionary<String, Any>
        menuItemDict = [:]
        menuItemDict["Itemname"] = Itemname
        menuItemDict["ItemPrice"] = Itemprice
        menuItemDict["ItemDisc"] = ItemDisc
        menuItemDict["DiscountOfTheDay"] = discountOfTheDay
        menuItemDict["ItemType"] = type
        menuItemDict["ItemRestaurant"] = itemRestaurant
        print(itemImage)
        menuItemDict["ItemImage"] = itemImage
        return menuItemDict
    }
}

class MenuItemContainer : ObservableObject{
    @Published var MenuItems : Array<MenuItem> = []
}
