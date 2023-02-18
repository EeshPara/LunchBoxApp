//
//  Coupon.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 1/3/23.
//

import Foundation

class Coupon: ObservableObject, Identifiable{
     
   @Published var name: String
   @Published var restaurantName : String
   @Published var date : String
   @Published var desc : String
   @Published var items : Array<MenuItem>
   @Published var price : Double
   @Published var percentOff: Double
   @Published var percentChance : Double
    var usedAndConfirmed : Bool
    
    init(name: String, date: String, desc: String, items: Array<MenuItem>, price: Double, percentOff: Double, restaurantName: String, percentChance: Double) {
        self.name = name
        self.date = date
        self.desc = desc
        self.items = items
        self.price = price
        self.percentOff = percentOff
        self.restaurantName = restaurantName
        self.percentChance = percentChance
        usedAndConfirmed = false
    }
    init(){
        name = ""
        date = ""
        desc = ""
        items = []
        price =  0.0
        percentOff = 0.0
        restaurantName = ""
        usedAndConfirmed = false
        percentChance = 0
    }
    
    func makeDict()-> Dictionary< String, Any> {
        var couponItems : Array<Dictionary<String,Any>> = []
        for item in items{
            couponItems.append(item.makeDict())
        }
        let dict : Dictionary <String, Any> = ["Name" : name, "Date": date, "Desc": desc, "items": couponItems, "price": price, "PercentOff" : percentOff, "RestaurantName" : restaurantName, "UsedAndConfirmed": usedAndConfirmed, "PercentChance" : percentChance]
        return dict
    }
    
    
    
}
