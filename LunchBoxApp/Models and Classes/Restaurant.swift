//
//  Restaurant.swift
//  LunchBox
//
//  Created by Rama Parasuramuni on 11/2/22.
//

import Foundation
class Restaurant{
    var ResterauntName: String
    var RestaurantCollege: String
    var RestaurantDisc : String
    var MenuItems: Array<MenuItem>
    var SubscriptionPacks: Array<SubPack>
    var NumOrders: Int
    var NumOrdersThisWeek: Int
    var AmountMade: Double
    var AmountMadeThisWeek: Double
    var TotalAmountOwed: Double
    var AmountOwedThisWeek : Double
    var DailyMenu : Bool
    var DailyMenuDisc : Double
    var HappyHourTimes: String
    var HappyHourDisc: Double
    //Make sure how to actually do this
    var ResterauntImage:String
    init(ResterauntName: String,RestaurantDisc:String, RestaurantCollege: String, MenuItems: Array<MenuItem>, SubscriptionPacks: Array<SubPack>, DailyMenuDisc: Double, HappyHourTimes: String, HappyHourDisc: Double, ResterauntImage: String) {
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
    }
    
    func makeDict()->[ String: Any]{
        
        
    }

}
