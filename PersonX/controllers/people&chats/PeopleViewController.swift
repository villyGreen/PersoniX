//
//  PeopleViewController.swift
//  PersonX
//
//  Created by zz on 27.08.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController, UISearchControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionnView()
        
    }
    
    private func setupCollectionnView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9764705882, blue: 1, alpha: 1)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
//    private func setupCompositionalLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
//            
//        }
//        return layout
//    }
//    
    
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Люди"
        navigationController?.navigationBar.titleTextAttributes = [.font:
            UIFont(name: "Heiti SC", size: 22)]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.968627451, green: 0.9764705882, blue: 1, alpha: 1)
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation  = false
        searchController.searchBar.delegate = self
    }
    
    
    
    
}
extension PeopleViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

extension PeopleViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .systemFill
        return cell
    }
    
    
    
    
}


