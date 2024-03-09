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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBreedImages()
    }
}

extension BreedImagesViewController {
    func fetchBreedImages() {
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
                        // Update UI with fetched images
                        print(self.breedImagesArray)
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                // Handle error here (e.g., display an alert)
            }
        }.resume()
    }
}
