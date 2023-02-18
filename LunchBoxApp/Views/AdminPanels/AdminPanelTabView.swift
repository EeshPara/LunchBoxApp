//
//  AdminPanelTabView.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 11/13/22.
//

import SwiftUI

struct AdminPanelTabView: View {
    @StateObject var restaurant  = Restaurant()
    var body: some View {
        TabView{
            AdminPanel1(restaurant: restaurant)
                .tabItem{
                    Label("RestaurantInit",systemImage:"")
                }
            AdminPanel3MenuInit(restaurant: restaurant)
                .tabItem{
                    Label("MenuInit",systemImage: "")
                }
            AdminPanel2PackInit(restaurant: restaurant)
                .tabItem{
                    Label("CouponsInit",systemImage: "")
                }
            SetDiscountOfTheDay()
                .tabItem {
                    Label("Daily Lunchbox", image: "")
                }
            EditRestaurants()
                .tabItem{
                    Label("Edit Restaurants", image: "")
                }
            AddColleges()
                .tabItem{
                    Label("AddColleges", image: "")
                }
                
            
                
        }
    }
}

struct AdminPanelTabView_Previews: PreviewProvider {
    static var previews: some View {
        AdminPanelTabView()
    }
}
