//
//  ReusableMethods.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 11/26/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class reusableMethods{
    
    func restDictToRestObject(dict: Dictionary<String,Any>)-> Restaurant{
        var  fin = Restaurant()
        
        fin.ResterauntName = dict["RestaurantName"] as! String
        fin.RestaurantDisc = dict["RestaurantDisc"] as! String
        fin.RestaurantCollege = dict["RestaurantCollege"] as! String
       
        var menuDict : Array <Dictionary<String,Any>> = dict["Menu"] as! Array<Dictionary<String, Any>>
        var subPacksDict : Array <Dictionary<String,Any>> = dict["SubPacks"] as! Array<Dictionary<String, Any>>
        for dictTracker in menuDict{
            fin.MenuItems.append(menuDictToMenuItemObject(dict: dictTracker))
        }
        
        for dictTracker in subPacksDict{
            fin.SubscriptionPacks.append(subPackDicttTosubpackObject(dict: dictTracker))
        }
        fin.ResterauntImage = dict["RestaurantImage"] as! String
        fin.dailyDiscount = dict["DailyDiscount"] as! Double
        fin.RestaurantUID =  dict["RestaurantUID"] as! String
        return fin
        
    }
    
    func menuDictToMenuItemObject(dict: Dictionary<String,Any>)-> MenuItem{
   
        var fin = MenuItem()
        fin.Itemname = dict["Itemname"] as! String
        fin.Itemprice =  dict["ItemPrice"] as! Double
        fin.ItemDisc = dict["ItemDisc"] as! String
        fin.type = dict["ItemType"] as! String
        fin.itemRestaurant = dict["ItemRestaurant"] as! String
        fin.percentOff = dict["PercentOff"] as! Double
        fin.discountOfTheDay = false//dict["savings"] as! Double
        if(dict["ItemImage"] != nil){
           fin.itemImage = dict["ItemImage"] as! String
        }
        
        return fin
        
    }
    func subPackDicttTosubpackObject(dict: Dictionary<String,Any>)-> SubPack{
        var fin = SubPack()
        fin.packName = dict["PackName"] as! String
        fin.packPrice = dict["PackPrice"] as! Double
        fin.amountSaved = dict["AmountSaved"]as! Double
        fin.packTypes = dict["PackItems"] as! Array<String>
        
        return fin
        
    }
    
    func userDictToObject (dict: Dictionary<String,Any>) -> User{
        var fin = User()
        fin.UserName = dict["Username"] as! String
        fin.Email =   dict["Email"] as! String
        fin.college =  dict["College"] as! String
        fin.UID = dict["UID"] as! String
        return fin
    }
     
    func couponDictToObject (dict: Dictionary<String,Any>) -> Coupon{
        var fin = Coupon()
        fin.name = dict["Name"] as! String
        fin.date = dict["Date"] as! String
        fin.desc = dict["Desc"] as! String
        fin.usedAndConfirmed = dict["UsedAndConfirmed"] as! Bool
        fin.price = dict["price"] as! Double
        fin.percentOff = dict["PercentOff"] as! Double
        fin.percentChance = dict["PercentChance"] as! Double
        var menuDict : Array <Dictionary<String,Any>> = dict["items"] as! Array<Dictionary<String, Any>>
        for dictTracker in menuDict{
            fin.items.append(menuDictToMenuItemObject(dict: dictTracker))
        }
        return fin
    }
    
    
    
    
}
