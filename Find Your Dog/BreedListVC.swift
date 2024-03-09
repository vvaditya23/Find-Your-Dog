//
//  ViewController.swift
//  Find Your Dog
//
//  Created by Aditya Vyavahare on 09/03/24.
//

import UIKit

class BreedListVC: UIViewController {

    let breedListTableView = UITableView()
    
    var breeds: [Breed] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension BreedListVC {
    func setupUI() {
        view.addSubview(breedListTableView)
        breedListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            breedListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            breedListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            breedListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            breedListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
