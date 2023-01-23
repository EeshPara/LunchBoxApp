//
//  FrontEndTabView.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 12/3/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
struct FrontEndTabView: View {
    let db = Firestore.firestore()
    //Creating the User Object that will have all the  Info of the Current User
    @ObservedObject var user  : User
    //Creatig the Coupon Object with all the info of the current coupon being made (this is the coupon that needs to be generated)
    @StateObject var currCoupon = Coupon()
    
    
    var body: some View {
        VStack{
        
            // All Differnt tab Views and I'm passing the state objects to all of them
                VStack{
                    
                    TabView{
                        
                        
                        Home(currCoupon: currCoupon)
                            .tabItem{
                                VStack{
                                    Image("Image")
                                        
                                    
                                }
                            }
                        
                        
                        Restaurants(currCoupon: currCoupon, user: user)
                            .tabItem{
                                VStack{
                                    Image("drink")
                                        .frame(width: 10,height: 10)
                                    
                                }
                            }
                        
                        Coupons(currCoupon: currCoupon, user: user)
                            .tabItem {
                                VStack{
                                    Image("Money")
                                        .frame(width: 10,height: 10)
                                    
                                }
                                
                            }
                        
                        UserProfile(currCoupon: currCoupon, user: user)
                            .tabItem{
                                VStack{
                                    Image("User_alt")
                                        .frame(width: 10,height: 10)
                                    
                                }
                            }
                        
                        
                    }
                       
                }
                
            
           
        }
    }
  
}

struct FrontEndTabView_Previews: PreviewProvider {
    static var previews: some View {
        FrontEndTabView(user: User())
    }
}
