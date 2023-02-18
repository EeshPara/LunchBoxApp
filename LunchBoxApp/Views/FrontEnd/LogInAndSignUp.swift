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
                       SignUpView()
                    }
                    .navigationBarBackButtonHidden(true)
                    .padding(.bottom, 10)
    
                    Button("Sign In"){
                        Task{
                            await SignInMethods(segue: segueObject, userObject: user).signIn(email: email, password: password)
                            
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
    
    

     
       
}


struct LogInAndSignUp_Previews: PreviewProvider {
    static var previews: some View {
        LogInAndSignUp()
    }
}
