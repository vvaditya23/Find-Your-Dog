//
//  FavouritesViewController.swift
//  Find Your Dog
//
//  Created by Aditya Vyavahare on 09/03/24.
//

import UIKit

class FavouritesViewController: UIViewController {

    var likedImages: [String : String] = [:] // Array to store liked image URLs
    var pickerView: UIPickerView! // Dropdown menu for breed selection
    var filterSwitch: UISwitch!
    let filterLabel = UILabel()
    var breedData: [BreedName] = []
    
    let noDataLabel = UILabel()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
//    let breedListVC = BreedListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourites"
        view.backgroundColor = .white
//        breedData = breedListVC.breedsArray
//        print(breedData)
//        fetchLikedImages()
//        print(likedImages)
        setupPickerView()
        setupSwitchButton()
        setupCollectionView()
        setupNoDataLabel()
        fetchBreeds()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set(true, forKey: "ShouldShowTitle")
        fetchLikedImages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: "ShouldShowTitle")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//UI config.
extension FavouritesViewController {
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BreedImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: filterSwitch.bottomAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupNoDataLabel() {
        view.addSubview(noDataLabel)
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noDataLabel.numberOfLines = 0
        noDataLabel.text = "No favourites, checkout some breeds"
    }
    
    func setupPickerView() {
        pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.delegate = self
        pickerView.dataSource = self
        //            pickerView.isHidden = true // Hide initially
        pickerView.alpha = 0.5
        view.addSubview(pickerView)
        
        // Position the dropdown menu in the center of the screen
        NSLayoutConstraint.activate([
            pickerView.heightAnchor.constraint(equalToConstant: 75),
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //                pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            //                pickerView.widthAnchor.constraint(equalToConstant: 200), // Adjust width as needed
            //                pickerView.heightAnchor.constraint(equalToConstant: 200) // Adjust height as needed
        ])
    }
    
    func setupSwitchButton() {
        filterSwitch = UISwitch()
        filterSwitch.translatesAutoresizingMaskIntoConstraints = false
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        filterSwitch.addTarget(self, action: #selector(filterSwitchValueChanged(_:)), for: .valueChanged)
        
        filterLabel.text = "Enable/Disable filter"
        
        view.addSubview(filterSwitch)
        view.addSubview(filterLabel)
        
        NSLayoutConstraint.activate([
            filterSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterSwitch.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 10),
            filterLabel.centerYAnchor.constraint(equalTo: filterSwitch.centerYAnchor),
            filterLabel.trailingAnchor.constraint(equalTo: filterSwitch.leadingAnchor, constant: -10)
        ])
    }
    @objc func filterSwitchValueChanged(_ sender: UISwitch) {
            pickerView.isUserInteractionEnabled = sender.isOn
            pickerView.alpha = sender.isOn ? 1.0 : 0.5
        }
}

//fetch data
extension FavouritesViewController {
    func fetchLikedImages() {
            // Retrieve liked images from UserDefaults or another storage method
        if let likedImagesArray = UserDefaults.standard.dictionary(forKey: "LikedImages") as? [String : String] {
                likedImages = likedImagesArray
            }
        
        collectionView.reloadData()
        noDataLabel.isHidden = !likedImages.isEmpty
        }
    
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
                    self.breedData = breedsJSON.keys.map { BreedName(name: $0) }
                    // Sort breeds alphabetically
                    self.breedData.sort { $0.name < $1.name }
                    DispatchQueue.main.async {
//                        self.favVC.breedData = self.breedsArray
                        //on successful data fetch put it on-screen
                        self.pickerView.reloadAllComponents()
//                        print(self.breedsArray)
                        
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}


//collectionview config.
extension FavouritesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! BreedImageCollectionViewCell
        // Extract key-value pair at the current index
        let keyValue = Array(likedImages)[indexPath.item]
                
        // Extract image URL and breed name
        let imageUrl = keyValue.key
//        print("url: \(imageUrl)")
        let breedName = keyValue.value
//        print("breed: \(breedName)")
                
        // Set the breed name as the title of the cell
        cell.titleLabel.text = breedName
                
        // Load image from URL
        cell.imageView.loadImage(from: imageUrl)
        
        cell.likeButton.isHidden = true
        return cell
    }
    
    // Set size for collection view cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 5) / 2 // Adjust spacing
        return CGSize(width: width, height: width)
    }
}

extension FavouritesViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breedData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breedData[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedBreed = breedData[row]
        print("Selected breed: \(selectedBreed)")
        // Implement logic to filter collection view data based on selected breed
    }
}
