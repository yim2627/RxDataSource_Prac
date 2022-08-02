//
//  MainCollectionReusableHeaderView.swift
//  RxDataSource_Practice
//
//  Created by 임지성 on 2022/08/02.
//

import UIKit
import Reusable

class MainCollectionReusableHeaderView: UICollectionReusableView, Reusable {
    private let textLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .cyan
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures

    private func configureUI() {
        addSubview(textLable)
        
        NSLayoutConstraint.activate([
            textLable.topAnchor.constraint(equalTo: self.topAnchor),
            textLable.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textLable.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textLable.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func bind(title: String) {
        textLable.text = title
    }
}
