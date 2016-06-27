//
//  SXCollectionView.swift
//  CollectionViewPoc
//
//  Created by Nicolas Bellon on 23/06/2016.
//  Copyright © 2016 Nicolas Bellon. All rights reserved.
//

/** Based on http://nshint.io/blog/2015/07/16/uicollectionviews-now-have-easy-reordering/ */

import Foundation
import UIKit

class SXCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Private variable
    
    private let consoleModelArray = DataFetcher.consoleModelsFetcher()
    
    private let reuseIdentifier = "com.collectionView.poc"
    
    private var cellNib = UINib(nibName: "PocCell", bundle: nil)
    
    private static let flowLayout: UICollectionViewFlowLayout = {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.minimumInteritemSpacing = 2.0
        flowLayout.minimumLineSpacing = 5.0
        flowLayout.itemSize = CGSize(width: 100.0, height: 100.0)
        flowLayout.scrollDirection = .Horizontal

        return flowLayout
        
    }()

    // MARK: - UIViewController override
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: - Init
    
    func setup() {
        self.collectionView?.backgroundColor = UIColor.redColor()
        self.view.backgroundColor = UIColor.blueColor()
        
        self.collectionView?.registerNib(cellNib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    /** Init from Storyboard or xib */
    init() {
        super.init(collectionViewLayout: SXCollectionViewController.flowLayout)
    }
    
    /** Init from Storyboard or xib */
    required init?(coder aDecoder: NSCoder) {
        
        super.init(collectionViewLayout: SXCollectionViewController.flowLayout)
    }
    
    // MARK: - UICollectionViewController override

    // MARK: Reorder
    
    /** Override this method allow cell to be reordered only on iOS 9.0 */
    override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        print("Move")
    }
    
    // MARK: DataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return consoleModelArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as? PocCell else { return UICollectionViewCell() }
        
        cell.imageView.image = self.consoleModelArray[indexPath.row].image
        
        return cell
    }
}