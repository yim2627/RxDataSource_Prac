//
//  MainViewCollectionViewCell.swift
//  RxDataSource_Practice
//
//  Created by 임지성 on 2022/08/02.
//

import UIKit
import Reusable

final class MainViewCollectionViewCell: UICollectionViewCell, Reusable {
    private let textLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures

    private func configureUI() {
        contentView.addSubview(textLable)
        
        NSLayoutConstraint.activate([
            textLable.topAnchor.constraint(equalTo: contentView.topAnchor),
            textLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func bind(item: MainData) {
        textLable.text = item.messege
    }
}
