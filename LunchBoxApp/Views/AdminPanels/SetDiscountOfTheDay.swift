//
//  SetDiscountOfTheDay.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 12/29/22.
//

import SwiftUI
import FirebaseFirestore

struct SetDiscountOfTheDay: View {
    @State var restaurants : Array<Restaurant> = []
    @StateObject var dailyDiscounts = MenuItemContainer()
   
    let db = Firestore.firestore()
    @State var rm = reusableMethods()
    var body: some View {
        NavigationStack{
            VStack{
                Text("SetDiscountOfTheDay")
                    .bold()
                    .font(.system(size: 35))
                    .padding(.bottom,15)
                List(restaurants) { restaurant in
                    
                    HStack{
                        Text(restaurant.ResterauntName)
                        NavigationLink(""){
                            
                            AdminRestaurantView(currRestaurant: restaurant, dailyDiscountArray: dailyDiscounts)
                            
                        }
                    }
                }
                
                Text("DailyDiscounts")
                    .bold()
                    .font(.system(size: 20))
                    .padding(.bottom,15)
                
                List(dailyDiscounts.MenuItems){MenuItem in
                    HStack{
                        Text("\(MenuItem.Itemname)")
                    }
                }
                Button("Save"){
                   
                    for MenuItem in dailyDiscounts.MenuItems{
                        var dailydiscDict:  Dictionary<String, Any>  = MenuItem.makeDict()
                        dailydiscDict["RestaurantName"] = 
                        db.collection("DailyDiscounts").addDocument(data: MenuItem.makeDict())
                    }
                    
                    dailyDiscounts.MenuItems = []
                   
                }.task{
                    await setDailyDiscounts()
                    
                     
                 }
            }
            
        }.task {
            await getRestaurants()
        }
    }
    
    @MainActor
    func setDailyDiscounts() async{
        do{
            let documents = try await db.collection("DailyDiscounts").getDocuments()
            for doc in documents.documents{
                do{
                    let _: Void =  try await db.collection("DailyDiscounts").document(doc.documentID).delete()
                }
                catch{
                    print(error.localizedDescription)
                }
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
        
    }
        
    
    @MainActor
    func getRestaurants() async {
        
      
        
        do{
            let documents = try await db.collection("Restaurants").getDocuments()
            for document in documents.documents{
                restaurants.append(rm.restDictToRestObject(dict: document.data()))
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
        
        
    }
}


//Struct to acces specific restaurant
struct AdminRestaurantView: View {
    @State var currRestaurant : Restaurant
    @ObservedObject var dailyDiscountArray : MenuItemContainer
    @State var color = Color(red: 230/255, green: 59/255, blue: 36/255)
    @State var added = ""
    var body: some View {
        NavigationStack{
            VStack{
                Text(currRestaurant.ResterauntName)
                    .bold()
                    .font(.system(size: 35))
                    .padding(.bottom,15)
                
                List(currRestaurant.MenuItems){ menuItem in
                    HStack{
                        VStack{
                            Text(menuItem.Itemname)
                                .bold()
                                .font(.system(size:20))
                            
                            Text(menuItem.ItemDisc)
                                .font(.system(size:12))
                            
                        }
                        VStack{
                            let price =  String(format: "%.2f", (menuItem.Itemprice) * 0.9)
                            Text("Price: \( price)")
                            
                        }
                        Spacer()
                        var buttonState = "Set"
                        Button(buttonState){
                            dailyDiscountArray.MenuItems.append(menuItem)
                            added = menuItem.Itemname
                            
                        }
                        .padding(15)
                        .background(color)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                        
                        
                    }
                   
                    
                    
                    
                }
                HStack{
                    Text("Added:  \(added)")
                    
                }
                
                
            }
        }
    }
    
    func setColor(){
        color = Color(red: 230/255, green: 59/255, blue: 36/255)
    }
}




struct SetDiscountOfTheDay_Previews: PreviewProvider {
    static var previews: some View {
        SetDiscountOfTheDay()
    }
}
