//
//  ChatsViewController.swift
//  PersonX
//
//  Created by zz on 27.08.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ChatsViewController: UIViewController {
    
    let Muser: ModelUser
    var waitingChatsListener: ListenerRegistration?
    var activeChatsListener: ListenerRegistration?
    
    enum Section: Int,CaseIterable {
        case waitingChat
        case activeChat
        
        func description() -> String {
            switch self {
            case .waitingChat:
                return "Ожидающие чаты"
            case .activeChat:
                return "Активные чаты"
            }
        }
        
    }
    
    var collectionView: UICollectionView?
    var dataSource:UICollectionViewDiffableDataSource<Section, ModelChat>?
    
    var activeChats = [ModelChat]()
    var waitingChats = [ModelChat]()
    
    
    init(user:ModelUser) {
        self.Muser = user
        super.init(nibName: nil, bundle: nil)
        title = "\(Muser.username)"
    }
    
    deinit {
        waitingChatsListener?.remove()
        activeChatsListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("gg");
        setupView()
        setupCollectionnView()
        setupCollectionViewDataSource()
        reloadData()
        setupWaitingChatsListener()
        setupActiveChatsListener()
        
    }
    //MARK: Setup View
    private func setupView() {
       
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.font:
            UIFont.systemFont(ofSize: 20, weight: .light)]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.968627451, green: 0.9764705882, blue: 1, alpha: 1)
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation  = false
        searchController.searchBar.delegate = self
    }
    
    private func setupWaitingChatsListener() {
        waitingChatsListener = ListenerService.shared.waitingChatListener(chat: waitingChats, completion: { (result) in
            switch result {
                
            case .success(let chats):
                if self.waitingChats.count <= chats.count && chats.count > 0 {
                    
                    let requestVc = RequetsViewController(chat: chats.last!)
                    requestVc.delegate = self
                    self.present(requestVc, animated: true, completion: nil)
                }
                self.waitingChats = chats
                self.reloadData()
            case .failure(let error):
                self.createAlert(title: "Ошибка",
                                 message: error.localizedDescription,
                                 completion: nil)
            }
        })
    }
    
    
    private func setupActiveChatsListener() {
        activeChatsListener = ListenerService.shared.activeChatListener(chat: activeChats, completion: { (result) in
            switch result {
                
            case .success(let messages):
                self.activeChats = messages
                self.reloadData()
            case .failure(let error):
                self.createAlert(title: "Ошибка",
                                 message: error.localizedDescription,
                                 completion: nil)
            }
        })
    }
    
    
}

extension ChatsViewController {
    
    //MARK: Setup CollectionView
    
    private func setupCollectionnView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: setupCompositionalLayout())
        collectionView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView!.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9764705882, blue: 1, alpha: 1)
        view.addSubview(collectionView!)
           collectionView?.delegate = self
        collectionView?.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: SectionHeader.reuseId)
        collectionView?.register(ActiveChatsCollectionViewCell.self,
                                 forCellWithReuseIdentifier: ActiveChatsCollectionViewCell.reuseID)
        collectionView!.register(WaitingChatCollectionViewCell.self,
                                 forCellWithReuseIdentifier: WaitingChatCollectionViewCell.reuseID)
    }
    
    
    
    //MARK: Setup Layout
    private func setupCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) ->
            NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex)
                else { fatalError("Unknown section")}
            switch section {
                
            case .activeChat:
                return self.setupActiveCell()
            case .waitingChat:
                return self.setupWaitingCell()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    
    //MARK: Setup CollectionViewCells
    
    private func setupActiveCell() -> NSCollectionLayoutSection {
        
        //itemSize -> item -> groupSize -> groups -> section
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(78))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 20, leading: 16, bottom: 0, trailing: 16)
        let sectionHeader = createHeaderSection()
        section.boundarySupplementaryItems = [sectionHeader]
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
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 20, leading: 16, bottom: 0, trailing: 16)
        
        let sectionHeader  = createHeaderSection()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    
    //MARK: Create HeaderSection
    private func createHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .estimated(1))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        return sectionHeader
    }
    //MARK: Setup DataSource
    
    private func setupCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ModelChat>(collectionView: collectionView!) { (collectionView, indexPath, modelChat) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {fatalError("Unknown section")}
            switch section {
            case .activeChat:
                return self.configureCell(collectionView: collectionView, cellType: ActiveChatsCollectionViewCell.self,
                                          model: modelChat,
                                          indexPath: indexPath)
                
            case .waitingChat:
                return self.configureCell(collectionView: collectionView, cellType: WaitingChatCollectionViewCell.self, model: modelChat, indexPath: indexPath)
            }
        }
        dataSource?.supplementaryViewProvider = {
            collectionView,kind,IndexPath in
            guard  let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: IndexPath) as? SectionHeader else {
                fatalError()
            }
            guard  let section = Section(rawValue: IndexPath.section) else {
                fatalError()
            }
            sectionHeader.configureHeader(text: section.description(),
                                          font: UIFont(name: "Avenir", size: 18),
                                          textColor: #colorLiteral(red: 0.04945700034, green: 0.04515571317, blue: 0.1189446865, alpha: 1), textAlpha: 0.6)
            return sectionHeader
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


extension ChatsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         
        guard let chat = self.dataSource?.itemIdentifier(for: indexPath) as? ModelChat else { return }
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        
        switch section {
            
        case .waitingChat:
        
            let requestVc = RequetsViewController(chat: chat)
            requestVc.delegate = self
            self.present(requestVc, animated: true, completion: nil)
        case .activeChat:
            let vc = ChatViewController(user: Muser, chat: chat)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}


extension ChatsViewController: WaitingChatProtocol {
    
    func removeWaitingChat(chat: ModelChat) {
        print("yes")
        FireStoreService.shared.deleteWaitingChat(chat: chat) { (result) in
            switch result {
                
            case .success():
                print(" ")
            case .failure(let error):
                self.createAlert(title: "Ошибка",
                                 message: error.localizedDescription,
                                 completion: nil)
            }
        }
    }
    
    func transformToActiveChat(chat: ModelChat) {
        FireStoreService.shared.changeToActive(chat: chat) { (result) in
            switch result {
                
            case .success():
                print(" ")
            case .failure(let error):
                self.createAlert(title: "Ошибка",
                                 message: error.localizedDescription,
                                 completion: nil)
            }
        }
    }
    
    
    
    
    
}
