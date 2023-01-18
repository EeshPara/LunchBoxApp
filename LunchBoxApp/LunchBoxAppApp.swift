//
//  LunchBoxAppApp.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 11/4/22.
//

import SwiftUI
import Firebase


@main
struct LunchBoxAppApp: App {
    init(){
        FirebaseApp.configure()
        
    }
    
    
    var body: some Scene {
        WindowGroup {
                LogInAndSignUp()
           
        }
    }
}
