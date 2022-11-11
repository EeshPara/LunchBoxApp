//
//  AdminPanel1.swift
//  LunchBox
//
//  Created by Rama Parasuramuni on 11/2/22.
//

import SwiftUI

struct AdminPanel1: View {
    @State private var RestaurantName = ""
    @State private var RestaurantDisc = ""
    @State private var MenuItemName = ""
    @State private var MenuItemPrice = 0.0
    @State private var MenuItemDisc = ""
    
    
    
    var body: some View {
         
        VStack{
            var menu : Array<MenuItem> = []
            var menuSize = 0
            Text("Admin Panel")
                .bold()
                .font(.system(size: 35))
                .padding(.bottom,15)
            
            Form{
                TextField("RestaurantName", text: $RestaurantName)
                    .disableAutocorrection(true)
                    .accessibilityIdentifier("RestaurantNameField")
                   
                TextField("RestaurantDisc", text: $RestaurantDisc)
                    .disableAutocorrection(true)
                
                Button("Save") {
                    print(RestaurantDisc)
                }
                .padding(.leading, 140)
                
                
                //MenuItems Initialization
                TextField("MenuItemName", text: $MenuItemName)
                    .disableAutocorrection(true)
                    
                TextField("MenuItemDisc", text: $MenuItemDisc)
                    .disableAutocorrection(true)
                TextField("MenuItemPrice", value: $MenuItemPrice, format: .number)
                    .disableAutocorrection(true)
                
                
                Button("add") {
                    menu.append(MenuItem(Itemname: MenuItemName, Itemprice: MenuItemPrice, ItemDisc: MenuItemDisc))
                    menuSize+=1
                }
                .padding(.leading,140)
                    
            }
            
            List{
                ForEach(menu){ MenuItem in
                    Text(MenuItem.Itemname)
                    
                }
                
            }

            
        }

    }
}

struct AdminPanel1_Previews: PreviewProvider {
    static var previews: some View {
        AdminPanel1()
    }
}

