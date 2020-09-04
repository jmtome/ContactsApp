//
//  DetailViewController.swift
//  Kin+Carta
//
//  Created by Juan Manuel Tome on 22/08/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //Data Source
    var viewModel: ContactViewModel! {
        didSet {
            setupNavigationBar()
        }
    }
    //Detail View
    var detailView: DetailView {
        return view as! DetailView
    }
    
    //MARK: - View Controller Life-cycle methods
    override func loadView() {
        super.loadView()
        let detailView = DetailView(frame: .zero)
        detailView.delegate = self
        detailView.viewModel = viewModel
        view = detailView
    }
    override func viewDidLoad() {
        super.viewDidLoad()    
    }
}

//MARK: - Private Methods
extension DetailViewController {
    //Set up navigation bar
    private func setupNavigationBar() {
        if viewModel.isFavorite {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favoriteFill"), style: .plain, target: self, action: #selector(toggleFavorite(_:)))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favoriteEmpty"), style: .plain, target: self, action: #selector(toggleFavorite(_:)))
        }
    }
    //Toggle favorites
    @objc private func toggleFavorite(_ sender: UIBarButtonItem) {
        if viewModel.isFavorite {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favoriteEmpty"), style: .plain, target: self, action: #selector(toggleFavorite(_:)))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favoriteFill"), style: .plain, target: self, action: #selector(toggleFavorite(_:)))
        }
        viewModel.isFavorite.toggle()
    }
}

//MARK: - DetailView Delegate methods
extension DetailViewController: DetailViewDelegate {
    func setupNavBar(from view: UIView) {
        setupNavigationBar()
    }

}
