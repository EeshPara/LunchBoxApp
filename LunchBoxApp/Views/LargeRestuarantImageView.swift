//
//  RestaurantViewBuilder.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 1/15/23.
//

import SwiftUI
import FirebaseStorage
struct LargeRestaurantImageView: View {
    let restaurant: Restaurant
    @State var restaurantImage: UIImage?

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        
    }

    var body: some View {
        VStack{
            Image(uiImage: self.restaurantImage ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 400, height: 300)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.85), Color.white.opacity(0.2)]), startPoint: .bottom, endPoint: .top)))
            
        }
        .allowsHitTesting(false)
        
        .task {
            getRestaurantImage()
        }
                
        
        
    }

    private func getRestaurantImage() {
       
        let pathReference = Storage.storage().reference(withPath: restaurant.ResterauntImage)
        pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error loading image: \(error)")
                } else {
                    if let image = UIImage(data: data!) {
                        self.restaurantImage = image
                    } else {
                        print("Error creating image from data")
                    }
                }
            }
        }
    }
}
