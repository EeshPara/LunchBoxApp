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
                   
                    
                    Button("Build"){
                        
                    }
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(.black)
                    .cornerRadius(8)
                    .frame(width: 200, height: 15)
                   
                }
               
              
                    List(currCoupon.items){ menuItem in
                        HStack{
                            
                            
                            
                            VStack{
                                MenuItemImageView(menuItem: menuItem)
                                Text(menuItem.Itemname)
                                    .bold()
                                    .font(.system(size:20))
                                    
                                let price =  String(format: "%.2f", (menuItem.Itemprice) * 0.9)
                                Text("$\( price)")
                                    .font(.system(size: 13))
                                
                            }
                            
                            
                           Spacer()
                            Button("Delete"){
                                
                            }
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(.black)
                            .cornerRadius(8)
                            .frame(width: 200, height: 15)
                            
                        }.padding()
                       
                       
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
                            showingPopover = true
                            
                        }
                      
                        .padding(15)
                        .cornerRadius(30)
                        .scaleEffect(x: 1, y: -1, anchor: .center)
                        .disabled(coupon.usedAndConfirmed)
                        
                        
                    }
                }
                .popover(isPresented: $showingPopover) {
                    CouponPopover(Coupon: couponDisplayed)
                        .presentationDetents([.medium])
                    
                }
                .frame(height: 200)
                .scaleEffect(x: 1, y: -1, anchor: .center)
                
            }
        }.task {
            coupons = []
            await getCoupons()
            
        }
    }
    
    func getCoupons() async{
        do{
            if user.UID != ""{
                let couponDicts = try await db.collection("Users").document(user.UID).getDocument().get("Coupons") as! Array<Dictionary<String,Any>>
                for dict in couponDicts{
                    coupons.append(reusableMethods().couponDictToObject(dict: dict))
                }
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func genCoupon() async {
        //Make code more applicable
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        currCoupon.date = dateFormatter.string(from: date)
        currCoupon.name = currCoupon.items.first!.itemRestaurant
        do{
            let restaurantRef = try await db.collection("Restaurants").document(currCoupon.name).getDocument().data()
            if(restaurantRef != nil){
                let restaurant = reusableMethods().restDictToRestObject(dict: restaurantRef!)
                for menuItem in currCoupon.items{
                    currCoupon.price += menuItem.Itemprice * restaurant.dailyDiscount
                    
                    
                }
            }
        }
        catch{
            
        }
       
     
       
        let docRef =  db.collection("Users").document(user.UID)
        do{
            try await docRef.updateData([
                "Coupons": FieldValue.arrayUnion([currCoupon.makeDict()])
            ])
        }
        catch{
            print(error.localizedDescription)
            }
        
            
        
       
        
    }
    
    
}

struct CouponPopover: View{
    @State var coupon : Coupon
    init(Coupon: Coupon) {
        self.coupon = Coupon
    }
    var body: some View{
        VStack{
            Text(coupon.name)
                .bold()
                .font(.system(size: 35))
                .padding(.bottom,10)
            Text(coupon.date)
                .padding()
            ScrollView(.horizontal){
                HStack(spacing: 20){
                    ForEach(coupon.items, id: \.self) { item in
                        
                        VStack{
                            if(item.itemImage != ""){
                                MenuItemImageView(menuItem: item)
                            }
                            Text(item.Itemname)
                                .bold()
                        }
                        .padding(30)
                    }
                    
                }
            }
            
            Button("Confirm"){
                
            }
            .padding(15)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(20)
        }
        .frame(width: 350, height: 200)
    }
}

struct Coupons_Previews: PreviewProvider {
    static var previews: some View {
        Coupons(currCoupon: Coupon(), user: User())
    }
}
