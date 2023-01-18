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
               
                Text("Welcome:  \(user.UID)")
            }
            
        }
    }
   /* @MainActor
    Code to get a user from a certain email(Plan on deleting)
    func getUser(email: String) async{
        do{
            print("got to await user")
            print(email)
            //Finds all the users with the Email field that matches up with the supplied email(there should only be one)
            let curr = try await db.collection("Users").whereField("Email", isEqualTo: email).getDocuments()
            
            print(curr.count)
            print("got documents")
            //Loops through the one doc
            for doc in curr.documents{
                //passes
                let currUser = reusableMethods().userDictToObject(dict: doc.data())
                user.UserName = currUser.UserName
                user.Email = currUser.Email
                user.college = currUser.college
                user.UID = currUser.UID
               
            }
        }
        
        catch{
            print(error.localizedDescription)
            
        }
        
    }*/
    
    struct UserProfile_Previews: PreviewProvider {
        static var previews: some View {
            UserProfile(user: User())
        }
    }
}
