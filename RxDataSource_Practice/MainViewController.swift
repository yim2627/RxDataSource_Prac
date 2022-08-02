//
//  ViewController.swift
//  RxDataSource_Practice
//
//  Created by 임지성 on 2022/08/02.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Reusable

struct MainDataSection {
    var header: String
    var items: [MainData]
}

extension MainDataSection: SectionModelType {
    typealias Item = MainData
    
    init(original: MainDataSection, items: [MainData]) {
        self = original
        self.items = items
    }
}

struct MainData {
    let messege: String
}

final class MainViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: configureCollectionViewLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(cellType: MainViewCollectionViewCell.self)
        collectionView.register(supplementaryViewType: MainCollectionReusableHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        return collectionView
    }()
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<MainDataSection>!
    
    private let sections = [
        MainDataSection(header: "First", items: [MainData(messege: "HI"), MainData(messege: "HI2"), MainData(messege: "HI3")]),
        MainDataSection(header: "Second", items: [MainData(messege: "HI")]),
        MainDataSection(header: "Third", items: [MainData(messege: "HI"), MainData(messege: "HI2")])
    ]
    
    private let sectionSubject = BehaviorRelay(value: [MainDataSection]())
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionViewDataSource()
        bind()
        
        sectionSubject.accept(sections)
    }
    
    //MARK: - Configures

    private func configureUI() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(0.1)
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30.0))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        return layout
    }
    
    private func configureCollectionViewDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<MainDataSection>(configureCell: { dataSource, collectionView, indexPath, item in
            let cell: MainViewCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.bind(item: item)
            return cell
            
        }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let header: MainCollectionReusableHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                let sectionTitle = dataSource.sectionModels[indexPath.section].header
                header.bind(title: sectionTitle)
                return header
            default:
                fatalError()
            }
        })
    }
    
    //MARK: - Bind
    
    private func bind() {
        sectionSubject
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
