//
//  VSShopVC.swift
//  DemoVogueStore
//
//  Created by Bharat Byan on 16/08/18.
//  Copyright © 2018 Bharat Byan. All rights reserved.
//

import UIKit
import AudioToolbox

class VSShopVC: UIViewController {
    
    @IBOutlet weak var collectionProducts: UICollectionView!
    
    var cartValue = 0
    
    var lblBadge = UILabel()
    var btnCart = UIButton()
    
    var modelVogueFeatured: VSViewModelVogue?
    var arrayModelVogueShop: [VSViewModelVogue] = []

    @IBOutlet weak var lblFeaturedTitle: UILabel!
    @IBOutlet weak var lblFeaturedPrice: UILabel!
    @IBOutlet weak var imgFeaturedThumbnail: UIImageView!
    
    // MARK:-- View's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
    }
    
    // MARK:-- Custom Methods
    
    func updateUI() {
        
        lblFeaturedTitle.text = "Featured Item: " + (modelVogueFeatured?.displayName)!
        lblFeaturedPrice.text = modelVogueFeatured?.price
        imgFeaturedThumbnail.image = UIImage(named: (modelVogueFeatured?.thumbnail)!)
        
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        lblTitle.text = "Shop"
        lblTitle.font = UIFont(name: "HelvetiaNeue-Light", size: 20)
        lblTitle.textColor = UIColor.gray
        
        navigationItem.titleView = lblTitle
        
        let btnBack = UIButton(type: .custom)
        btnBack.setImage(UIImage(named: "imgBtnBack"), for: .normal)
        btnBack.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnBack.showsTouchWhenHighlighted = true
        btnBack.addTarget(self, action: #selector(VSDashboardVC.back), for: .touchUpInside)
        let leftNav1 = UIBarButtonItem(customView: btnBack)
    
        btnCart = UIButton(type: .custom)
        btnCart.setImage(UIImage(named: "imgCart"), for: .normal)
        btnCart.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnCart.showsTouchWhenHighlighted = true
        let rightNav1 = UIBarButtonItem(customView: btnCart)
        
        lblBadge = UILabel(frame: CGRect(x: 10, y: -4, width: 20, height: 20))
        lblBadge.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        lblBadge.textColor = UIColor.white
        lblBadge.backgroundColor = UIColor.red
        lblBadge.layer.cornerRadius = 10
        lblBadge.layer.masksToBounds = true
        lblBadge.layer.borderWidth = 0.7
        lblBadge.layer.borderColor = UIColor.white.cgColor
        lblBadge.textAlignment = .center
        lblBadge.adjustsFontSizeToFitWidth = true
        
        self.navigationItem.setLeftBarButtonItems([leftNav1], animated: true)
        self.navigationItem.setRightBarButtonItems([rightNav1], animated: true)
    }
    
    //Custom back button
    @objc func back() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //Adding to cart custom logic
    @objc func addToCart() {
        
        cartValue = cartValue + 1
        btnCart.addSubview(lblBadge)
        lblBadge.text = "\(cartValue)"
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate) // Playing vibration on add to cart
    }
    
    // MARK:-- Outlets
    @IBAction func actBtnAddToCartFeatured(_ sender: Any) {
        self.perform(#selector(addToCart))
    }
}

// MARK:-- UICollectionViewDelegate, UICollectionViewDataSource
extension VSShopVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrayModelVogueShop.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellShopProduct", for: indexPath) as! VSShopProductCVCell
        
        cell.configureCell(arrayModelVogueShop[indexPath.row])
        
        let btn = cell.viewWithTag(101) as! UIButton
        btn.addTarget(self, action: #selector(VSShopVC.addToCart), for: .touchUpInside)
        
        return cell
    }
}
