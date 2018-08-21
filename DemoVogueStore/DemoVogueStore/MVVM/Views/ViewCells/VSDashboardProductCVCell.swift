//
//  VSDashboardProductCVCell.swift
//  DemoVogueStore
//
//  Created by Bharat Byan on 16/08/18.
//  Copyright © 2018 Bharat Byan. All rights reserved.
//

import UIKit

class VSDashboardProductCVCell: UICollectionViewCell {
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var viewSubDetails: UIView!
    @IBOutlet weak var btnDetailAction: UIButton!
    @IBOutlet weak var lblSubDetails: UILabel!
    
    //Using viewModel to configue the custom cell
    func configureCell(_ viewModel: VSViewModelVogue)  {
        
        imgProduct.image = UIImage(named: viewModel.thumbnail!)
        
        //Based on types swtiching the view types
        if viewModel.type! == 2{// type fashion shows
            
            viewDetails.isHidden = false
            lblSubDetails.numberOfLines = 2
            lblSubDetails.attributedText = viewModel.details
            btnDetailAction.setTitle("Get Tickets", for: .normal)
        }
        else if viewModel.type! == 3 { // type personal shopper
            
            viewDetails.isHidden = false
            lblSubDetails.text = "Personal Shopper"
            btnDetailAction.setTitle("Book Now", for: .normal)
        }
        else{// type normal product
            
            viewDetails.isHidden = true
        }
    }
}
