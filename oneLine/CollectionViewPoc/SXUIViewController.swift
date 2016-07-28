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
class SXFlowLayout: UICollectionViewLayout {

    
    override func layoutAttributesForInteractivelyMovingItemAtIndexPath(indexPath: NSIndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        
        let dest = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        dest.frame = self.cellRectForIndexPath(indexPath)
        
        dest.transform = CGAffineTransformMakeScale(1.4, 1.4)
        
        dest.alpha = 0.8
        
        dest.center = position
        
        dest.zIndex =  NSIntegerMax
        
        return dest
        
    }

    
    var attributesCache = [UICollectionViewLayoutAttributes]()
    
    var attributesCacheToModify = [UICollectionViewLayoutAttributes]()
    let minimumLineSpacing: CGFloat = 20
    
    override func prepareLayout() {
        guard let collectionView = self.collectionView else { return }
        
        if attributesCache.count != 0 { return }
        
        for i in 0..<collectionView.numberOfItemsInSection(0) {
            
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attribute.frame = self.cellRectForIndexPath(indexPath)
            
            self.attributesCache.append(attribute)
        }
        
    }
    
    func cellRectForIndexPath(indexPath: NSIndexPath) -> CGRect {
        
        guard let collectionView = self.collectionView, flowLayoutAttribute = collectionView.delegate as? UICollectionViewDelegateFlowLayout, cellSize = flowLayoutAttribute.collectionView?(collectionView, layout: self, sizeForItemAtIndexPath: indexPath) else { return .zero }
    
        let x = (CGFloat(indexPath.row) * cellSize.width) + (CGFloat(indexPath.row) * self.minimumLineSpacing)
        
        let origin = CGPoint(x: x, y: 0)
        
        return CGRect(origin: origin, size: cellSize)
        
    }
    
    override func collectionViewContentSize() -> CGSize {
    
        guard let collectionView = self.collectionView, flowLayoutAttribute = collectionView.delegate as? UICollectionViewDelegateFlowLayout else { return CGSizeZero }
        
        var width:CGFloat = 0
        
        for i in 0..<collectionView.numberOfItemsInSection(0) {
            if let cellSize = flowLayoutAttribute.collectionView?(collectionView, layout: self, sizeForItemAtIndexPath: NSIndexPath(forItem: i, inSection: 0)) {
                width = width + cellSize.width + self.minimumLineSpacing
            }
        }
        
        return CGSize(width: width, height: collectionView.frame.height)
        
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        self.attributesCache.removeAll()
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var dest = [UICollectionViewLayoutAttributes]()
        
        for attribute in self.attributesCache {
            if CGRectIntersectsRect(rect, attribute.frame) {
                dest.append (attribute)
            }
        }
        
        if dest.count > 0 { return dest }
        
        return nil
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        for attribute  in self.attributesCache {
            if attribute.indexPath == indexPath {
                return attribute
            }
        }
        
        return nil
    }
    
}

class SXUIViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView =  UICollectionView(frame: CGRectZero, collectionViewLayout: SXUIViewController.flowLayout)
    
    private var consoleModelArray = DataFetcher.consoleModelsFetcher()
    
    private let reuseIdentifier = "com.collectionView.poc"
    
    private var cellNib = UINib(nibName: "PocCell", bundle: nil)
    
    private static let flowLayout: SXFlowLayout = {
        
        let flowLayout = SXFlowLayout()
        
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
        
        constraint += self.collectionView.sx_topSnap(120)
        constraint += self.collectionView.sx_horizontalFill()
        constraint += self.collectionView.sx_fixedHeight(100)
        
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
    
        
        return CGSize(width: 80, height: 40)
    }
    
}