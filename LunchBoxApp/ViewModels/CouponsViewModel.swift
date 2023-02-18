//
//  CouponsViewModel.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 1/21/23.
//

import SwiftUI
import FirebaseFirestore
struct CouponsViewModel {
    let db = Firestore.firestore()
    @Binding var coupons : Array<Coupon> // Binding to coupons in coupons View that updates data
    @ObservedObject var user : User // curr user

    //async call to get coupons from coupons field in user object in firebase firestore
    func getCoupons() async{
        do{
            if user.UID != ""{
                if coupons != nil{
                    let couponDicts = try await db.collection("Users").document(user.UID).collection("Coupons").order(by: "Date").getDocuments().documents
                    for dict in couponDicts{
                        coupons.append(reusableMethods().couponDictToObject(dict: dict.data()))
                        
                    }
                }
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
}


