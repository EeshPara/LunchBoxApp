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
    @ObservedObject var currRestaurant: Restaurant
    //generates and adds coupon to user's coupon array field
    func genCoupon() async {
        //Make code more applicable
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        currCoupon.date = dateFormatter.string(from: date)
        currCoupon.name = currCoupon.items.first!.itemRestaurant
        for menuItem in currCoupon.items{
            currCoupon.price += menuItem.Itemprice * (currRestaurant.dailyDiscount/100)
            
        }
       
        let docRef =  db.collection("Users").document(user.UID)
        do{
            try await docRef.updateData([
                "Coupons": FieldValue.arrayUnion([currCoupon.makeDict()])
            ])
        }
        catch{
            print(error.localizedDescription)
            }
        
    }
}


