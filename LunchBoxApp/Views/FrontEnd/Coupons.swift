//
//  Coupons.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 1/4/23.
//

import SwiftUI
import FirebaseFirestore
struct Coupons: View {
    
    let db = Firestore.firestore()
    @ObservedObject var currCoupon : Coupon
    @ObservedObject var user : User
    @State var coupons: Array<Coupon> = []
    @State var showingPopover  = false
    @State var couponDisplayed : Coupon = Coupon()
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Image("Screenshot_2023-01-12_at_2.15")
                        .padding()
                        Spacer()
                }
                
                HStack{
                    Text("Current Coupon: ")
                        .bold()
                        .font(.system(size: 20))
                        .padding()
                        .lineLimit(1)
                        .padding(.trailing,100)
                   
                   
                    Button("Build"){
                        Task{
                            await GenerateCouponViewModel(user: user, currCoupon: currCoupon).genCoupon()
                            currCoupon.items = []
                            coupons = []
                            await CouponsViewModel(coupons: $coupons, user: user).getCoupons()
                        }
                    }
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(.black)
                    .cornerRadius(8)
                    
                   
                }
               
              
                List{
                    ForEach(currCoupon.items){ menuItem in
                        HStack{
                            VStack{
                                MenuItemImageView(menuItem: menuItem)
                                Text(menuItem.Itemname)
                                    .bold()
                                    .font(.system(size:20))
                                let price =  String(format: "%.2f", menuItem.Itemprice)
                                Text("$\( price)")
                                    .font(.system(size: 13))
                                
                            }
                            
                            
                            Spacer()
                            
                            
                        }.padding()
                        
                    }
                    .onDelete { indexSet in
                        delete(index: indexSet)
                    }
                }
                    .frame(width: 400, height: 300)
                    .scrollContentBackground(.hidden)
               
                HStack{
                    Text("Use")
                        .bold()
                        .font(.system(size: 20))
                        .padding(.bottom,15)
                        .padding(.trailing, 300)
                }
               
                
                List(coupons){coupon in
                    
                    HStack{
                        Text(coupon.name)
                            .scaleEffect(x: 1, y: -1, anchor: .center)
                        Text(coupon.date)
                            .scaleEffect(x: 1, y: -1, anchor: .center)
                        Spacer()
                        
                        Button("Use"){
                            couponDisplayed.name = coupon.name
                            couponDisplayed.date = coupon.date
                            couponDisplayed.items = coupon.items
                            couponDisplayed.price = coupon.price
                            showingPopover = true
                            
                        }
                        .padding(15)
                        .cornerRadius(30)
                        .scaleEffect(x: 1, y: -1, anchor: .center)
                        .disabled(coupon.usedAndConfirmed)
                        
                        
                    }
                }
                .scrollContentBackground(.hidden)
                .popover(isPresented: $showingPopover) {
                    CouponPopover(coupon: couponDisplayed, user: user)
                        .presentationDetents([.height(700)])
                    
                }
                .frame(height: 200)
                .scaleEffect(x: 1, y: -1, anchor: .center)
                
            }
        }.task {
            coupons = []
            await CouponsViewModel(coupons: $coupons, user: user).getCoupons()
            
        }
    }
    
    func delete(index: IndexSet){
        currCoupon.items.remove(atOffsets: index)

    }

    
    
}



struct Coupons_Previews: PreviewProvider {
    static var previews: some View {
        Coupons(currCoupon: Coupon(), user: User())
    }
}
