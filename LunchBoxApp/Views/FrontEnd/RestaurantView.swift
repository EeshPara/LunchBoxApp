//
//  RestaurantView.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 12/19/22.
//

import SwiftUI
import FirebaseFirestore
import AlertToast
struct RestaurantView: View {
    let db = Firestore.firestore()
    @State var currRestaurant : Restaurant
    @State var recieptArray : Array<MenuItem> = []
    @State var added : String = ""
    @ObservedObject var currCoupon : Coupon
    @ObservedObject var user : User
    @State var showinngPopover = false
    @State var showToast = false
    
    var body: some View {
       
                ScrollView{
                    VStack{
                        
                        ZStack(alignment: .top, content: {
                            
                            
                            LargeRestaurantImageView(restaurant: currRestaurant)
                                .ignoresSafeArea()
                                .frame(alignment: .top)
                            
                            
                        
                            VStack{
                                Spacer()
                                    .frame(height: 30)
                                RoundedRectangle(cornerRadius: 300)
                                    .fill(.black)
                                    .frame(width: 200, height: 8)
                                    .padding()
                                
                                Spacer()
                                    .frame(height: 30)
                                Text(currRestaurant.ResterauntName)
                                    .bold()
                                    .font(.system(size: 35))
                                    .padding(.bottom,15)
                                    .frame(alignment: .leading)
                                    .foregroundColor(.white)
                                    .ignoresSafeArea()
                                Spacer()
                                    .frame(height: 120)
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.white)
                                    .frame(height: 60)
                                    .shadow(radius: 3, y: -10)
                                
                                
                            }
                        })
                        
                        
                        VStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 350, height: 50)
                                    .foregroundColor(.green)
                                    .shadow(radius: 3, y: 3)
                                    .padding(15)
                                
                                
                                
                                
                                Text("Daily Discount: \(String(format: "%.1f",currRestaurant.dailyDiscount))%")
                                    .bold()
                                    .font(.system(size: 18))
                                    .padding(15)
                                    .foregroundColor(.white)
                                
                            }
                            
                            HStack{
                                Text("Menu:")
                                    .padding(20)
                                    .bold()
                                Spacer()
                            }
                            ScrollView{
                                ForEach(currRestaurant.MenuItems, id: \.self) { menuItem in
                                    
                                    VStack{
                                        HStack{
                                            MenuItemImageView(menuItem: menuItem)
                                                .frame(width: 100, height: 100)
                                                .padding(10)
                                            VStack{
                                                Text(menuItem.Itemname)
                                                    .bold()
                                                    .font(.system(size:20))
                                                
                                                Text(menuItem.ItemDisc)
                                                    .font(.system(size:12))
                                                
                                            }
                                            VStack{
                                                
                                                Text("$ \( String(format: "%.2f", (menuItem.Itemprice) * (1-(currRestaurant.dailyDiscount/100))))")
                                                    .bold()
                                                
                                            }
                                            Spacer().frame(width: 10)
                                            Button("add"){
                                                var copy = menuItem.copy() as! MenuItem
                                                copy.Itemprice = (menuItem.Itemprice) * (1-(currRestaurant.dailyDiscount/100))
                                                if(currCoupon.items.isEmpty){
                                                    currCoupon.restaurantName = menuItem.itemRestaurant
                                                }
                                                if(currCoupon.restaurantName == menuItem.itemRestaurant){
                                                    currCoupon.items.append(copy)
                                                    print(menuItem.itemImage)
                                                    added = menuItem.Itemname
                                                    showToast.toggle()
                                                }
                                                else{
                                                    added = "You can only make coupons with items from the same stores"
                                                }
                                                
                                            }
                                            .padding()
                                            .background(.black)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                        }
                                    }
                                    
                                    
                                }
                                .toast(isPresenting: $showToast, duration: 1.2, tapToDismiss: true){
                                    AlertToast(type: .complete(Color.green), title: "Added to Coupon")
                                        
                                }
                            }
                        }
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 350, height: 50)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        VStack{
                            HStack{
                               
                                Text("Added To Coupon:  \(added)")
                                    .bold()
                                    
                                
                            }
                            HStack{
                                Button("Generate Coupan"){
                                    Task{
                                        await GenerateCouponViewModel(user: user, currCoupon: currCoupon).genCoupon()

                                        currCoupon.items = []
                                        showinngPopover = true
                                    }
                                    
                                }
                                
                            }
                        }
                        
                        
                    }
                    
                    .popover(isPresented: $showinngPopover, content: {
                        VStack{
                            Text("Your coupon was generated!")
                                .bold()
                                .font(.system(size: 35))
                                .padding(.bottom,10)
                            Text("Go to the Coupons tab on your phone and it will be saved there. Make sure you use your coupon IN-Store. Using your coupon is simple, just open it up for whoever is serving you and allow them to press the confirm button!")
                                .padding()
                        }
                    })
                    .disabled(currCoupon.items.isEmpty)
                    
                    
                }
        
    }
    
    
  
    
}

struct RestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantView(currRestaurant: Restaurant(),currCoupon: Coupon(), user: User())
    }
}
