//
//  MenuItemView.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 1/18/23.
//

import SwiftUI
import AlertToast

struct MenuItemView: View {
    @State var menuItem : MenuItem
    @ObservedObject var currCoupon: Coupon
    @State var showToast = false
    
    var body: some View {
        VStack{
            ZStack{
                // picture of menuItem with text atop it
                LargeMenuItemImageView(menuItem: menuItem)
                VStack{
                    Spacer()
                        .frame(height: 30)
                    RoundedRectangle(cornerRadius: 300)
                        .fill(.black)
                        .frame(width: 200, height: 8)
                        .padding()
                    
                    Spacer()
                        .frame(height: 30)
                    Text(menuItem.Itemname)
                        .bold()
                        .font(.system(size: 35))
                        .padding(.bottom,15)
                        .frame(alignment: .leading)
                        .foregroundColor(.white)
                        .ignoresSafeArea()
                    Spacer()
                        .frame(height: 120)
                    
               
                    
                    
                }
            }
            .padding()
          
               //Price (adusted for disscount of the day)
           
            Text("$\(String(format: "%.1f",(1-(menuItem.percentOff/100)) * menuItem.Itemprice))")
                .bold()
                .font(.system(size: 50))
                .padding()
               
            Text("Description: ")
                .bold()
            Text(menuItem.ItemDisc)
            
            
            Spacer()
            
            Button("Add"){
                
                //makes a copy og menuItem to then add (can't directly add menuitem because if it is changed then it will be changed within currcoupon as well)
                var copy = menuItem.copy() as! MenuItem
                //if the array is empty then it sets the coupons default restaurant to that of the object added
                copy.Itemprice = (1-(menuItem.percentOff/100)) * menuItem.Itemprice
                if(currCoupon.items.isEmpty){
                currCoupon.restaurantName = menuItem.itemRestaurant
                }
                //it only adds MenuItem if its restaurant name is same as coupons restaurant name
                if(currCoupon.restaurantName == menuItem.itemRestaurant){
                currCoupon.items.append(copy)
                    showToast.toggle()
                    
                }
                
                
                
            }
            .padding(30)
            .background(.black)
            .cornerRadius(8)
            .foregroundColor(.white)
            
            
            
       
        }
        .task{
            
        
        }
        .toast(isPresenting: $showToast, duration: 1.2, tapToDismiss: true){
            //when item added to coupoun shows a pop up with a check mark
            AlertToast(type: .complete(Color.green), title: "Added to Coupon")
                
        }
       
    }
}

//struct MenuItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuItemView(menuItem: $MenuItem(), currCoupon: Coupon())
//    }
//}
