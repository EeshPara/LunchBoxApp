//
//  Restaurant.swift
//  LunchBox
//
//  Created by Rama Parasuramuni on 11/2/22.
//

import Foundation
class Restaurant : ObservableObject, Identifiable, Hashable{
     static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
     
    func hash(into hasher: inout Hasher) {
        
    }
    
    @Published  var ResterauntName = ""
    @Published var RestaurantCollege = ""
    @Published var RestaurantDisc = ""
    @Published var MenuItems : Array<MenuItem> = []
    @Published var SubscriptionPacks : Array<SubPack> = []
    @Published var ItemTypes = [""]
    var RestaurantUID : String = UUID().uuidString
    var NumOrders = 0.0
    var NumOrdersThisWeek = 0.0
    var AmountMade = 0.0
    var AmountMadeThisWeek = 0.0
    var TotalAmountOwed = 0.0
    var AmountOwedThisWeek = 0.0
    var dailyDiscount = 0.0;
    var ResterauntImage = ""

    
    func makeDict()->[ String: Any]{
        var restaurantDict : Dictionary<String,Any>
        restaurantDict = [:]
        restaurantDict = ["RestaurantName":ResterauntName, "RestaurantCollege":RestaurantCollege, "RestaurantDisc": RestaurantDisc]
       
        restaurantDict ["DailyDiscount"] = dailyDiscount
        var  menuDicts : [[String : Any]] = []
        for MenuItemTracker in MenuItems {
            menuDicts.append(MenuItemTracker.makeDict())
        }
        restaurantDict["Menu"] = menuDicts
        var  SubPackDicts : [[String : Any]] = []
        for SubPackTracker in SubscriptionPacks {
            SubPackDicts.append(SubPackTracker.makeDict())
        }
        restaurantDict["SubPacks"] = SubPackDicts
        restaurantDict["RestaurantImage"] = ResterauntImage
        restaurantDict["RestaurantUID"] = RestaurantUID
        
        return restaurantDict
        
    }

}
