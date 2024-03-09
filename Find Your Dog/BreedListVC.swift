//
//  ViewController.swift
//  Find Your Dog
//
//  Created by Aditya Vyavahare on 09/03/24.
//

import UIKit

class BreedListVC: UIViewController {

    let breedListTableView = UITableView()
    
    var breedsArray: [Breed] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBreedsTableView()
        fetchBreeds()
    }
}

//UI config
extension BreedListVC {
    func setupBreedsTableView() {
        breedListTableView.dataSource = self
        breedListTableView.delegate = self
        breedListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "BreedCell")
        
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

//fetch data
extension BreedListVC {
    func fetchBreeds() {
        guard let url = URL(string: "https://dog.ceo/api/breeds/list/all") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching breeds: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonData = json as? [String: Any],
                   let breedsJSON = jsonData["message"] as? [String: Any] {
                    self.breedsArray = breedsJSON.keys.map { Breed(name: $0) }
                    DispatchQueue.main.async {
                        //on successful data fetch put it on-screen
                        self.breedListTableView.reloadData()
//                        print(self.breedsArray)
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

//tableview config
extension BreedListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        breedsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreedCell", for: indexPath)
        let breed = breedsArray[indexPath.row]
        cell.textLabel?.text = breed.name
        return cell
    }
}
