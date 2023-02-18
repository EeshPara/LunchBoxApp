//
//  Home.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 12/3/22.
//This View just shows the Deals of the Day

import SwiftUI
import FirebaseFirestore

struct Home: View {
     //Firebase initialization
    let db = Firestore.firestore()
    @State var restaurants : Array<Restaurant> = []
    @ObservedObject var currCoupon : Coupon
    @ObservedObject var user : User
    @State var added : String = ""
    @State var currMenuItem: MenuItem = MenuItem()
    @State var showingPopover = false
    
    
    var body: some View {
        VStack{
            HStack{
                Image("Screenshot_2023-01-12_at_2.15")
                    .padding()
                Spacer()
            }
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 350, height: 50)
                    .foregroundColor(.green)
                    .shadow(radius: 3, y: 3)
                    .padding(15)
                
                    
                    
                    
                Text("Get atleast 25% off EveryDay!")
                    .bold()
                    .font(.system(size: 15))
                    .padding(15)
                    .foregroundColor(.white)
                
            }
                .frame(height: 50)
            HStack{
                Text("Deals of the Day!")
                    .bold()
                    .font(.system(size: 20))
                    .padding()
                Spacer()
            }
            
            
            //Takes the discount array (of discounted items) and parses into list
            ScrollView(){
                
                    ForEach(restaurants, id: \.self){ restaurant in
                        Text(restaurant.ResterauntName)
                        
                        
                    }.padding(15)
                    .popover(isPresented: $showingPopover){
                        //showing popup
                        MenuItemView(menuItem: currMenuItem, currCoupon: currCoupon)
                        
                    }
                
            }
            Spacer()
     
            
        }.task{
            //as soon as we enter the view it loads the deals with the get deals method
            restaurants = []
            await HomeViewModel(restaurants: $restaurants, userCollege: user.college).getDeals()
        }
    }
    
   
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(currCoupon: Coupon(), user: User())
    }
}
