//
//  EditRestaurants.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 1/31/23.
//

import SwiftUI
import FirebaseFirestore
import PhotosUI
import FirebaseStorage

struct EditRestaurants: View {
    @State var restaurants : Array<Restaurant> = []
    @State var colleges: Array<String> = []
    @State var selected = ""
    let db = Firestore.firestore()
    @State var rm = reusableMethods()
    var body: some View {
        NavigationStack{
            VStack{
                Text("Edit")
                    .bold()
                    .font(.system(size: 35))
                    .padding(.bottom,15)
                
                HStack{
                    
                    Menu("College"){
                        ForEach(colleges, id: \.self){ college in
                            Button(college){
                                selected = college
                                Task{
                                    restaurants = []
                                    await getRestaurants()
                                }
                            }
                            
                        }
                        
                    }
                    Text(":  \(selected)")
                }
                
                
                
                List(restaurants) { restaurant in
                    
                    HStack{
                        Text(restaurant.ResterauntName)
                        NavigationLink(""){
                            
                            RestaurantEditor(currRestaurant: restaurant, college: selected)
                            
                        }
                    }
                }
            }
            
        }.task {
            colleges = []
            await CollegesViewModel(colleges: $colleges).getColleges()
        }
    }
    
    
    
    
    
    @MainActor
    func getRestaurants() async {
        
      restaurants = []
        
        do{
            let documents = try await db.collection("Colleges").document(selected).collection("Restaurants").getDocuments()
            for document in documents.documents{
                restaurants.append(rm.restDictToRestObject(dict: document.data()))
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
        
        
    }
}

struct EditRestaurants_Previews: PreviewProvider {
    static var previews: some View {
        EditRestaurants()
    }
}


struct RestaurantEditor: View {
    @State var currRestaurant : Restaurant
    @State var college : String
    @State var showPopover = false
    @State var currentItemDiscount = 0.0
    @State var currMenuItem = MenuItem()
    @State var addedMenuitemName = ""
    @State var addedMenuItemDesc = ""
    @State var addedMenuItemPrice = 0.0
    @State var itemtoAdd = MenuItem()
    @State var currMenu : Array<MenuItem> = []
    @State var data: Data?
    @State var selectedItems : [PhotosPickerItem] = []
    @State var filePath = ""
    let db = Firestore.firestore()
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Text(currRestaurant.ResterauntName)
                        .bold()
                        .font(.system(size: 35))
                        .padding(.bottom,15)
                    Button("Save"){
                        
                        currRestaurant.MenuItems = currMenu
                        db.collection("Colleges").document(college).collection("Restaurants").document(currRestaurant.RestaurantUID).setData(currRestaurant.makeDict())
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                }
                
                List{
                    ForEach(currMenu){ menuItem in
                        HStack{
                            VStack{
                                Text(menuItem.Itemname)
                                    .bold()
                                    .font(.system(size:20))
                                
                                Text(menuItem.ItemDisc)
                                    .font(.system(size:12))
                                
                            }
                            VStack{
                                let price =  String(format: "%.2f", (menuItem.Itemprice) * 0.9)
                                Text("Price: \( price)")
                                
                            }
                            Spacer()
                            
                      
                            
                            
                            
                            
                        }
                    }.onDelete { indexSet in
                        delete(index: indexSet)
                    }
                }
                Button("Add Item"){
                    showPopover = true
                }
                
            }
        }
        .task {
            currMenu = currRestaurant.MenuItems
        }
        .popover(isPresented: $showPopover){
            Form{
               MakeMenuItem(MenuItemName: $addedMenuitemName, MenuItemPrice: $addedMenuItemPrice, MenuItemDisc: $addedMenuItemDesc, data: $data, selectedItems: $selectedItems)
            }
            Button("Add"){
                uploadPhoto()
                itemtoAdd = MenuItem(Itemname: addedMenuitemName, Itemprice: addedMenuItemPrice, ItemDisc: addedMenuItemDesc, type: "", discountofTheDay: false, itemRestaurant: currRestaurant.ResterauntName)
                itemtoAdd.itemImage = filePath
                addItem(ItemToAdd: itemtoAdd)
                showPopover = false
            }
        }
    }
    
    func uploadPhoto(){
       let storage = Storage.storage()
       let storageRef = storage.reference()
     
        filePath = "MenuImages/\(currRestaurant.ResterauntName)/\(addedMenuitemName).jpg"
       let MenuImagesRef = storageRef.child("MenuImages/\(currRestaurant.ResterauntName)")
        let MenuItemImageRef = MenuImagesRef.child("/\(addedMenuitemName).jpg")
        if data != nil{
            let uploadTask =  MenuItemImageRef.putData(data! , metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
        
       
       
   }
    
    func addItem(ItemToAdd: MenuItem){
    
        currMenu.append(ItemToAdd)
        itemtoAdd = MenuItem()
    }
    
    func delete(index: IndexSet){
        currMenu.remove(atOffsets: index)
    }
    
}
