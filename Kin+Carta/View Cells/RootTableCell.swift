//
//  UserCell.swift
//  Kin+Carta
//
//  Created by Juan Manuel Tome on 10/08/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import UIKit

class RootTableCell: UITableViewCell {
    //MARK: Properties
    //Each RootTableCell gets populated with a viewModel from the array of ContactsViewModel
    var viewModel: ContactViewModel! {
        didSet {
            userLabel.text = viewModel.name ?? ""
            detailLabel.text = viewModel.companyName ?? ""
            isFavorite.alpha = viewModel.isFavorite ? 1.0 : 0.0
            guard let url = viewModel.imageURL else { return }
            
            ImageCache.cache.loadImage(from: url) { (result: Result<UIImage, Error>) in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.userThumbnail.image = image
                        self.setNeedsLayout()
                    }
                case .failure(let error):
                    print(error)
                }
            }
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
    private let userLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = UIFont.preferredFont(forTextStyle: .headline)
        lbl.textAlignment = .left
        lbl.text = "usernameLabel"
        return lbl
    }()
    private let isFavorite : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .label
        lbl.font = UIFont.preferredFont(forTextStyle: .headline)
        lbl.textAlignment = .natural
        lbl.setContentHuggingPriority(lbl.contentHuggingPriority(for: .horizontal) + 1 , for: .horizontal)
        lbl.text = "⭐️"
        
        return lbl
    }()
    private let detailLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.font = UIFont.preferredFont(forTextStyle: .subheadline)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.text = "userLabel"
        lbl.setContentCompressionResistancePriority(lbl.contentCompressionResistancePriority(for: .vertical) + 10, for: .vertical)
        return lbl
    }()
    private let userThumbnail : UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "userSmall"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return imgView
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.contentMode = .scaleToFill
        stackView.tintColor = UIColor(named: "Color2")
        return stackView
    }()

}

//MARK: - Private Cell Methods
extension RootTableCell {
    private func setupCell() {
        //Add Subviews to Stack
        stackView.addArrangedSubview(userLabel)
        stackView.addArrangedSubview(detailLabel)
        //Add View to contentView
        contentView.addSubview(stackView)
        contentView.addSubview(userThumbnail)
        contentView.addSubview(isFavorite)
        
        //Set Autolayout Constraints
        userThumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        userThumbnail.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        isFavorite.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        isFavorite.leadingAnchor.constraint(equalTo: userThumbnail.trailingAnchor, constant: 30).isActive = true
        
        let constraint: NSLayoutConstraint!
        constraint = NSLayoutConstraint(item: isFavorite, attribute: .centerY, relatedBy: .equal, toItem: userLabel, attribute: .centerY, multiplier: 1, constant: 0)
        contentView.addConstraint(constraint)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: isFavorite.trailingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        //Set accessory type
//        accessoryType = .disclosureIndicator
        backgroundColor = .secondarySystemGroupedBackground
    }
}
