//
//  AdminPanel1.swift
//  LunchBox
//
//  Created by Rama Parasuramuni on 11/2/22.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore
struct AdminPanel1: View {
    let db = Firestore.firestore()
    @ObservedObject var restaurant : Restaurant
    @State private var RestaurantName = ""
    @State private var RestaurantDisc = ""
    @State private var RestaurantCollege = ""
    @State private var RestaurantDailyDiscount = 0.0
    //@State private var RestaurantHappyHourTimes = ""
    // @State private var RestaurantHappyHourDiscount = 0.0
    @State private var menu : Array<MenuItem> = []
    @State private var subPacks : Array<SubPack> = []
    @State var selectedItems : [PhotosPickerItem] = []
    @State var data: Data?
    @State var filePath = ""
    @State var colleges: Array<String> = []
    @State var selected = ""
    @State var college = ""
    var body: some View {
        
        VStack{
            
            
            HStack{
                
                Text("Store Init")
                    .bold()
                    .font(.system(size: 35))
                    .padding(.bottom,15)
                Button("Save") {
                    initilize()
                    uploadPhoto()
                }
                .padding(.bottom, 20)
                .padding(.leading, 75)
                .buttonStyle(.borderedProminent)
                .backgroundStyle(Color(.purple))
            }
            
            Form {
                //Restaurant Info
                TextField("RestaurantName", text: $RestaurantName)
                    .disableAutocorrection(true)
                TextField("RestaurantDisc", text: $RestaurantDisc)
                    .disableAutocorrection(true)
                TextField("DailyDiscount", value: $RestaurantDailyDiscount, format: .number)
                    .disableAutocorrection(true)
                HStack{
                    
                    Menu("College"){
                        ForEach(colleges, id: \.self){ college in
                            Button(college){
                                selected = college
                                setCollege(college:college)
                               
                            }
                            
                        }
                        
                    }
                    Text(":  \(selected)")
                }
                //Upload Restaurant Photo
                if let data = data, let UIImage = UIImage(data: data){
                    Image(uiImage: UIImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                }
                
                PhotosPicker(selection: $selectedItems,maxSelectionCount: 1,  matching: .images) {
                    Text("Upload Restaurant Photos")
                    
                }.onChange(of: selectedItems) { newValue in
                    Task{
                        if let dataVar = try? await newValue.first?.loadTransferable(type: Data.self) {
                            data = dataVar
                        }
                    }
                }
                
            }
           
        }
        .task {
            await getColleges()
        }
    }
    
    @MainActor
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
    
    
    func initilize(){
        
        
        restaurant.ResterauntName = RestaurantName
        restaurant.RestaurantDisc = RestaurantDisc
        restaurant.dailyDiscount = RestaurantDailyDiscount
        restaurant.ResterauntImage = filePath
        restaurant.RestaurantCollege = selected
        
        
        
        
    }
    
    func setCollege(college : String){
        restaurant.RestaurantCollege = college
    }
    
    
     func uploadPhoto(){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        // Create a reference to 'images/mountains.jpg'
        filePath = "RestaurantImages/\(restaurant.ResterauntName).jpg"
         restaurant.ResterauntImage = filePath
        let RestaurantImagesRef = storageRef.child(filePath)
         if data != nil{
             let uploadTask =  RestaurantImagesRef.putData(data! , metadata: nil) { (metadata, error) in
                 guard let metadata = metadata else {
                     // Uh-oh, an error occurred!
                     return
                 }
             }
         }
        
        
    }
    
    
    
    struct AdminPanel1_Previews: PreviewProvider {
        static var previews: some View {
            AdminPanel1(restaurant: Restaurant())
        }
    }
    
}
