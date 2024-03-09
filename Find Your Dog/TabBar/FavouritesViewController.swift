//
//  FavouritesViewController.swift
//  Find Your Dog
//
//  Created by Aditya Vyavahare on 09/03/24.
//

import UIKit

class FavouritesViewController: UIViewController {

    var likedImages: [String] = [] // Array to store liked image URLs
    
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
        title = "Favourites"
        view.backgroundColor = .white
//        fetchLikedImages()
//        print(likedImages)
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchLikedImages()
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
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
                collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
}

//fetch data
extension FavouritesViewController {
    func fetchLikedImages() {
            // Retrieve liked images from UserDefaults or another storage method
            if let likedImagesArray = UserDefaults.standard.array(forKey: "LikedImages") as? [String] {
                likedImages = likedImagesArray
            }
        collectionView.reloadData()
            // Here, you can optionally filter or sort the liked images based on breed
            // For simplicity, let's assume the likedImages array is already sorted or filtered
            displayLikedImages()    //not required
        }
    
    //not required
    func displayLikedImages() {
            // Create a collection view or table view to display the liked images
            // Populate the collection view or table view with the liked images
        }

        // Implement sorting functionality if needed
        // For example, you can provide options to sort by breed
        // Implement logic to sort the liked images based on the selected criteria
}

//collectionview config.
extension FavouritesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! BreedImageCollectionViewCell
        let imageUrl = likedImages[indexPath.item]
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
