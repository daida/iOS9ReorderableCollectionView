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

/** This custom FlowLayout will fire the moveItemAtIndexPath anytime the cell move, 
    the model array will be updated and the cell size will be updated, in that way the size will not change during the reorder process */
class SXFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForInteractivelyMovingItemAtIndexPath(indexPath: NSIndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        
        guard let dest = super.layoutAttributesForItemAtIndexPath(indexPath)?.copy() as? UICollectionViewLayoutAttributes else { return UICollectionViewLayoutAttributes() }
        
        dest.transform = CGAffineTransformMakeScale(1.4, 1.4)
        
        dest.alpha = 0.8
        
        dest.center = position
        
        dest.zIndex =  NSIntegerMax
        
        return dest
        
    }
    
   override func invalidationContextForInteractivelyMovingItems(targetIndexPaths: [NSIndexPath], withTargetPosition targetPosition: CGPoint, previousIndexPaths: [NSIndexPath], previousPosition: CGPoint) -> UICollectionViewLayoutInvalidationContext {
    
    /** Here the dataSource is called in order to update the model array, so when the size will be requested the correct size will be return */
    self.collectionView?.dataSource?.collectionView?(self.collectionView!, moveItemAtIndexPath: previousIndexPaths[0], toIndexPath: targetIndexPaths[0])
    
    return super.invalidationContextForInteractivelyMovingItems(targetIndexPaths, withTargetPosition: targetPosition, previousIndexPaths: previousIndexPaths, previousPosition: previousPosition)
    }
}

class SXUIViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView =  UICollectionView(frame: CGRectZero, collectionViewLayout: SXUIViewController.flowLayout)
    
    private var consoleModelArray = DataFetcher.consoleModelsFetcher()
    
    private let reuseIdentifier = "com.collectionView.poc"
    
    private var cellNib = UINib(nibName: "PocCell", bundle: nil)
    
    private static let flowLayout: SXFlowLayout = {
        
        let flowLayout = SXFlowLayout()
        
        flowLayout.minimumInteritemSpacing = 2.0
        flowLayout.minimumLineSpacing = 5.0
        flowLayout.scrollDirection = .Vertical
        
        return flowLayout
        
    }()
    
    // MARK: - Handle Gesture
    
    func handleLongPress(longPress: UILongPressGestureRecognizer) {
        

        
        switch longPress.state {
        case .Began:
            
            guard let selectedIndexPath = self.collectionView.indexPathForItemAtPoint(longPress.locationInView(self.collectionView)) else { return }
            
            /** Get the selectPath corresponding to the screen tap position */

            /** Start cell moving process */

            if let cell = collectionView.cellForItemAtIndexPath(selectedIndexPath) {
                UIView.animateWithDuration(0.35, animations: { 
                    cell.transform = CGAffineTransformMakeScale(1.4, 1.4)
                    cell.alpha = 0.8
                }) { _ in
                    self.collectionView.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
                }
            }

            
        case .Changed:

            /** Update cell position during moving process */
            collectionView.updateInteractiveMovementTargetPosition(longPress.locationInView(longPress.view!))
        
        case .Ended:

            /** Ending moving process, the `UICollectionViewDataSource` `moveItemAtIndexPath` method will be called */
            collectionView.endInteractiveMovement()
        case .Cancelled, .Failed, .Possible:
             collectionView.cancelInteractiveMovement()
        }
    }
    
    // MARK: - Setup
    
    func setupGesture() {
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.3
        
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
        self.collectionView.delegate = self
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
    
    /** This method execute the moving process on the model and allow the reorder on the collectionView */
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let src = self.consoleModelArray[sourceIndexPath.row]
        let dest = self.consoleModelArray[destinationIndexPath.row]
        
        self.consoleModelArray[destinationIndexPath.row] = src
        self.consoleModelArray[sourceIndexPath.row] = dest
        
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let factor:CGFloat = 3.0
        
        return CGSize(width: (self.view.frame.size.width / 2.0) - SXUIViewController.flowLayout.minimumLineSpacing, height: self.consoleModelArray[indexPath.row].image.size.height / factor)
    }
    
}