import UIKit

extension UIView {
    func sx_verticallyCenter(margin: CGFloat = 0) -> [NSLayoutConstraint] {
        if let superview = self.superview {
            return [NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: superview, attribute: .CenterY, multiplier: 1, constant: margin)]
        }
        return []
    }
    
    func sx_horizontalCenter(margin: CGFloat = 0) -> [NSLayoutConstraint] {
        if let superview = self.superview {
            return [NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: superview, attribute: .CenterX, multiplier: 1, constant: margin)]
        }
        return []
    }
    
    func sx_leadingSnap(margin: CGFloat = 0) -> [NSLayoutConstraint] {
        if let superview = self.superview {
            return [NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: superview, attribute: .Leading, multiplier: 1, constant: margin)]
        }
        return []
    }
    
    func sx_trailingSnap(margin: CGFloat = 0) -> [NSLayoutConstraint] {
        if let superview = self.superview {
            return [NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: superview, attribute: .Trailing, multiplier: 1, constant: -margin)]
        }
        return []
    }
    
    func sx_horizontalFill(margin: CGFloat = 0) -> [NSLayoutConstraint] {
        return self.sx_leadingSnap(margin) + self.sx_trailingSnap(margin)
    }
    
    
    func sx_topSnap(margin: CGFloat = 0) -> [NSLayoutConstraint] {
        if let superview = self.superview {
            return [NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: superview, attribute: .Top, multiplier: 1, constant: margin)]
        }
        return []
    }
    
    func sx_bottomSnap(margin: CGFloat = 0) -> [NSLayoutConstraint] {
        if let superview = self.superview {
            return [NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: superview, attribute: .Bottom, multiplier: 1, constant: -margin)]
        }
        return []
    }
    
    func sx_verticalFill(margin: CGFloat = 0) -> [NSLayoutConstraint] {
        return self.sx_topSnap(margin) + self.sx_bottomSnap(margin)
    }
    
    func sx_fixedHeight(height: CGFloat) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: height)]
    }
    
    func sx_fixedWidth(width: CGFloat) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: width)]
    }
    
    func sx_fixedSize(size: CGSize) -> [NSLayoutConstraint] {
        return sx_fixedWidth(size.width) + sx_fixedHeight(size.height)
    }
    
    
    func sx_verticalAfter(view: UIView, margin: CGFloat = 0) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: margin)]
    }

    func sx_verticalBefore(view: UIView, margin: CGFloat = 0) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: -margin)]
    }

    func sx_horizontalAfter(view: UIView, margin: CGFloat = 0) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: margin)]
    }

    func sx_horizontalBefore(view: UIView, margin: CGFloat = 0) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: -margin)]
    }

    func sx_aspectRatioSize(aspectRatio: CGFloat) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: aspectRatio, constant:0)]
    }


    func sx_equalWidth(view: UIView, multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: multiplier, constant: constant)]
    }

    func sx_equalHeight(view: UIView, multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: multiplier, constant: constant)]
    }
}



extension Array where Element: NSLayoutConstraint {
    
    func priority(priority: UILayoutPriority) -> [NSLayoutConstraint] {
        return self.map { (l: NSLayoutConstraint) -> NSLayoutConstraint in
            l.priority = priority
            return l
        }
    }
    
    func relatedBy(relation: NSLayoutRelation) -> [NSLayoutConstraint] {
        return self.map { (l: NSLayoutConstraint) -> NSLayoutConstraint in
            let lNew = NSLayoutConstraint(item: l.firstItem, attribute: l.firstAttribute, relatedBy: relation, toItem: l.secondItem, attribute: l.secondAttribute, multiplier: l.multiplier, constant: l.constant)
            return lNew
        }
    }
}






