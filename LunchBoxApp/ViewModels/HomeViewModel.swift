//
//  HomeViewModel.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 1/31/23.
// 

import SwiftUI
import FirebaseFirestore
struct HomeViewModel{
    let db = Firestore.firestore()
    @Binding var restaurants : Array<Restaurant>
    @State var userCollege : String
   
    @MainActor
    func getDeals() async{
        var restaurantUIDs: Array<String> = []
        do{
            //async method that gets docs from the DailDiscounts
            let documents = try await db.collection("Colleges").document(userCollege).collection("DealsOfTheDay").getDocuments()
            for document in documents.documents{
              
                restaurantUIDs.append(document.data()["RestaurantUID"] as! String)
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
        do{
            for uid in restaurantUIDs {
                let restaurant = try await db.collection("Colleges").document(userCollege).collection("Restaurants").document(uid).getDocument()
                restaurants.append(reusableMethods().restDictToRestObject(dict: restaurant.data()!) )
            }
           
        }
        catch{
            print(error.localizedDescription)
        }
        
    }
}

