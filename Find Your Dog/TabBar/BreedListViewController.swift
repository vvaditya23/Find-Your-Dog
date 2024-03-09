//
//  ViewController.swift
//  Find Your Dog
//
//  Created by Aditya Vyavahare on 09/03/24.
//

import UIKit

class BreedListViewController: UIViewController {
    //used to add to navigation controller
    let VC = UIViewController()
    let breedListTableView = UITableView()
    
    var breedsArray: [BreedName] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //display large title on nav bar
        title = "Choose a breed"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navigationController = UINavigationController(rootViewController: VC)
        
        setupBreedsTableView()
        fetchBreeds()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = false
    }
}

//UI config
extension BreedListViewController {
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
extension BreedListViewController {
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
                    self.breedsArray = breedsJSON.keys.map { BreedName(name: $0) }
                    // Sort breeds alphabetically
                    self.breedsArray.sort { $0.name < $1.name }
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
extension BreedListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        breedsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreedCell", for: indexPath)
        let breed = breedsArray[indexPath.row]
        cell.textLabel?.text = breed.name
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedBreedName = breedsArray[indexPath.row].name
//            print("Selected breed: \(selectedBreedName)")
            
            // Instantiate BreedImagesViewController
            let breedImagesVC = BreedImagesViewController()
            
            // Pass selected breed name to BreedImagesViewController
            breedImagesVC.breedName = selectedBreedName
            
            // Push BreedImagesViewController onto navigation stack
            navigationController?.pushViewController(breedImagesVC, animated: true)
        }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: breedListTableView.frame.width, height: 50))
//        headerView.backgroundColor = .lightGray
//        
//        let headerTitle = UILabel(frame: CGRect(x: 15, y: 10, width: breedListTableView.frame.width, height: 30))
//        headerTitle.text = "Choose a breed"
//        headerTitle.font = UIFont.boldSystemFont(ofSize: 18)
//        
//        headerView.addSubview(headerTitle)
//        return headerView
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
}
