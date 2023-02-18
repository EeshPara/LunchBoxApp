//
//  UserProfile.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 12/3/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
struct UserProfile: View {
    //FireStore Initialization
    let db = Firestore.firestore()
    //Initialization of the orignal coupon which will are keeping track of
    @StateObject var currCoupon = Coupon()
    @ObservedObject var user : User
    var body: some View {
        NavigationStack{
            VStack{
               
                Text("Welcome:  \(user.UserName)")
            }
            
        }
    }

    
    struct UserProfile_Previews: PreviewProvider {
        static var previews: some View {
            UserProfile(user: User())
        }
    }
}
