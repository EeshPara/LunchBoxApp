//
//  User.swift
//  LunchBox
//
//  Created by Rama Parasuramuni on 11/2/22.
//

import Foundation
class User : ObservableObject{
    @Published var UserName : String
    @Published var Email : String
    @Published var college : String
    var UID : String
    var coupons : Array<Coupon>
    init(){
        UserName = ""
        Email = ""
        college = ""
        UID = ""
        coupons = []
    }
    init(UserName: String, Email: String, college: String, UID: String) {
        self.UserName = UserName
        self.Email = Email
        self.college = college
        self.UID = UID
        coupons = []
    }
    func makeDict()-> Dictionary<String,Any>{
        var dict : Dictionary<String,Any> = [:]
        dict["Username"] = UserName
        dict["Email"] = Email
        dict["College"] = college
        dict["UID"] = UID
        var coups :  Array<Dictionary<String,Any>> = []
        for coupon in coupons {
            coups.append(coupon.makeDict())
        }
        dict["Coupons"] = coups
        return dict
    }
}

