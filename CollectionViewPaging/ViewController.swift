//
//  ViewController.swift
//  CollectionViewPaging
//
//  Created by Pablo Alcalde on 1/7/17.
//  Copyright © 2017 Cabify Rider v2. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!

    private let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "Cell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self

        let layout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout

        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView.isPagingEnabled = false

        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        let windowWidth: CGFloat = 374
        let pageSize: CGFloat = 250
        layout.itemSize = CGSize(width: pageSize, height: collectionView.frame.height)
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: (windowWidth-pageSize)/2, bottom: 0, right: (windowWidth-pageSize)/2)

        layout.sectionInset = UIEdgeInsets(top: 0, left: (windowWidth-pageSize)/2, bottom: 0, right: (windowWidth-pageSize)/2)

        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: pageSize * 5, height: collectionView.frame.height)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: collectionView.leftAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: pageSize).isActive = true

//        scrollView.contentInset = UIEdgeInsets(top: 0, left: (windowWidth-pageSize)/2, bottom: 0, right: (windowWidth-pageSize)/2)

        scrollView.isHidden = true

        scrollView.isPagingEnabled = true
        scrollView.delegate = self

        collectionView.addGestureRecognizer(scrollView.panGestureRecognizer)
        collectionView.panGestureRecognizer.isEnabled = false

        collectionView.layer.borderColor = UIColor.gray.cgColor
        collectionView.layer.borderWidth = 1
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == self.scrollView) { //ignore collection view scrolling callbacks
            collectionView.contentOffset = scrollView.contentOffset;
        } else {
            print("ignored scroll from collectionview")
        }
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

