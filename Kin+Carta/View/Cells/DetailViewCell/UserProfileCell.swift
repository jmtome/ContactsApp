//
//  UserProfileCell.swift
//  Kin+Carta
//
//  Created by Juan Manuel Tome on 22/08/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import UIKit

class UserProfileCell: UITableViewCell {
    
    //MARK: Properties
    //Each UserProfileCell gets populated with a viewModel provided by the DetailView
    var cellViewModel: ContactViewModel! {
        didSet {
            userLabel.text = cellViewModel.name
            detailLabel.text = cellViewModel.companyName ?? ""
            
            guard let url = cellViewModel.imageURL else { return }
            
            ImageCache.cache.loadImage(from: url) { (result: Result<UIImage, Error>) in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.userThumbnail.image = image
                    }
                case .failure(let error):
                    print("error is \(error)")
                    DispatchQueue.main.async {
                        self.userThumbnail.image = ImageCache.placeHolderImage
                    }
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
        lbl.font = UIFont.preferredFont(forTextStyle: .title1)
        lbl.textAlignment = .left
        lbl.text = "usernameLabel"
        lbl.setContentCompressionResistancePriority(lbl.contentCompressionResistancePriority(for: .vertical) + 10, for: .vertical)
        
        return lbl
    }()
    private let detailLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.font = UIFont.preferredFont(forTextStyle: .subheadline)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.text = "companyLabel"
        lbl.setContentCompressionResistancePriority(lbl.contentCompressionResistancePriority(for: .vertical) + 10, for: .vertical)
        return lbl
    }()
    private let userThumbnail : UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "userLarge"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.setContentCompressionResistancePriority(imgView.contentCompressionResistancePriority(for: .vertical) - 10, for: .vertical)
        imgView.setContentHuggingPriority(imgView.contentHuggingPriority(for: .vertical) - 10, for: .vertical)
        imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor).isActive = true
        //        imgView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return imgView
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.contentMode = .scaleToFill
        return stackView
    }()
    
}

//MARK: - Private Cell Methods
extension UserProfileCell {
    private func setupCell() {
        //Add Subviews to Stack
        stackView.addArrangedSubview(userThumbnail)
        stackView.addArrangedSubview(userLabel)
        stackView.addArrangedSubview(detailLabel)
        //Add Stack to Cell's ContentView
        contentView.addSubview(stackView)
        //Add Autolayout Constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
