import Foundation
import UIKit

class HorizontalPagerView: UIView, UICollectionViewDelegate {
    @objc private let pagingScrollView = UIScrollView()

    let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

    var pageWidth: CGFloat = 0 {
        didSet {
            pageWidth = max(pageWidth, 0)
            didResize()
        }
    }

    var dataSource: UICollectionViewDataSource? {
        didSet {
            collectionView.dataSource = dataSource
        }
    }

    var delegate: UICollectionViewDelegate? {
        didSet {
            collectionView.delegate = delegate
        }
    }

    // Range from (0..1] of reducing scale amount to apply when paging
    // Cell in the center will always have 1 (biggest)
    var maxScaleToApply: CGFloat = 0.8 {
        didSet {
            maxScaleToApply = min(max(maxScaleToApply, 0.1), 1.0)
        }
    }

    private var flowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }

    init(pageWidth: CGFloat, maxScaleToApply: CGFloat = 0) {
        self.pageWidth = pageWidth
        self.maxScaleToApply = maxScaleToApply

        super.init(frame: CGRect.zero)

        configure()
    }

    func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    func reloadData() {
        didResize()
        self.collectionView.reloadData()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configure()
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
        pagingScrollView.widthAnchor.constraint(equalToConstant: pageWidth).isActive = true

        pagingScrollView.delegate = self

        pagingScrollView.isPagingEnabled = true
        pagingScrollView.isHidden = true

        collectionView.addGestureRecognizer(pagingScrollView.panGestureRecognizer)
        collectionView.panGestureRecognizer.isEnabled = false

        contentMode = .redraw
    }

    override func draw(_ rect: CGRect) {
        didResize()
    }

    private func didResize() {
        flowLayout.itemSize = CGSize(width: pageWidth, height: frame.height)

        let padding = (frame.width-pageWidth)/2
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)

        var numberOfCellsItems = CGFloat(0)
        if let dataSource = collectionView.dataSource {
            numberOfCellsItems = CGFloat(dataSource.collectionView(collectionView, numberOfItemsInSection: 0))
        }

        pagingScrollView.contentSize = CGSize(width: pageWidth * numberOfCellsItems, height: frame.height)
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == pagingScrollView else { return }

        if scrollView == pagingScrollView {
            collectionView.contentOffset = pagingScrollView.contentOffset

            let rows = collectionView.indexPathsForVisibleItems
            for indexPath in rows {
                applyTransformToCell(cell: collectionView.cellForItem(at: indexPath)!, indexPath: indexPath)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView == pagingScrollView else { return }
        
        pagingScrollView.setContentOffset(scrollView.contentOffset, animated: false)
    }
}
