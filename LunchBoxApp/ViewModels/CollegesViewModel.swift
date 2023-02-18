//
//  CollegesViewModel.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 1/31/23.
//
 
import SwiftUI
import FirebaseFirestore
struct CollegesViewModel {
    let db = Firestore.firestore()
    @Binding var colleges : Array<String>
    func getColleges() async{
        do{
            let documents = try await db.collection("Colleges").getDocuments()
            for document in documents.documents{
                colleges.append(document.data()["CollegeName"] as! String)
            }
           
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
}
