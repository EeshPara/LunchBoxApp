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
    @State var currMenuItem: MenuItem = MenuItem()
    
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
                
                    ForEach(discounts, id: \.self){ menuItem in
                        VStack{
                            ZStack{
                               
                                VStack{
                                    Spacer()
                                    HStack{
                                        Text(menuItem.Itemname)
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                            .bold()
                                        Spacer()
                                        Button("View"){
                                            currMenuItem.itemImage = menuItem.itemImage
                                            currMenuItem.Itemprice = menuItem.Itemprice
                                            currMenuItem.itemRestaurant = menuItem.itemRestaurant
                                            currMenuItem.ItemDisc = menuItem.ItemDisc
                                            currMenuItem.Itemname = menuItem.Itemname
                                            
                                            
                                            
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
                                .background(LargeMenuItemImageView(menuItem: menuItem))
                            }.padding(15)
                            
                            
                            /*
                             Put this button in the popover i make
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
                             */
                        }
                        
                        
                    }
                
            }
            Spacer()
           /*
            put this in a popover
            HStack{
                //Text that shows what was just added to Coupon
                Text("Added To Coupon:  \(added)")
                
            }
            Button("Generate Coupan"){
                // need to make coupon generation
                // makes the current coupon list empty again so that more coupons can be generated
                currCoupon.items = []
                
            }
            */
            
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
