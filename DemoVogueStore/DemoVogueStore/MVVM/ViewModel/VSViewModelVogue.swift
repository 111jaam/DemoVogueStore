//
//  VSViewModelVogue.swift
//  DemoVogueStore
//
//  Created by Bharat Byan on 16/08/18.
//  Copyright © 2018 Bharat Byan. All rights reserved.
//
import Foundation
import UIKit

class VSViewModelVogue{
    var title : String?
    var description : String?
    var url_thumbnail : URL?
    var thumbnail : String?
    var thumbnail_small : String?
    var type : Int?
    var category : String?
    var details : NSMutableAttributedString?
    var price : String?
    var displayName : String?
    var user_Offers : NSMutableAttributedString?
    var user_loyaltyPoints : NSMutableAttributedString?
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
       
        price = model.price
        displayName = model.displayName
        
        is_Dashoboard = model.is_Dashoboard
        is_Featured = model.is_Featured
        is_Shop = model.is_Shop
       
        // Constructing subDetails within viewmodel for viewcontroller (MVVM)
        if model.type! == 2{// type fashion shows
            
            let strDetails = "Fashion Show"
            let str_SubDetails = model.details
            let strTitle_Details = NSMutableAttributedString(string: strDetails + "\n" + str_SubDetails!)
            
            if let font1 = UIFont(name: "HelveticaNeue-Medium", size: 16), let font2 = UIFont(name: "HelveticaNeue-Light", size: 14){
                strTitle_Details.addAttribute(NSAttributedString.Key.font, value: font1, range: NSMakeRange(0, strDetails.count))
                strTitle_Details.addAttribute(NSAttributedString.Key.font, value: font2, range: NSMakeRange(strDetails.count, str_SubDetails!.count+1))
            }
            
             details = strTitle_Details
        }
        
        
        // Constructing user offers within viewmodel for viewcontroller (MVVM)
        let newOffers = model.user_Offers!
        let strOffers = "\(newOffers) new offer."
        let strTitle_Offer = NSMutableAttributedString(string: "Offers\n" + strOffers)
        
        if let font1 = UIFont(name: "HelveticaNeue-Medium", size: 16), let font2 = UIFont(name: "HelveticaNeue-Light", size: 14){
            strTitle_Offer.addAttribute(NSAttributedString.Key.font, value: font1, range: NSMakeRange(0, 6))
            strTitle_Offer.addAttribute(NSAttributedString.Key.font, value: font2, range: NSMakeRange(6, strOffers.count+1))
        }
        
        user_Offers = strTitle_Offer
        
        
        // Constructing user loyality points within viewmodel for viewcontroller (MVVM)
        let count = model.user_loyaltyPoints
        let strPoints = count! + "pts."
        let strTitle_Points = NSMutableAttributedString(string: "Loyalty\n" + strPoints)
        
        if let font1 = UIFont(name: "HelveticaNeue-Medium", size: 16), let font2 = UIFont(name: "HelveticaNeue-Light", size: 14){
            strTitle_Points.addAttribute(NSAttributedString.Key.font, value: font1, range: NSMakeRange(0, 7))
            strTitle_Points.addAttribute(NSAttributedString.Key.font, value: font2, range: NSMakeRange(7, strPoints.count+1))
        }
        
        user_loyaltyPoints = strTitle_Points
    }
}
