//
//  AdminPanel2PackInit.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 11/13/22.
// 

import SwiftUI
import FirebaseFirestore
import AlertToast
struct AdminPanel2PackInit: View {
    @ObservedObject var restaurant : Restaurant
    @State private var coupons: Array<Coupon> = []

    @State private var couponDescription = ""
    @State private var couponName = ""
    @State private var percentOff = 0.0
    @State private var MenuInit = AdminPanel3MenuInit(restaurant: Restaurant())
    @State  var savedRestaurantToDatabase = false
    @State var itemsInCOupon : Array<MenuItem> = []
    @State var showtoast = false
    @State var currCoupon : Coupon = Coupon()
    @State var percentChance = 0.0
    let db = Firestore.firestore()
    
    
    
    var body: some View {
        VStack{
            
            Text("Coupon Init")
                .bold()
                .font(.system(size: 35))
                .padding(.bottom,15)
            
           
            
            Form{
                TextField("CouponName", text: $couponName)
                    .disableAutocorrection(true)
                TextField("Description", text: $couponDescription)
                    .disableAutocorrection(true)
                TextField("PercentOf", value: $percentOff, format: .number)
                    .disableAutocorrection(true)
                TextField("PercentChance", value: $percentChance, format: .number)
                    .disableAutocorrection(true)
                 
                HStack{
                    Menu("Menu Items:"){
                        
                        ForEach(restaurant.MenuItems, id: \.self){ menuItem in
                            Button(menuItem.Itemname){
                                addMenuItem(menuItem: menuItem)
                                showtoast.toggle()
                            }
                        }
                        
                        
                        
                    }
                    
                }
                
                
                Button("add"){
                    currCoupon.name = couponName
                    currCoupon.desc = couponDescription
                    currCoupon.percentOff = percentOff
                    currCoupon.percentChance = percentChance
                    currCoupon.items = itemsInCOupon
                    add(coupon: currCoupon)
                }
                .buttonStyle(.borderedProminent)
                .padding(.leading, 130)
              
            }
         
            
            .padding(.bottom,10)
            HStack{
                Text("Current Packs")
                    .bold()
                    .font(.system(size: 25))
                Button("Save coupons"){
                   

                    for coupon in coupons {
                        db.collection("Colleges").document(restaurant.RestaurantCollege).collection("Restaurants").document(restaurant.RestaurantUID).collection("RestaurantCoupons").addDocument(data: coupon.makeDict())
                    }
                    
                    
                   
                }
                .padding(.leading, 50)
                .disabled(!savedRestaurantToDatabase)
                .buttonStyle(.borderedProminent)
                
              
            }
                
            List{
                ForEach(coupons){ coupon in
                    HStack{
                        VStack{
                            Text(coupon.name)
                                .padding(.trailing, 50)
                            Text("Number of MenuItems: \(coupon.items.count)")
                        }
                        Text("\(coupon.percentOff)%")
                      
                        
                    }
                    
                }
            }
            Button("Save Restaurant to Database"){
               

                db.collection("Colleges").document(restaurant.RestaurantCollege).collection("Restaurants").document(restaurant.RestaurantUID).setData(restaurant.makeDict())
                savedRestaurantToDatabase = true
                
               
            }
            .buttonStyle(.borderedProminent)
              
         
            
        } .toast(isPresenting: $showtoast, duration: 1) {
            AlertToast(displayMode: .hud, type: .regular, title: "Added")
               
            
        }
        
    }
    
    func add(coupon: Coupon){
        coupons.append(coupon)
        currCoupon = Coupon()
        itemsInCOupon = []
    }
    func addMenuItem(menuItem: MenuItem){
        itemsInCOupon.append(menuItem)
    }
    
}




struct AdminPanel2PackInit_Previews: PreviewProvider {
    static var previews: some View {
        AdminPanel2PackInit(restaurant: Restaurant())
    }
}
