//
//  GenerateCouponViewModel.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 1/21/23.
//

import SwiftUI
import FirebaseFirestore
struct GenerateCouponViewModel{
    let db = Firestore.firestore()
    @ObservedObject var user : User
    @ObservedObject var currCoupon: Coupon
    @State var couponToDelete : Coupon?
 
    //generates and adds coupon to user's coupon array field
    func genCoupon() async {
        //Make code more applicable
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        currCoupon.date = dateFormatter.string(from: date)
        currCoupon.name = UUID().uuidString
        currCoupon.restaurantName = currCoupon.items.first?.itemRestaurant ?? ""
        currCoupon.price = 0
        for menuItem in currCoupon.items{
            currCoupon.price += menuItem.Itemprice
            
        }
       
      
        do{
            
            try await db.collection("Users").document(user.UID).collection("Coupons").document("CurrentCoupon").setData(currCoupon.makeDict())
        }
        catch{
            print(error.localizedDescription)
            }
        
    }
    func deleteCoupon() async {
       
        do{
            try await db.collection("Users").document(user.UID).collection("Coupons").document("CurrentCoupon").delete()
        }
        catch{
            print(error.localizedDescription)
            }
        
    }

}


