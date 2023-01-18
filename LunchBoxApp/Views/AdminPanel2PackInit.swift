//
//  AdminPanel2PackInit.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 11/13/22.
//

import SwiftUI
import Firebase

struct AdminPanel2PackInit: View {
    @ObservedObject var restaurant : Restaurant
    @State private var packs: Array<SubPack> = []
    @State private var types = [""]
    @State private var typesofCurrPack = [""]
    @State private var price = 0.0
    @State private var packName = ""
    @State private var amtSaved = 0.0
    @State private var currType = ""
    @State private var MenuInit = AdminPanel3MenuInit(restaurant: Restaurant())
    let db = Firestore.firestore()
    
    
    
    var body: some View {
        VStack{
            
            Text("Sub Init")
                .bold()
                .font(.system(size: 35))
                .padding(.bottom,15)
            
            Button("SetTypes") {
                print(restaurant.ItemTypes)
                types = restaurant.ItemTypes
                print(types)
                
            }
            .padding(.top, 20)
            .padding(.leading,5)
            .buttonStyle(.borderedProminent)
            
            Form{
                TextField("PackName", text: $packName)
                    .disableAutocorrection(true)
                TextField("PackPrice", value: $price, format: .number)
                    .disableAutocorrection(true)
                TextField("AmountSaved", value: $amtSaved, format: .number)
                    .disableAutocorrection(true)
                
                    HStack{
                        Menu("Type"){
                            
                            ForEach(types, id: \.self){type in
                                
                                Button(type){
                                    setType(type:type)
                                    typesofCurrPack.append(type)
                                
                                }
                            }
                            
                        }
                        Text("  :\(currType)")
                            .padding(.trailing, 50)
                        Button("add"){
                            add(subpack: SubPack(packName: packName, packPrice: price, amountSaved: amtSaved, packTypes: typesofCurrPack))
                            typesofCurrPack = []
                        }
                        .padding(.leading, 50)
                    }
                
                
                ForEach(typesofCurrPack, id:\.self){type in
                    Text(type)
                    
                }
                
            }
            .padding(.bottom,10)
            HStack{
                Text("Current Packs")
                    .bold()
                    .font(.system(size: 25))
                Button("Save"){
                    restaurant.SubscriptionPacks = packs
                    db.collection("Restaurants").addDocument(data: restaurant.makeDict())
                   
                }
                .buttonStyle(.borderedProminent)
                    .padding(.leading,80)
            }
                
            List{
                ForEach(packs){ pack in
                    HStack{
                        
                        Text(pack.packName)
                            .padding(.trailing, 50)
                        let priceRounded = String(format: "%g", pack.packPrice)
                        Text("Price: \(priceRounded)")
                            .padding(.leading,50)
                        
                    }
                    
                }
            }
         
            
        }
        
    }
    
    
    func getPacks() -> Array<SubPack>{
        return packs
    }
       
    func setType(type: String){
            currType = type
    }
    func add(subpack: SubPack){
        packs.append(subpack)
    }
    
}




struct AdminPanel2PackInit_Previews: PreviewProvider {
    static var previews: some View {
        AdminPanel2PackInit(restaurant: Restaurant())
    }
}
