import Foundation
import UIKit

class PagingCollectionView: UICollectionView, UICollectionViewDelegate {
    private let pagingScrollView = UIScrollView()

    var pageSize: CGFloat = 0 {
        didSet {
            didResize()
        }
    }

    // 1 is no effect at all, 0.1 is the biggest effect possible
    // defaults to 0.7
    var scalePagingEffect: CGFloat = 0.7 {
        didSet {
            scalePagingEffect = min(max(scalePagingEffect, 0.1), 1.0)
        }
    }

    private var flowLayout: UICollectionViewFlowLayout {
        return collectionViewLayout as! UICollectionViewFlowLayout
    }

    init(pageSize: CGFloat, scalePagingEffect: CGFloat = 0) {
        self.pageSize = pageSize
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        delegate = self

        isPagingEnabled = false

        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0

        didResize()

        addSubview(pagingScrollView)

        pagingScrollView.translatesAutoresizingMaskIntoConstraints = false
        pagingScrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pagingScrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        pagingScrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        pagingScrollView.widthAnchor.constraint(equalToConstant: pageSize).isActive = true

        pagingScrollView.isPagingEnabled = true
        pagingScrollView.delegate = self
        pagingScrollView.isUserInteractionEnabled = false

        addGestureRecognizer(pagingScrollView.panGestureRecognizer)
        panGestureRecognizer.isEnabled = false

        contentMode = .redraw
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == pagingScrollView) { //ignore collection view scrolling callbacks
            contentOffset = pagingScrollView.contentOffset

            let rows = indexPathsForVisibleItems
            for indexPath in rows {
                applyTransformToCell(cell: cellForItem(at: indexPath)!, indexPath: indexPath)
            }
        }
    }

    private func applyTransformToCell(cell: UICollectionViewCell, indexPath: IndexPath) {
        let scrollCenter = contentOffset.x + (frame.width/2)

        let collectionViewWidth = frame.width
        let offSetX = abs(scrollCenter - cell.center.x)
        let percetangeTransformToApply = (collectionViewWidth - offSetX) / collectionViewWidth

        let transformScaled = scalePagingEffect + (percetangeTransformToApply * (1.0 - scalePagingEffect))

        cell.contentView.layer.sublayerTransform = CATransform3DMakeScale(transformScaled, transformScaled, 1)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
    }
}
