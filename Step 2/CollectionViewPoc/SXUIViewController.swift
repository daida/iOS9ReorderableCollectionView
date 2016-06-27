//
//  SXUIViewController.swift
//  CollectionViewPoc
//
//  Created by Nicolas Bellon on 24/06/2016.
//  Copyright © 2016 Nicolas Bellon. All rights reserved.
//

/** Based on http://nshint.io/blog/2015/07/16/uicollectionviews-now-have-easy-reordering/ */

import Foundation
import UIKit

class SXUIViewController: UIViewController, UICollectionViewDataSource {
    
    let collectionView =  UICollectionView(frame: CGRectZero, collectionViewLayout: SXUIViewController.flowLayout)
    
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
    
    // MARK: - Handle Gesture
    
    func handleLongPress(longPress: UILongPressGestureRecognizer) {
        switch longPress.state {
        case .Began:

            /** Get the selectPath corresponding to the screen tap position */
            guard let selectedIndexPath = self.collectionView.indexPathForItemAtPoint(longPress.locationInView(self.collectionView)) else { break }

            /** Start cell moving process */
            collectionView.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
            
        case .Changed:

            /** Update cell position during moving process */
            collectionView.updateInteractiveMovementTargetPosition(longPress.locationInView(longPress.view!))
        
        case .Ended:

            /** Ending mooving process, the `UICollectionViewDataSource` `moveItemAtIndexPath` method will be called */
            collectionView.endInteractiveMovement()
        case .Cancelled, .Failed, .Possible:
             collectionView.cancelInteractiveMovement()
        }
    }
    
    // MARK: - Setup
    
    func setupGesture() {
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPress(_:)))
        
        self.collectionView.addGestureRecognizer(longPress)
    }
    
    func setup() {
        self.collectionView.backgroundColor = UIColor.redColor()
        self.view.backgroundColor = UIColor.blueColor()
        
        self.collectionView.registerNib(cellNib, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView.dataSource = self
        
        var constraint = [NSLayoutConstraint]()
        
        constraint += self.collectionView.sx_verticalFill()
        constraint += self.collectionView.sx_horizontalFill()
        
        NSLayoutConstraint.activateConstraints(constraint)
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.setupGesture()
    }
    
    // MARK: - UIViewController override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collectionView)
        
        self.setup()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return consoleModelArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as? PocCell else { return UICollectionViewCell() }
        
        cell.imageView.image = self.consoleModelArray[indexPath.row].image
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        print("Moove")
    }

    
}