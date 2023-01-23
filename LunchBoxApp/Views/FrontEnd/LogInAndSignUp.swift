//
//  LogInAndSignUp.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 11/26/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct LogInAndSignUp: View {
    let db  = Firestore.firestore()
    @StateObject private var user = User()
    @State private var adminEmail = "eeshpara@gmail.com"
    @State private var email = ""
    @State private var password = ""
    @State private var signup = signUp()
    @State private var signedIn = false
    @StateObject private var segueObject = Segue()

    
    var body: some View {
        ZStack{
            NavigationStack{
                VStack{
                    Text("Sign In")
                        .bold()
                        .font(.system(size: 35))
                        .padding(.bottom,15)
                    HStack {
                        Image(systemName: "mail")
                        
                        TextField("Email", text: $email)
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 100).stroke(.black, lineWidth: 2))
                    .padding()
                    HStack {
                        Image(systemName:"lock")
                        
                        TextField("Password", text: $password)
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 100).stroke(.black, lineWidth: 2))

                    .padding()
                    
                    NavigationLink("SignUp Instead"){
                        signup
                    }
                    .navigationBarBackButtonHidden(true)
                    .padding(.bottom, 10)
    
                    Button("Sign In"){
                        Task{
                           await SignInMethods(segue: segueObject, user: user).signIn(email: email, password: password)
                        }
                         
                        
                        
                    }
                    .padding(15)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .frame(width: 1000, height: 30)
                    
                }
            }
            //Decides which view to go to
            if(segueObject.isTrue){
               
                if(adminEmail.lowercased() == email.lowercased()){
                AdminPanelTabView()
                }
                else{
                    
                FrontEndTabView(user: user)
                }
            }
            
        }
}
    
    
    @MainActor
    //Methods that ontrol the backend for signing in
    class SignInMethods{
        @ObservedObject var SegueObject: Segue
        @ObservedObject var userObject: User
        let db = Firestore.firestore()
        init(segue: Segue, user: User){
            SegueObject = segue
            userObject = user
        }
        
        func signIn (email: String, password: String) async {
            do{
                //async sign in
                _ = try await Auth.auth().signIn(withEmail: email, password: password)
               //save the userObejcts UUID as the current users UUID so that in future we may update user if needed
                userObject.UID = Auth.auth().currentUser?.uid ?? ""
                //says it is time to go on to next View
                SegueObject.isTrue = true
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
     
    
    
 
      
    //Sign up View

    struct signUp: View{
        let db = Firestore.firestore()
        @State private var email = ""
        @State private var password = ""
        @State private var userName = ""
        @State private var College = ""
        var body: some View{
            NavigationStack{
                VStack{
                    Text("Sign Up")
                        .bold()
                        .font(.system(size: 35))
                        .padding(.bottom,15)
                    HStack {
                        Image(systemName: "mail")
                        
                        TextField("Email", text: $email)
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 100).stroke(.black, lineWidth: 2))

                    .padding()
                    
                    HStack {
                        Image(systemName:"lock")
                        
                        TextField("Password", text: $password)
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 100).stroke(.black, lineWidth: 2))

                    .padding()
                    
                    HStack {
                        Image(systemName: "person")
                        TextField("User Name", text: $userName)
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 100).stroke(.black, lineWidth: 2))

                    .padding()
                    
                    HStack {
                        
                        Image(systemName: "books.vertical")
                        TextField("College", text: $College)
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 100).stroke(.black, lineWidth: 2))

                    .padding()
                    
                    Button("Sign Up"){
                        
                        signup(email: email.lowercased(), password: password)
                        
                        
                    }
                    .padding(15)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .frame(width: 1000, height: 30)
                }
            }
        }
        
        //The controller and code behind signing up
        func signup(email: String, password: String) {
            //creates user e
            Auth.auth().createUser(withEmail: email.lowercased(), password: password) { authResult, error in
                if (error != nil){
                    print(error?.localizedDescription)
                }
                else{
                    print("Signed Up")
                    //stores a user object with same UUID as its Authentication UUID
                    var newUser : User = User(UserName: userName, Email: email, college: College, UID: Auth.auth().currentUser?.uid ?? "" )
                    
                    db.collection("Users").document(newUser.UID).setData(newUser.makeDict())
                    
                }
                
            }
        }
    }
}

struct LogInAndSignUp_Previews: PreviewProvider {
    static var previews: some View {
        LogInAndSignUp()
    }
}
