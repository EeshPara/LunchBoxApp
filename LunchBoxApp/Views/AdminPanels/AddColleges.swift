//
//  AddColleges.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 1/28/23.
//

import SwiftUI
import FirebaseFirestore
struct AddColleges: View {
    @State var college : String = ""
    let db = Firestore.firestore()
    var body: some View {
        VStack{
            Text("Add Colleges")
                .bold()
                .font(.system(size: 40))
            Form{
                HStack{
                    TextField("Enter CollegeName", text: $college)
                    Button("Add"){
                        addCollege()
                    }
                }
            }
        }
    }
    
    func addCollege(){
        db.collection("Colleges").document(college).setData(["CollegeName": college])  
        
    }
}

struct AddColleges_Previews: PreviewProvider {
    static var previews: some View {
        AddColleges()
    }
}
