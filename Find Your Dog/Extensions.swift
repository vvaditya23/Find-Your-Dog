//
//  Extensions.swift
//  Find Your Dog
//
//  Created by Aditya Vyavahare on 09/03/24.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Create a URLSession data task to fetch the image data
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            // Check for errors
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            // Ensure we have received data
            guard let imageData = data else {
                print("No image data received")
                return
            }
            
            // Convert data to UIImage
            if let image = UIImage(data: imageData) {
                // Update UI on the main thread
                DispatchQueue.main.async {
                    // Set the image to the UIImageView
                    self.image = image
                }
            }
        }.resume() // Don't forget to resume the data task
    }
}
