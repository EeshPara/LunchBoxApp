//
//  MakeMenuItem.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 2/1/23.
//

import SwiftUI
import PhotosUI
struct MakeMenuItem: View {
    @Binding var MenuItemName : String
    @Binding var MenuItemPrice : Double
    @Binding var MenuItemDisc : String
    @Binding var data : Data?
    @Binding var selectedItems : [PhotosPickerItem]
    var body: some View {
        //MenuItems Initialization
        TextField("MenuItemName", text: $MenuItemName)
            .disableAutocorrection(true)
        TextField("MenuItemDisc", text: $MenuItemDisc)
            .disableAutocorrection(true)
        TextField("MenuItemPrice", value: $MenuItemPrice, format: .number)
            .disableAutocorrection(true)
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
    }
   
}


