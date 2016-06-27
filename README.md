# iOS9ReorderableCollectionView

Reorderable collection view implementation with the new iOS 9 methods

based on http://nshint.io/blog/2015/07/16/uicollectionviews-now-have-easy-reordering/

Step1 -> `UICollectionViewController` override

Step2 -> `UIViewController` override and a UIGestureRecognizer on the `UICollectionView`

Step3 -> Same as Step 2 and using a custom `UICollectionViewFlowLayout` in order to preserve the cell size during the reordering (last part of the NSHint post)

Step4 -> Add some animations and customisations during the reorder by using a custom `UICollectionViewFlowLayout` and a `UIGestureRecognizer`
