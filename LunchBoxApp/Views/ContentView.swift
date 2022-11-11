//
//  ContentView.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 11/4/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var restaurant  = Restaurant(ResterauntName: "",RestaurantDisc: "", RestaurantCollege: "", MenuItems: [], SubscriptionPacks: [], DailyMenuDisc: 0.0, HappyHourTimes: "", HappyHourDisc: 0.0, ResterauntImage: "")
    @State private var RestaurantName = ""
    @State private var RestaurantDisc = ""
    @State private var RestaurantCollege = ""
    @State private var RestaurantDailyMenuDiscount = 0.0
    @State private var RestaurantHappyHourTimes = ""
    @State private var RestaurantHapyHourDiscount = 0.0
    @State private var MenuItemName = ""
    @State private var MenuItemPrice = 0.0
    @State private var MenuItemDisc = ""
    @State private var menu : Array<MenuItem> = []
    @State var itemtoAdd =  MenuItem(Itemname: "", Itemprice: 0.0, ItemDisc: "")
    var body: some View {
        VStack{
            
            var menuSize = 0
            HStack{
                
                Text("Admin Panel")
                    .bold()
                    .font(.system(size: 35))
                    .padding(.bottom,15)
                Button("Save") {
                    initilize()
                }
                .padding(.bottom, 20)
                .padding(.leading, 75)
                .buttonStyle(.borderedProminent)
                .backgroundStyle(Color(.purple))
            }
            
            Form {
                //Restaurant Info
                TextField("RestaurantName", text: $RestaurantName)
                    .disableAutocorrection(true)
                TextField("RestaurantDisc", text: $RestaurantDisc)
                    .disableAutocorrection(true)
                TextField("RestaurantCollege", text: $RestaurantCollege)
                    .disableAutocorrection(true)
                TextField("DailyMenuDiscount", value: $RestaurantDailyMenuDiscount, format: .number)
                    .disableAutocorrection(true)
                TextField("HappyHourTimes", text: $RestaurantHappyHourTimes)
                    .disableAutocorrection(true)
                TextField("HappyHourDiscount", value: $RestaurantHapyHourDiscount, format: .number)
                    .disableAutocorrection(true)
                
                
                //MenuItems Initialization
                TextField("MenuItemName", text: $MenuItemName)
                    .disableAutocorrection(true)
                TextField("MenuItemDisc", text: $MenuItemDisc)
                    .disableAutocorrection(true)
                TextField("MenuItemPrice", value: $MenuItemPrice, format: .number)
                    .disableAutocorrection(true)
                
                //Adding Menu Items to List
                    Button("add") {
                        itemtoAdd = MenuItem(Itemname: MenuItemName, Itemprice: MenuItemPrice, ItemDisc: MenuItemDisc)
                        addItem(ItemToAdd: itemtoAdd)
                        menuSize+=1
                        print(menuSize)
                        print(menu.count)
                    }
                    .padding(.leading,140)
                
               
                
                    
                
            
            }
            
            // Menu List Area
            Text("Menu")
                .bold()
                .font(.system(size: 15))
                .padding(.bottom,10)
            
                List{
                    ForEach(menu){ MenuItem in
                        HStack{
                            Text(MenuItem.Itemname)
                                .padding(.trailing,100)
                            
                            var priceRounded = String(format: "%g", MenuItem.Itemprice)
                            Text("Price: \(priceRounded)")
                        }
                        
                    }
                    
                }
            

            
        }

    }
    
    func initilize(){
        
            restaurant = Restaurant(ResterauntName: RestaurantName, RestaurantDisc: RestaurantDisc, RestaurantCollege: RestaurantCollege, MenuItems: menu, SubscriptionPacks: [], DailyMenuDisc: RestaurantDailyMenuDiscount, HappyHourTimes: RestaurantHappyHourTimes, HappyHourDisc: RestaurantHapyHourDiscount, ResterauntImage: "")
        
    }
    
    
    func addItem(ItemToAdd: MenuItem){
        menu.append(ItemToAdd)
        itemtoAdd = MenuItem(Itemname: "", Itemprice: 0.0, ItemDisc: "")
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
