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
    var NumOrders = 0.0
    var NumOrdersThisWeek = 0.0
    var AmountMade = 0.0
    var AmountMadeThisWeek = 0.0
    var TotalAmountOwed = 0.0
    var AmountOwedThisWeek = 0.0
    var dailyDiscount = 0.0;
   // var DailyMenu = false
   // var DailyMenuDisc = 0.0
   // var HappyHourTimes = ""
   // var HappyHourDisc = 0.0
    //Make sure how to actually do this
    var ResterauntImage = ""
   /* init(ResterauntName: String,RestaurantDisc:String, RestaurantCollege: String, MenuItems: Array<MenuItem>, SubscriptionPacks: Array<SubPack>, DailyMenuDisc: Double, HappyHourTimes: String, HappyHourDisc: Double, ResterauntImage: String) {
        self.ResterauntName = ResterauntName
        self.RestaurantDisc = RestaurantDisc
        self.RestaurantCollege = RestaurantCollege
        self.MenuItems = MenuItems
        self.SubscriptionPacks = SubscriptionPacks
        self.NumOrders = 0
        self.NumOrdersThisWeek = 0
        self.AmountMade = 0
        self.AmountMadeThisWeek = 0
        self.TotalAmountOwed = 0
        self.AmountOwedThisWeek = 0
        self.DailyMenu = false
        self.DailyMenuDisc = DailyMenuDisc
        self.HappyHourTimes = HappyHourTimes
        self.HappyHourDisc = HappyHourDisc
        self.ResterauntImage = ResterauntImage
    }*/
    
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
        
        return restaurantDict
        
    }

}
