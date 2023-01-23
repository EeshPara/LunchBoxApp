//
//  MenuItemView.swift
//  LunchBoxApp
//
//  Created by Rama Parasuramuni on 1/18/23.
//

import SwiftUI

struct MenuItemView: View {
    @State var menuItem : MenuItem
    init(menuItem: MenuItem) {
        self.menuItem = menuItem
    }
    var body: some View {
        VStack{
            LargeMenuItemImageView(menuItem: menuItem)
            Spacer()
        }
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemView(menuItem: MenuItem())
    }
}
