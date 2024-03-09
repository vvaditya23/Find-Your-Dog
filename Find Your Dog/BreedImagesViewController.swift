//
//  BreedImagesViewController.swift
//  Find Your Dog
//
//  Created by Aditya Vyavahare on 09/03/24.
//

import UIKit

class BreedImagesViewController: UIViewController {

    var breedName: String = "" // Stores selected breed name
    var breedImagesArray: [String] = [] // Array to store breed image URLs
    var likedImages: Set<String> = [] // Set to store liked images
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        fetchBreedImageURLs()
    }
}

//UI config
extension BreedImagesViewController {
    func setupCollectionView() {
            collectionView.dataSource = self
            collectionView.delegate = self
        collectionView.register(BreedImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
            
            view.addSubview(collectionView)
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
                collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
}

//fetch data
extension BreedImagesViewController {
    func fetchBreedImageURLs() {
        guard let url = URL(string: "https://dog.ceo/api/breed/\(breedName)/images") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching breed images: \(error.localizedDescription)")
                // Handle error here (e.g., display an alert)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonData = json as? [String: Any],
                   let images = jsonData["message"] as? [String] {
                    self.breedImagesArray = images
                    DispatchQueue.main.async {
                        //on successful data fetch put it on-screen
//                        print(self.breedImagesArray)
                        self.collectionView.reloadData()
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                // Handle error here (e.g., display an alert)
            }
        }.resume()
    }
}

//collectionview config.
extension BreedImagesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breedImagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! BreedImageCollectionViewCell
        let imageUrl = breedImagesArray[indexPath.item]
        cell.imageView.loadImage(from: imageUrl)
        
        // Set like button state based on likedImages set
        cell.likeButton.isSelected = likedImages.contains(imageUrl)
        
        // Assign tag to like button to identify which cell's button is tapped
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    // Set size for collection view cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 5) / 2 // Adjust spacing
        return CGSize(width: width, height: width)
    }
    
    // Handle like button tap
    @objc func likeButtonTapped(_ sender: UIButton) {
        let imageUrl = breedImagesArray[sender.tag]
        if likedImages.contains(imageUrl) {
            likedImages.remove(imageUrl)
        } else {
            likedImages.insert(imageUrl)
        }
        print(likedImages)
        collectionView.reloadData() // Reload collection view to update like button states
    }
}
