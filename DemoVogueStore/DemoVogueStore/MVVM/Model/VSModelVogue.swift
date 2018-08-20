//
//  VSModelVogue.swift
//  DemoVogueStore
//
//  Created by Bharat Byan on 16/08/18.
//  Copyright © 2018 Bharat Byan. All rights reserved.
//
import Foundation
import SwiftyJSON

class VSModelVogue {
    
    var title : String?    
    var description : String?
    var url_thumbnail : URL?
    var thumbnail : String?
    var thumbnail_small : String?
    var type : Int?
    var category : String?
    var details : String?
    var price : String?
    var displayName : String?
    var user_loyaltyPoints : String?
    var is_Dashoboard : Bool?
    var is_Featured : Bool?
    var is_Shop : Bool?
    
    //Initialising model with JSON object
    init(obj:JSON?) {
        self.title = obj!["title"].string
        self.description = obj!["description"].string
        self.url_thumbnail = obj!["imageHref"].url
        self.thumbnail = obj!["thumbnail"].string
        self.thumbnail_small = obj!["thumbnail_small"].string
        self.type = obj!["type"].int
        self.category = obj!["category"].string
        self.details = obj!["details"].string
        self.price = obj!["price"].string
        self.displayName = obj!["displayName"].string
        self.user_loyaltyPoints = obj!["user_loyaltyPoints"].string
        self.is_Dashoboard = obj!["is_Dashoboard"].bool
        self.is_Featured = obj!["is_Featured"].bool
        self.is_Shop = obj!["is_Shop"].bool
    }
}
