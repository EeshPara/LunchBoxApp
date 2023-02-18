//
//  RestaurantsViewModel.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 1/22/23.
//

import SwiftUI
//
//  RestaurantsViewModel.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 1/21/23.
//


import FirebaseFirestore
struct RestaurantsViewModel{
    let db = Firestore.firestore()
    let rm = reusableMethods()
    @Binding var restaurants :  Array<Restaurant>
    @ObservedObject var user: User
    // gets restaurants Asyncronasly from databse and stores it in the restaurants array and returns restaurants
    @MainActor
    func getRestaurants() async{
        
      //Async function that gets restaurants and makes a list of restuaraunt objects
        
        do{
            let documents = try await db.collection("Colleges").document(user.college).collection("Restaurants").getDocuments()
            for document in documents.documents{
                restaurants.append(rm.restDictToRestObject(dict: document.data()))
                
            }
           
        }
        catch{
            print(error.localizedDescription)
        }
        
        
       
    }
}


