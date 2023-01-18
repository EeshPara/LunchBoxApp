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
  
    let db = Firestore.firestore()
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Text("Restaurants")
                        .bold()
                        .font(.system(size: 35))
                        .padding(.bottom,15)
                        .foregroundColor(.black)
                        .padding(20)
                    Spacer()
                }
                
               
                //List of restaurants
                ScrollView{
                    ForEach(restaurants, id: \.self) { restaurant in
                        ZStack{
                           
                            VStack{
                                Spacer()
                                HStack{
                                    Text(restaurant.ResterauntName)
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .bold()
                                    Spacer()
                                    NavigationLink("View"){
                                        RestaurantView(currRestaurant: restaurant, currCoupon: currCoupon, user: user)
                                    }
                                    .padding(15)
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .frame(width: 70, height: 30)
                                }
                            }
                            .padding(30)
                            .frame(width: 350, height: 200)
                            .background(RestaurantImageView(restaurant: restaurant))
                        }.padding(15)
                        
                        }
                    
                }
               
            }
            .task {
                restaurants = []
                await getRestaurants()
            }
            
        }
        
    }
    
    
   
   
  
    @MainActor
    func getRestaurants() async {
        
      //Async function that gets restaurants and makes a list of restuaraunt objects
        
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
          







struct Restaurants_Previews: PreviewProvider {
    static var previews: some View {
        Restaurants(currCoupon: Coupon(), user: User())
    }
}
