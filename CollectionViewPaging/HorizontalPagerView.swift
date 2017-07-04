import Foundation
import UIKit

class HorizontalPagerView: UIView {
    @objc private let pagingScrollView = UIScrollView()

    let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

    var pageSize: CGFloat = 0 {
        didSet {
            didResize()
        }
    }

    var dataSource: UICollectionViewDataSource? {
        didSet {
            collectionView.dataSource = dataSource
        }
    }

    // Range from (0..1] of reducing scale amount to apply when paging
    // Cell in the center will always have 1 (biggest)
    var maxScaleToApply: CGFloat = 0.7 {
        didSet {
            maxScaleToApply = min(max(maxScaleToApply, 0.1), 1.0)
        }
    }

    private var flowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }

    init(pageSize: CGFloat, maxScaleToApply: CGFloat = 0) {
        self.pageSize = pageSize
        self.maxScaleToApply = maxScaleToApply

        super.init(frame: CGRect.zero)

        configure()
    }

    func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configure()
    }

    deinit {
        removeObserver(self, forKeyPath: #keyPath(pagingScrollView.contentOffset))
    }

    private func configure() {
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.isPagingEnabled = false

        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0

        didResize()

        addSubview(collectionView)
        addSubview(pagingScrollView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        pagingScrollView.translatesAutoresizingMaskIntoConstraints = false
        pagingScrollView.topAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        pagingScrollView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        pagingScrollView.leftAnchor.constraint(equalTo: collectionView.leftAnchor).isActive = true
        pagingScrollView.widthAnchor.constraint(equalToConstant: pageSize).isActive = true

        pagingScrollView.isPagingEnabled = true
        pagingScrollView.isHidden = true

        collectionView.addGestureRecognizer(pagingScrollView.panGestureRecognizer)
        collectionView.panGestureRecognizer.isEnabled = false

        addObserver(self, forKeyPath: #keyPath(pagingScrollView.contentOffset), options: [.new, .old], context: nil)

        contentMode = .redraw
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(pagingScrollView.contentOffset) {
            collectionView.contentOffset = pagingScrollView.contentOffset

            let rows = collectionView.indexPathsForVisibleItems
            for indexPath in rows {
                applyTransformToCell(cell: collectionView.cellForItem(at: indexPath)!, indexPath: indexPath)
            }
        }
    }

    override func draw(_ rect: CGRect) {
        didResize()
    }

    private func didResize() {
        flowLayout.itemSize = CGSize(width: pageSize, height: frame.height)
        let padding = (frame.width-pageSize)/2
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        pagingScrollView.contentSize = CGSize(width: pageSize * 5, height: frame.height)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
    }

    private func applyTransformToCell(cell: UICollectionViewCell, indexPath: IndexPath) {
        let scrollCenter = collectionView.contentOffset.x + (frame.width/2)

        let collectionViewWidth = frame.width
        let offSetX = abs(scrollCenter - cell.center.x)

        let distanceFromCenter = (collectionViewWidth - offSetX) / collectionViewWidth

        let amountToScale = (distanceFromCenter * (1.0 - maxScaleToApply))
        let amountToScaleRounded = CGFloat(round(1000 * amountToScale) / 1000)

        let transformScaled = maxScaleToApply + amountToScaleRounded

        cell.contentView.layer.sublayerTransform = CATransform3DMakeScale(transformScaled, transformScaled, 1)
    }
}
