//
//  VSDashboardVC.swift
//  DemoVogueStore
//
//  Created by Bharat Byan on 16/08/18.
//  Copyright © 2018 Bharat Byan. All rights reserved.
//

import UIKit

class VSDashboardVC: UIViewController {

    @IBOutlet weak var collectViewProducts: UICollectionView!
    @IBOutlet weak var btnLoyalty: UIButton!
    @IBOutlet weak var btnOffers: UIButton!
    
    @IBOutlet weak var pageControlProducts: UIPageControl!
    
    var lastContentOffset : CGFloat = 0
    
    var arrayModelVogueDashboard: [VSViewModelVogue] = []
    var arrayModelVogueShop: [VSViewModelVogue] = []
    var modelVogueFeatured: VSViewModelVogue?
    
    // MARK:-- View's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateCollectionViewDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateCollectionViewAutoLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segID_VSShopVC" {
            let vc = segue.destination as! VSShopVC
            vc.modelVogueFeatured = modelVogueFeatured
            vc.arrayModelVogueShop = arrayModelVogueShop
        }
    }
    
    // MARK:-- Custom Methods
    
    func updateUI() {
        
        setUpCollectionView()
        
        self.btnOffers.setAttributedTitle(arrayModelVogueDashboard[0].user_Offers, for: .normal)
            
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "imgSmallLogoVogue")
        imageView.image = image
        navigationItem.titleView = imageView
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "imgLeftHamburger"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.showsTouchWhenHighlighted = true
        btn1.addTarget(self, action: #selector(VSDashboardVC.back), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "imgRightUserIcon"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.showsTouchWhenHighlighted = true
        let item2 = UIBarButtonItem(customView: btn2)
        
        self.navigationItem.setLeftBarButtonItems([item1], animated: true)
        self.navigationItem.setRightBarButtonItems([item2], animated: true)
    }
    
    //Setting up collectionview
    func setUpCollectionView() {
        self.collectViewProducts.alpha = 0.0
        
        self.pageControlProducts.currentPage = 0
        self.automaticallyAdjustsScrollViewInsets = false
        
        pageControlProducts.numberOfPages = self.arrayModelVogueDashboard.count
        if arrayModelVogueDashboard.count > 2{
            // Insert text last object in to the first index of photos array
            arrayModelVogueDashboard.insert(arrayModelVogueDashboard.last!, at: 0)
            
            // Add origianl text array's first object (before adding last object at index 0) in the last index of photo array.
            arrayModelVogueDashboard.append(arrayModelVogueDashboard[1])
        }
    }
    
    //updating collectionview values
    func updateCollectionViewDataSource() {
  
        self.btnLoyalty.setAttributedTitle(arrayModelVogueDashboard[0].user_loyaltyPoints, for: .normal)
        
        UIView.animate(withDuration: 0.1, delay: 0.5, options: .curveEaseOut, animations: {
            self.collectViewProducts.alpha = 0.1
            if self.arrayModelVogueDashboard.count > 2{
                self.collectViewProducts.scrollToItem(at: NSIndexPath(row: 1, section: 0)  as IndexPath, at: .centeredHorizontally, animated: true)
            }
            
        }) { _ in
            self.collectViewProducts.alpha = 1.0
        }
    }
    
    // updating collectionview autolayouts
    func updateCollectionViewAutoLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectViewProducts.collectionViewLayout = layout
        self.collectViewProducts!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:0, right: 0)
        
        if let layout = self.collectViewProducts.collectionViewLayout as? UICollectionViewFlowLayout {
            // let itemWidth = view.bounds.width / 3.0
            // let itemHeight = layout.itemSize.height
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: self.collectViewProducts.frame.size.width, height: self.collectViewProducts.frame.size.height)
            layout.invalidateLayout()
        }
    }
    
    //Custom back button
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:-- Outlets
    
    @IBAction func actBtnShop(_ sender: Any) {
        self.performSegue(withIdentifier: "segID_VSShopVC", sender: self)
    }
    
    @IBAction func actBtnEvents(_ sender: Any) {
    }
    
    @IBAction func actBtnPersonalShopper(_ sender: Any) {
    }
    
    @IBAction func actBtnOffers(_ sender: Any) {
    }
    
    @IBAction func actBtnLoyalityPoints(_ sender: Any) {
    }
    
    @IBAction func actBtnPageClicked(_ sender: Any) {
    }
}

// MARK:-- UICollectionViewDelegate, UICollectionViewDataSource
extension VSDashboardVC: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayModelVogueDashboard.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellDashboardProduct", for: indexPath) as! VSDashboardProductCVCell
        
        cell.configureCell(arrayModelVogueDashboard[indexPath.row])
        
        return cell
    }
    
    // overiding scrollview method for pager value updates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.lastContentOffset > scrollView.contentOffset.x {
            if let indexPath = collectViewProducts.indexPathsForVisibleItems.last {
                if indexPath.row > 0  && indexPath.row <= pageControlProducts.numberOfPages{
                    if indexPath.row - 2 < 0{
                        pageControlProducts.currentPage = pageControlProducts.numberOfPages
                    }else{
                        pageControlProducts.currentPage = indexPath.row - 2
                    }
                }else if(indexPath.row > pageControlProducts.numberOfPages){
                    
                    pageControlProducts.currentPage = 0
                }
            }
        }else if self.lastContentOffset < scrollView.contentOffset.x{
            if let indexPath = collectViewProducts.indexPathsForVisibleItems.last {
                if indexPath.row > 0  && indexPath.row <= pageControlProducts.numberOfPages{
                    pageControlProducts.currentPage = indexPath.row - 1
                }else if(indexPath.row > pageControlProducts.numberOfPages){
                    pageControlProducts.currentPage =  0
                }
            }
        }
        self.lastContentOffset = scrollView.contentOffset.x
    }
    
    // overiding scrollview method for infinite collectionview
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let fullyScrolledContentOffset:CGFloat = collectViewProducts.frame.size.width * CGFloat(arrayModelVogueDashboard.count - 1)

        if (scrollView.contentOffset.x >= fullyScrolledContentOffset - collectViewProducts.frame.width/2) {
            collectViewProducts.scrollToItem(at: NSIndexPath(row: 1, section: 0) as IndexPath, at: .centeredHorizontally, animated: false)
        }
        else if (scrollView.contentOffset.x <= 0){
            collectViewProducts.scrollToItem(at:NSIndexPath(row: arrayModelVogueDashboard.count - 2, section: 0)  as IndexPath, at: .centeredHorizontally, animated: false)
        }
    }
}
