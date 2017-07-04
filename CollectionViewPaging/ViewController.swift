//
//  ViewController.swift
//  CollectionViewPaging
//
//  Created by Pablo Alcalde on 1/7/17.
//  Copyright © 2017 Cabify Rider v2. All rights reserved.
//

 import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let pager = HorizontalPagerView.init(pageSize: 250, maxScaleToApply: 0.5)

    private let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(pager)
        
        pager.backgroundColor = UIColor.clear
        pager.translatesAutoresizingMaskIntoConstraints = false
        pager.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pager.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pager.heightAnchor.constraint(equalToConstant: 150).isActive = true
        pager.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        pager.collectionView.delegate = self
        pager.register(UINib.init(nibName: "Cell", bundle: nil), forCellWithReuseIdentifier: "cell")
        pager.dataSource = self
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

