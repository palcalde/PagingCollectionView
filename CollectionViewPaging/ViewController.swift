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

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "Cell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self

        let layout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout

        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView.isPagingEnabled = true

        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        let windowWidth: CGFloat = 374
        let pageSize: CGFloat = 300
        layout.itemSize = CGSize(width: pageSize, height: collectionView.frame.height)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: (windowWidth-pageSize)/2, bottom: 0, right: (windowWidth-pageSize)/2)
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

