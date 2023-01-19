//
//  AdminPanel3MenuInit.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 11/13/22.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
struct AdminPanel3MenuInit: View {
    @ObservedObject var restaurant : Restaurant
    @State private var MenuItemName = ""
    @State private var MenuItemPrice = 0.0
    @State private var MenuItemDisc = ""
    @State private var MenuItemType = ""
    @State private var MenuItemIsDiscountOfTheDay = false
    @State private var typesString = ""
    @State private var Types = [""]
    @State private var typesConfirmed = false
    @State private var currMenu : Array<MenuItem> = []
    @State var itemtoAdd =  MenuItem()
    @State var selectedItems : [PhotosPickerItem] = []
    @State var data: Data?
    @State var filePath = ""
    var body: some View {
        
        VStack{
            Text("MenuInit")
                .bold()
                .font(.system(size: 35))
                .padding(.bottom,15)
            
            
            
            Form{
                TextField("Types", text: $typesString)
                    .disableAutocorrection(true)
                Button("ConfirmTypes"){
                    Types = typesString.components(separatedBy: ",")
                    typesConfirmed = true;
                    restaurant.ItemTypes = Types
                    print(typesConfirmed)
                    print(restaurant.ItemTypes)
                }
                .padding(.leading,110)
            }
            .frame(height: 150)
            
            Form{
                
                //MenuItems Initialization
                TextField("MenuItemName", text: $MenuItemName)
                    .disableAutocorrection(true)
                TextField("MenuItemDisc", text: $MenuItemDisc)
                    .disableAutocorrection(true)
                TextField("MenuItemPrice", value: $MenuItemPrice, format: .number)
                    .disableAutocorrection(true)
                HStack{
                    Menu("IsMenuOfTheDay"){
                        Button("True"){
                            setIfMenuOfTheDay(answer: true)
                        }
                        Button("False"){
                            setIfMenuOfTheDay(answer: false)
                        }
                        
                    }
                    var stringIsDiscountOfTheDay = String(MenuItemIsDiscountOfTheDay)
                    
                    Text(" :  \(stringIsDiscountOfTheDay)")
                }
                
                HStack{
                    Menu("Type"){
                        
                        ForEach(Types, id: \.self){type in
                            
                            Button(type){
                                setType(type:type)
                            }
                        }
                        
                    }
                    Text("  :\(MenuItemType)")
                }
                
                //Upload MenuItem Photo
                if let data = data, let UIImage = UIImage(data: data){
                    Image(uiImage: UIImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
                
                PhotosPicker(selection: $selectedItems,maxSelectionCount: 1,  matching: .images) {
                    Text("Upload Photo")
                    
                }.onChange(of: selectedItems) { newValue in
                    Task{
                        if let dataVar = try? await newValue.first?.loadTransferable(type: Data.self) {
                            data = dataVar
                        }
                    }
                }
                    
                    
                    Button("add") {
                        uploadPhoto()
                       
                        itemtoAdd = MenuItem(Itemname: MenuItemName, Itemprice: MenuItemPrice, ItemDisc: MenuItemDisc, type: MenuItemType, discountofTheDay: MenuItemIsDiscountOfTheDay, itemRestaurant: restaurant.ResterauntName)
                       
                        addItem(ItemToAdd: itemtoAdd)
                        
                        
                    }
                    .padding(.leading,140)
                }
                // Menu List Area
            HStack{
                Text("Menu")
                    .bold()
                    .font(.system(size: 30))
                    .padding(.bottom,10)
                
                Button("Save Menu"){
                    restaurant.MenuItems = currMenu
                    print(restaurant.makeDict())
                }
                .buttonStyle(.borderedProminent)
                .padding(.leading,80)
            }
                
                List{
                    ForEach(currMenu){ MenuItem in
                        HStack{
                            VStack{
                                Text(MenuItem.Itemname)
                                    .padding(.trailing,100)
                                    .padding(.top,0)
                                Text(MenuItem.type)
                                    .padding(.trailing,100)
                                    .font(.system(size: 10))
                            }
                            
                            let priceRounded = String(format: "%g", MenuItem.Itemprice)
                            Text("Price: \(priceRounded)")
                        }
                        
                    }.onDelete { indexSet in
                        delete(index: indexSet)
                    }
                    
                }
                
                
                
                
                
                
            }
            
        }
    func setIfMenuOfTheDay(answer: Bool){
        itemtoAdd.discountOfTheDay = answer
    }
    
    
    func uploadPhoto(){
       let storage = Storage.storage()
       let storageRef = storage.reference()
       
        filePath = "MenuImages/\(restaurant.ResterauntName)/\(MenuItemName).jpg"
       let MenuImagesRef = storageRef.child("MenuImages/\(restaurant.ResterauntName)")
        let MenuItemImageRef = MenuImagesRef.child("/\(MenuItemName).jpg")
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
            ItemToAdd.itemImage = filePath
            currMenu.append(ItemToAdd)
            itemtoAdd = MenuItem(Itemname: "", Itemprice: 0.0, ItemDisc: "", type: MenuItemType, discountofTheDay: false, itemRestaurant: "")
        }
        func setType(type: String){
            MenuItemType = type
        }
        func getMenu() -> Array<MenuItem>{return currMenu}
        func getTypesConfirmed() -> Bool{return typesConfirmed}
        func getTypes()-> Array<String>{return Types}
        func delete(index: IndexSet){
            currMenu.remove(atOffsets: index)
        }
    }
    
    struct AdminPanel3MenuInit_Previews: PreviewProvider {
        static var previews: some View {
            AdminPanel3MenuInit(restaurant: Restaurant())
        }
    }

