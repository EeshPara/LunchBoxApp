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
   
    @State var discounts : Array<MenuItem> = []
    @ObservedObject var currCoupon : Coupon
    @State var added : String = ""
    
    var body: some View {
        VStack{
            Text("See Deals of The Day!")
                .bold()
                .font(.system(size: 35))
                .padding(.bottom,15)
            //Takes the discount array (of discounted items) and parses into list
            
            List(discounts){ menuItem in
                HStack{
                    VStack{
                        Text(menuItem.Itemname)
                            .bold()
                            .font(.system(size:20))
                    }
                    Spacer()
                    VStack{
                        let price =  String(format: "%.2f", (menuItem.Itemprice) * 0.9)
                        Text("Price: \( price)")
                            
                        
                    }
                    Spacer()
                    
                    Button("add"){
                        //if the array is empty then it sets the coupons default restaurant to that of the object added
                        if(currCoupon.items.isEmpty){
                            currCoupon.restaurantName = menuItem.itemRestaurant
                        }
                        //it only adds MenuItem if its restaurant name is same as coupons restaurant name
                        if(currCoupon.restaurantName == menuItem.itemRestaurant){
                            currCoupon.items.append(menuItem)
                            added = menuItem.Itemname
                        }
                        else{
                            added = "You can only make coupons with items from the same stores"
                        }
                    }
                    .hoverEffect(.highlight)
                    .padding(15)
                        .background(Color(red: 230/255, green: 59/255, blue: 36/255))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                

            }
            HStack{
                //Text that shows what was just added to Coupon
                Text("Added To Coupon:  \(added)")
                
            }
            Button("Generate Coupan"){
                // need to make coupon generation
                // makes the current coupon list empty again so that more coupons can be generated
                currCoupon.items = []
                
            }
            
            
        }.task{
            //as soon as we enter the view it loads the deals with the get deals method
            discounts = []
            await getDeals()
        }
    }
    
    @MainActor
    func getDeals() async{
        do{
            //async method that gets docs from the DailDiscounts
            let documents = try await db.collection("DailyDiscounts").getDocuments()
            for document in documents.documents{
              
                discounts.append(reusableMethods().menuDictToMenuItemObject(dict: document.data()))
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(currCoupon: Coupon())
    }
}
