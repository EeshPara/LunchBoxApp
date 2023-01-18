//
//  MenuItemImageView.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 1/16/23.
//

import SwiftUI
import FirebaseStorage
struct MenuItemImageView: View {
    let menuItem: MenuItem
    @State var MenuItemImage: UIImage?

    init(menuItem: MenuItem) {
        self.menuItem = menuItem
        
    }

    var body: some View {
        VStack{
            
            Image(uiImage: self.MenuItemImage ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.white.opacity(0.2)]), startPoint: .bottom, endPoint: .top)))
            
        }.shadow(radius: 3, y: 3)
        .task {
            await getMenuItemImage()
        }
                
        
        
    }

    private func getMenuItemImage() {
       
        let pathReference = Storage.storage().reference(withPath: menuItem.itemImage)
        pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error loading image: \(error)")
                } else {
                    if let image = UIImage(data: data!) {
                        self.MenuItemImage = image
                    } else {
                        print("Error creating image from data")
                    }
                }
            }
        }
    }
}

struct MenuItemImageView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemImageView(menuItem: MenuItem())
    }
}
