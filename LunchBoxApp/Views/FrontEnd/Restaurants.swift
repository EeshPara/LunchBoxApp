//
//  Restaurants.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 12/3/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
struct Restaurants: View {
    @State var restaurants : Array<Restaurant> = []
    @ObservedObject var currCoupon : Coupon
    @ObservedObject var user : User
    @State var rm = reusableMethods()
    @State var restaurantImage :UIImage?
    @State var search : String = ""
    @State var showingPopover = false
    @State var currRestaurant: Restaurant =  Restaurant()
    
    let db = Firestore.firestore()
    var body: some View {
        NavigationStack{
            VStack{
                
                
                
                HStack{
                    Image("Screenshot_2023-01-12_at_2.15")
                        .padding()
                    Spacer()
                }
                HStack {
                    
                    
                    TextField("Search Restaurants", text: $search)
                    Image(systemName: "magnifyingglass")
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color.black, lineWidth: 1))
                .padding()
                
                
                
                //List of restaurants
                ScrollView{
                    ForEach(restaurants, id: \.self) { restaurant in
                        VStack{
                            ZStack{
                                RestaurantImageView(restaurant: restaurant)
                                VStack{
                                    Spacer()
                                    HStack{
                                        Text(restaurant.ResterauntName)
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                            .bold()
                                        Spacer()
                                        Button("View"){
                                            print("tapped")
                                            currRestaurant.ResterauntName = restaurant.ResterauntName
                                            currRestaurant.dailyDiscount = restaurant.dailyDiscount
                                            currRestaurant.MenuItems = restaurant.MenuItems
                                            currRestaurant.ResterauntImage = restaurant.ResterauntImage
                                            currRestaurant.RestaurantDisc = restaurant.RestaurantDisc
                                            showingPopover = true
                                            
                                            
                                        }
                                        .padding(15)
                                        .background(Color.black)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                        .frame(width: 70, height: 44)
                                    }
                                }
                                .padding(30)
                                .frame(width: 350, height: 200)
                                
                            }
                            
                            
                        }.padding()
                    } .popover(isPresented: $showingPopover) {
                        RestaurantView(currRestaurant: currRestaurant, currCoupon: currCoupon, user: user)
                            .presentationDetents([.large])
                        
                    }
                    
                }
                
            }
            .task {
                restaurants = []
                await RestaurantsViewModel(restaurants: $restaurants).getRestaurants()
            }
            
        }
        
    }
    
    
}
   
  
 
          







struct Restaurants_Previews: PreviewProvider {
    static var previews: some View {
        Restaurants(currCoupon: Coupon(), user: User())
    }
}
