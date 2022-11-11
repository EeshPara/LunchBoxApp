//
//  User.swift
//  LunchBox
//
//  Created by Rama Parasuramuni on 11/2/22.
//

import Foundation
class User {
    var UserName : String
    var Email : String
    var CardNumber : Int
    var CardHolderName : String
    var ExpiryDate : String
    var CVV : Int
    init(UserName: String, Email: String, CardNumber: Int, CardHolderName: String, ExpiryDate: String, CVV: Int) {
        self.UserName = UserName
        self.Email = Email
        self.CardNumber = CardNumber
        self.CardHolderName = CardHolderName
        self.ExpiryDate = ExpiryDate
        self.CVV = CVV
    }
}

