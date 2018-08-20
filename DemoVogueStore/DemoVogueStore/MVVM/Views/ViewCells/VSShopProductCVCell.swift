//
//  VSShopProductCVCell.swift
//  DemoVogueStore
//
//  Created by Bharat Byan on 18/08/18.
//  Copyright © 2018 Bharat Byan. All rights reserved.
//

import UIKit

class VSShopProductCVCell: UICollectionViewCell {
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var imgProductThumb: UIImageView!
    @IBOutlet weak var btnAddCart: UIButton!
    
    //Using viewModel to configue the custom cell
    func configureCell(_ viewModel: VSViewModelVogue)  {
    
        lblProductTitle.text = viewModel.displayName
        lblProductPrice.text = viewModel.price
        imgProductThumb.image = UIImage(named: viewModel.thumbnail_small!)
    }
}
