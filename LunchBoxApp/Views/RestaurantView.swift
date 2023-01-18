//
//  RestaurantView.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 12/19/22.
//

import SwiftUI
import FirebaseFirestore
struct RestaurantView: View {
    let db = Firestore.firestore()
    @State var currRestaurant : Restaurant
    @State var recieptArray : Array<MenuItem> = []
    @State var added : String = ""
    @ObservedObject var currCoupon : Coupon
    @ObservedObject var user : User
    @State var showinngPopover = false
    var body: some View {
        ZStack{
            NavigationStack{
                VStack{
                    Text(currRestaurant.ResterauntName)
                        .bold()
                        .font(.system(size: 35))
                        .padding(.bottom,15)
                        .frame(alignment: .leading)
                    
                    Text("Daily Discount: 10%")
                        .bold()
                        .font(.system(size: 25))
                        .padding(.bottom,15)
                    List(currRestaurant.MenuItems){ menuItem in
                        HStack{
                            VStack{
                                Text(menuItem.Itemname)
                                    .bold()
                                    .font(.system(size:20))
                                
                                Text(menuItem.ItemDisc)
                                    .font(.system(size:12))
                                
                            }
                            VStack{
                                let price =  String(format: "%.2f", (menuItem.Itemprice) * 0.9)
                                Text("Price: \( price)")
                                
                            }
                            Spacer()
                            Button("add"){
                                if(currCoupon.items.isEmpty){
                                    currCoupon.restaurantName = menuItem.itemRestaurant
                                }
                                if(currCoupon.restaurantName == menuItem.itemRestaurant){
                                    currCoupon.items.append(menuItem)
                                    print(menuItem.itemImage)
                                    added = menuItem.Itemname
                                }
                                else{
                                    added = "You can only make coupons with items from the same stores"
                                }
                            }.padding(15)
                                .background(Color(red: 230/255, green: 59/255, blue: 36/255))
                                .foregroundColor(.white)
                                .cornerRadius(30)
                        }
                    }
                    HStack{
                        Text("Added To Coupon:  \(added)")
                        
                    }
                    Button("Generate Coupan"){
                        Task{
                           await genCoupon()
                            currCoupon.items = []
                            showinngPopover = true
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
    }
    
    func genCoupon() async {
        //Make code more applicable
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        currCoupon.date = dateFormatter.string(from: date)
        currCoupon.name = currCoupon.items.first!.itemRestaurant
        for menuItem in currCoupon.items{
            currCoupon.price += menuItem.Itemprice * (currRestaurant.dailyDiscount/100)
            
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

struct RestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantView(currRestaurant: Restaurant(),currCoupon: Coupon(), user: User())
    }
}
