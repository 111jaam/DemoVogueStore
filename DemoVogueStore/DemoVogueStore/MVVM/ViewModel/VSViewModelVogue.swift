//
//  VSViewModelVogue.swift
//  DemoVogueStore
//
//  Created by Bharat Byan on 16/08/18.
//  Copyright © 2018 Bharat Byan. All rights reserved.
//
import Foundation


class VSViewModelVogue{
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
    
    // Intialising the viewmodel with model object
    
    init(_ model: VSModelVogue){
        
        title = model.title
        url_thumbnail = model.url_thumbnail
        description = model.description
        thumbnail = model.thumbnail
        thumbnail_small = model.thumbnail_small
        type = model.type
        category = model.category
        details = model.details
        price = model.price
        displayName = model.displayName
        user_loyaltyPoints = model.user_loyaltyPoints
        is_Dashoboard = model.is_Dashoboard
        is_Featured = model.is_Featured
        is_Shop = model.is_Shop
    }
}
