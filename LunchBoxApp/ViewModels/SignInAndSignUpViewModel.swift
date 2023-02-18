//
//  SignInAndSignUpViewModel.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 1/28/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
struct SignUpViewModel{
    @State var username: String
    @State var email: String
    @State var password : String
    @State var college : String
   
    let db = Firestore.firestore()
    
    //creates user
    func SignUpAndCreateUser(){
        Auth.auth().createUser(withEmail: email.lowercased(), password: password) { authResult, error in
            if (error != nil){
                print(error?.localizedDescription)
            }
            else{
                print("Signed Up")
                //stores a user object with same UUID as its Authentication UUID
                var newUser : User = User(UserName: username, Email: email, college: college, UID: Auth.auth().currentUser?.uid ?? "" )
               
                db.collection("Users").document(newUser.UID).setData(newUser.makeDict())
                
            }
            
        }
    }
    
   

    
}

@MainActor
//Methods that ontrol the backend for signing in
class SignInMethods{
    @ObservedObject var SegueObject: Segue
    @ObservedObject var user: User
    let db = Firestore.firestore()
    init(segue: Segue, userObject: User){
        SegueObject = segue
        user = userObject
    }
    
    func signIn (email: String, password: String) async {
        do{
            //async sign in
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
           //save the userObejcts UUID as the current users UUID so that in future we may update user if needed
            await getCurrUser()
            //says it is time to go on to next View
            SegueObject.isTrue = true
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func getCurrUser() async{
        do{
            let docRef = try await db.collection("Users").document(Auth.auth().currentUser?.uid ?? "").getDocument()
           let userRef = reusableMethods().userDictToObject(dict: docRef.data()!)
            user.UserName = userRef.UserName
            user.Email = userRef.Email
            user.UID = userRef.UID
            user.college = userRef.college
        }
        catch{
            print(error.localizedDescription)
        }
        
    }
    
}

//Segue Class with property is true Basically allows for a boolean observable object to be made
//and used across classes to pass information
class Segue : ObservableObject{
    @Published var isTrue = false
}
