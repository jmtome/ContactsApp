//
//  UserInfoCell.swift
//  Kin+Carta
//
//  Created by Juan Manuel Tome on 22/08/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import UIKit


class UserInfoCell: UITableViewCell {
    //MARK: Properties
    //Each UserProfileCell gets populated with a viewModel provided by the DetailView
    var userInfoCellVM: UserInfoVM! {
        didSet {
            headerLabel.text = userInfoCellVM.headerLabel
            valueLabel.text = userInfoCellVM.valueLabel
            detailLabel.text = userInfoCellVM.detailLabel
        }
    }
    
    //MARK: - Cell Life Cycle Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Properties
    let headerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "headerLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    let detailLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "ValueLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    let valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "valueToShow"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        //label.font = UIFont.systemFont(ofSize: 10, weight: .thin)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(label.contentCompressionResistancePriority(for: .vertical) + 10, for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749), for: .vertical)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .vertical)
        return label
    }()
}
//MARK: - Private Cell Methods
extension UserInfoCell {
    private func setupCell() {
        //Add views to ContentView
        self.contentView.addSubview(headerLabel)
        self.contentView.addSubview(valueLabel)
        self.contentView.addSubview(detailLabel)
        //Add Autolayout Constraints
        headerLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor).isActive = true
        headerLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 2/3).isActive = true
        
        valueLabel.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor).isActive = true
        valueLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10).isActive = true
        
        detailLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        detailLabel.centerYAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.centerYAnchor).isActive = true
        
        //nameLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: 50).isActive = true
    }
}

