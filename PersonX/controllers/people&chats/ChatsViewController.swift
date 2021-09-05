//
//  ChatsViewController.swift
//  PersonX
//
//  Created by zz on 27.08.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit


struct ModelChat: Hashable,Decodable  {
    
    var username: String
    var userImageString: String
    var lastMessage: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: ModelChat,rhs: ModelChat) -> Bool {
        return lhs.id == rhs.id
    }
}

class ChatsViewController: UIViewController {
    
    enum Section: Int,CaseIterable {
        case waitingChat
        case activeChat
    }
    
    var collectionView: UICollectionView?
    var dataSource:UICollectionViewDiffableDataSource<Section, ModelChat>?
    
    let activeChats = Bundle.main.decode([ModelChat].self, from: "activeChats.json")
    let waitingChats = Bundle.main.decode([ModelChat].self, from: "waitingChats.json")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionnView()
        setupCollectionViewDataSource()
        reloadData()
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Чаты"
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


extension ChatsViewController {
    
    //MARK: Setup Layout
    
    private func setupCollectionnView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: setupCompositionalLayout())
        collectionView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView!.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9764705882, blue: 1, alpha: 1)
        view.addSubview(collectionView!)
        collectionView?.register(ActiveChatsCollectionViewCell.self,
                                 forCellWithReuseIdentifier: ActiveChatsCollectionViewCell.reuseID)
        collectionView!.register(WaitingChatCollectionViewCell.self,
                                 forCellWithReuseIdentifier: WaitingChatCollectionViewCell.reuseID)
    }
    
    
    private func setupCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else { fatalError("Unknown section")}
            switch section {
                
            case .activeChat:
                return self.setupActiveCell()
            case .waitingChat:
                return self.setupWaitingCell()
            }
            
        }
        return layout
    }
    
    private func setupActiveCell() -> NSCollectionLayoutSection {
           
           //itemSize -> item -> groupSize -> groups -> section
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)
           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(78))
           let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
           let section = NSCollectionLayoutSection(group: group)
           section.interGroupSpacing = 12
           section.contentInsets = NSDirectionalEdgeInsets.init(top: 30, leading: 16, bottom: 0, trailing: 16)
           return section
       }
       
       private func setupWaitingCell() -> NSCollectionLayoutSection {
           
           //itemSize -> item -> groupSize -> groups -> section
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)
           let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(78), heightDimension: .absolute(78))
           let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
           let section = NSCollectionLayoutSection(group: group)
           section.orthogonalScrollingBehavior = .continuous
           section.interGroupSpacing = 12
           section.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 16, bottom: 0, trailing: 16)
           return section
       }
    
    
    //MARK: Setup collectionViewDataSource
    
    
    private func configureCell<T:CellConfiguring>(cellType: T.Type,model: ModelChat,indexPath: IndexPath) -> T {
        guard let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: cellType.reuseID, for: indexPath) as? T else {
            fatalError("Unknown id cell")
        }
        cell.configure(value: model)
        return cell
    }
    
    
    private func setupCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ModelChat>(collectionView: collectionView!) { (collectionView, indexPath, modelChat) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {fatalError("Unknown section")}
            switch section {
            case .activeChat:
                return self.configureCell(cellType: ActiveChatsCollectionViewCell.self,
                              model: modelChat,
                              indexPath: indexPath)
                
            case .waitingChat:
                return self.configureCell(cellType: WaitingChatCollectionViewCell.self, model: modelChat, indexPath: indexPath)
            }
        }
    }
    // MARK: Setup Snapshot
    
    private func reloadData() {
           var snapShot = NSDiffableDataSourceSnapshot<Section, ModelChat>()
           snapShot.appendSections([.waitingChat,.activeChat])
           snapShot.appendItems(waitingChats, toSection: .waitingChat)
           snapShot.appendItems(activeChats, toSection: .activeChat)
           dataSource?.apply(snapShot,animatingDifferences: true)
           
       }
    
    
    
    
}

extension ChatsViewController : UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

