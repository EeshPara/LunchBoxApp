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
    @State var dailyDiscounts : Array<MenuItem> = []
    @State var colleges: Array<String> = []
    @State var selected = ""
    let db = Firestore.firestore()
    @State var rm = reusableMethods()
    var body: some View {
        NavigationStack{
            VStack{
                Text("SetDealsOfTheDay")
                    .bold()
                    .font(.system(size: 35))
                    .padding(.bottom,15)
                
                HStack{
                    
                    Menu("College"){
                        ForEach(colleges, id: \.self){ college in
                            Button(college){
                                selected = college
                                Task{
                                    await getRestaurants()
                                }
                            }
                            
                        }
                        
                    }
                    Text(":  \(selected)")
                }

                
                
                List(restaurants) { restaurant in
                    
                    HStack{
                        Text(restaurant.ResterauntName)
                        Button("Add"){
                            Task{
                                await clearDailyDiscounts()
                                db.collection("Colleges").document("Harvard").collection("DealsOfTheDay").addDocument(data: ["RestaurantUID": restaurant.RestaurantUID])
                            }
                        }
                    }
                }
                
//                Text("DailyDiscounts")
//                    .bold()
//                    .font(.system(size: 20))
//                    .padding(.bottom,15)
//
//                List(dailyDiscounts){MenuItem in
//                    HStack{
//                        Text("\(MenuItem.Itemname)")
//                    }
//                }
//                Button("Save"){
//                    Task{
//                        await clearDailyDiscounts()
//                        for MenuItem in dailyDiscounts{
//
//                            db.collection("Colleges").document("Harvard").collection("DealsOfTheDay").addDocument(data: MenuItem.makeDict())
//                        }
//
//                        dailyDiscounts = []
//                    }
//
//
//
//
//                }
            }
            
        }.task {
            await getColleges()
            
           
        }
    }
    
    @MainActor
    func clearDailyDiscounts() async{
        do{
            let documents = try await db.collection("Colleges").document(selected).collection("DealsOfTheDay").getDocuments()
            for doc in documents.documents{
                do{
                    let _: Void =  try await db.collection("Colleges").document(selected).collection("DealsOfTheDay").document(doc.documentID).delete()
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
            let documents = try await db.collection("Colleges").document(selected).collection("Restaurants").getDocuments()
            for document in documents.documents{
                restaurants.append(rm.restDictToRestObject(dict: document.data()))
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
        
        
    }
    
    func getColleges() async{
        do{
            let documents = try await db.collection("Colleges").getDocuments()
            for document in documents.documents{
                colleges.append(document.data()["CollegeName"] as! String)
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
    @Binding var dailyDiscountArray : Array<MenuItem>
    @State var color = Color(red: 230/255, green: 59/255, blue: 36/255)
    @State var added = ""
    @State var showPopover = false
    @State var currentItemDiscount = 0.0
    @State var currMenuItem = MenuItem()
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
                       
                        Button("set"){
                            currMenuItem.Itemname = menuItem.Itemname
                            currMenuItem.Itemprice = menuItem.Itemprice
                            currMenuItem.ItemDisc = menuItem.ItemDisc
                            currMenuItem.itemImage = menuItem.itemImage
                            currMenuItem.itemRestaurant = menuItem.itemRestaurant
                            
                            showPopover = true
                            
                        }
                        .padding(15)
                        .background(color)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                       
                        
                        
                        
                    }
                   
                    
                    
                    
                } .popover(isPresented: $showPopover){
                    Text("Set Discount for: \(currMenuItem.Itemname)")
                        .padding()
                        .bold()
                    Form{
                        TextField("SetDiscount", value: $currentItemDiscount, format: .number)
                            .disableAutocorrection(true)
                        Button("set"){
                            currMenuItem.percentOff = currentItemDiscount
                            added = currMenuItem.Itemname
                            currMenuItem.percentOff = currentItemDiscount
                            dailyDiscountArray.append(currMenuItem)
                            currMenuItem = MenuItem()
                            showPopover = false
                        }
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
