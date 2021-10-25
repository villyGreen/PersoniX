//
//  PeopleViewController.swift
//  PersonX
//
//  Created by zz on 27.08.2021.
//  Copyright © 2021 Vadim Vitkovskiy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PeopleViewController: UIViewController, UISearchControllerDelegate {
    
    var listener: ListenerRegistration?
    let Muser: ModelUser
    var users = [ModelUser]()
    enum Section: Int,CaseIterable {
        case users
        func description(usersCount: Int) -> String {
            switch self {
            case .users:
                return "\(usersCount) человек рядом"
            }
        }
    }
    
    deinit {
        listener?.remove()
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section,ModelUser>?
    var collectionView: UICollectionView?
    
    init(user:ModelUser) {
        self.Muser = user
        super.init(nibName: nil, bundle: nil)
        title = Muser.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionnView()
        setupCompositionalLayout()
        reloadData(searchText: nil)
        listener = ListenerService.shared.userObserve(user: users) { (result) in
                   switch result {
                       
                   case .success(let users):
                       self.users = users
                       self.reloadData(searchText: nil)
                       
                   case .failure(let error):
                       self.createAlert(title: "Ошибка",
                                        message: error.localizedDescription, completion: nil)
                   }
                   
               }
        
        
        setupDataSource()
        
       
 
      
    }
    
//
    //MARK: SetupColllectionView
    private func setupCollectionnView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: setupCompositionalLayout())
        collectionView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView!.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9764705882, blue: 1, alpha: 1)
        view.addSubview(collectionView!)
        collectionView?.delegate = self
        collectionView?.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: SectionHeader.reuseId)
        collectionView?.register(UserCell.self, forCellWithReuseIdentifier:UserCell.reuseID)
    }
    
    
    
    //MARK: Setup CompositionalLayout
    private func setupCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) ->
            NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex)
                else { fatalError("Unknown section")}
            switch section {
            case .users:
                return self.setupUserSection()
                
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    private func setupUserSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        group.interItemSpacing = .fixed(15)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = NSDirectionalEdgeInsets(top: 15,
                                                        leading: 15,
                                                        bottom: 15,
                                                        trailing: 15)
        let header = createHeaderSection()
        section.boundarySupplementaryItems = [header]
        return section
        
    }
    
    
    // MARK: Setup Snapshot
    private func reloadData(searchText: String?) {
        let filtered = users.filter { user -> Bool in
            user.contains(searchText: searchText)
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, ModelUser>()
        snapShot.appendSections([.users])
        snapShot.appendItems(filtered, toSection: .users)
        dataSource?.apply(snapShot,animatingDifferences: true)
    }
    
    
    
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,ModelUser>(collectionView: collectionView!, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError()
            }
            switch section {
            case .users:
                return self.configureCell(collectionView: collectionView,
                                          cellType: UserCell.self,
                                          model: user,
                                          indexPath: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView,kind,indexPath in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else {
                fatalError()
            }
            guard  let section = Section(rawValue: indexPath.section) else {
                fatalError()
            }
            
            sectionHeader.configureHeader(text: section.description(usersCount: self.users.count),
                                          font: .systemFont(ofSize: 28, weight: .light),
                                          textColor: #colorLiteral(red: 0.04945700034, green: 0.04515571317, blue: 0.1189446865, alpha: 1), textAlpha: 0.85)
            return sectionHeader
        }
        
        
        
    }
    
    //MARK: SetupView
    private func setupView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 20, weight: .light)]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.968627451, green: 0.9764705882, blue: 1, alpha: 1)
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выйти",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(signOut))
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation  = false
        searchController.searchBar.delegate = self
    }
    
    @objc private func signOut() {
        let currentEmail = Auth.auth().currentUser?.email
        let alert = UIAlertController(title:"Предупреждение",
                                      message: "Вы действительно хотите выйти из \(currentEmail!)", preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Да", style: .destructive) { _ in
            
            do {
                try Auth.auth().signOut()
                UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
                if Auth.auth().currentUser != nil {
                    print("Error, is  id not deleted")
                }
            } catch (let error) {
                print(error.localizedDescription)
            }
            
        }
        let noButton = UIAlertAction(title: "Нет",
                                     style: .default, handler: nil)
        alert.addAction(noButton)
        alert.addAction(yesButton)
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
    
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

//MARK: Extensions
extension PeopleViewController: UISearchBarDelegate,UICollectionViewDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(searchText: searchText)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard  let user = self.dataSource?.itemIdentifier(for: indexPath) as? ModelUser else { return }
        
        guard let profileVc = ProfileViewController(user: user) else { return }
        self.present(profileVc, animated: true, completion: nil)
        
    }
}
